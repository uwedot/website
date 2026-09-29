'use strict';

const FetchTimeoutMs = 12000;
const MaxAttempts = 3;
const UrlPattern = /^https?:/i;
const SummaryPattern = /^\d+\s+(?:total\s+)?(og file|full|tagged|partial(?:\s*\/\s*cut)?|snippet|stem bounce|unavailable)/i;
const ChangelogPattern = /^\((?:jan|feb|mar|apr|may|jun|jul|aug|sep|oct|nov|dec)[a-z]*\s+\d+(?:st|nd|rd|th)?,\s*\d{4}\)$/i;

class LoadError extends Error {
  constructor(reason, message, retryable = false) {
    super(message);
    this.reason = reason;
    this.retryable = retryable;
  }
}

function ParseCsv(Text) {
  if (Text.charCodeAt(0) === 0xFEFF) Text = Text.slice(1);
  const Rows = [];
  const N = Text.length;
  let Row = [];
  let Field = '';
  let I = 0;

  while (I < N) {
    const Ch = Text[I];
    if (Ch === '"') {
      I++;
      for (;;) {
        const Q = Text.indexOf('"', I);
        if (Q === -1) { Field += Text.slice(I); I = N; break; }
        Field += Text.slice(I, Q);
        if (Text[Q + 1] === '"') { Field += '"'; I = Q + 2; }
        else { I = Q + 1; break; }
      }
    } else if (Ch === ',') { Row.push(Field); Field = ''; I++; }
    else if (Ch === '\n') { Row.push(Field); Rows.push(Row); Row = []; Field = ''; I++; }
    else if (Ch === '\r') { I++; }
    else {
      let E = I + 1;
      while (E < N) {
        const C = Text.charCodeAt(E);
        if (C === 44 || C === 10 || C === 13 || C === 34) break;
        E++;
      }
      Field += Text.slice(I, E);
      I = E;
    }
  }
  if (Field !== '' || Row.length) { Row.push(Field); Rows.push(Row); }
  return Rows;
}

const HeaderCells = Row => Row.map(H => H.split('\n')[0].trim().toLowerCase());
const Cell = (Row, Idx) => (Row[Idx] || '').trim();

function BuildVaultData(Rows) {
  const EraMap = {};
  const EraDescs = {};
  if (Rows.length < 2) return { EraMap, EraDescs };

  const HeaderRowIdx = Math.max(0, Rows.slice(0, 10).findIndex(Row => {
    const Cells = HeaderCells(Row);
    return Cells.includes('era') && Cells.some(H => H.includes('name'));
  }));
  const Headers = HeaderCells(Rows[HeaderRowIdx]);

  const FindCol = (...Names) => {
    for (const N of Names) {
      const Idx = Headers.indexOf(N);
      if (Idx !== -1) return Idx;
    }
    return Headers.findIndex(H => Names.some(N => H.includes(N)));
  };

  const Cols = {
    Era: FindCol('era', 'all'),
    Name: FindCol('name'),
    Quality: FindCol('quality'),
    Link: FindCol('link(s)'),
    Notes: FindCol('notes'),
    LeakDate: FindCol('leak date'),
    AvailLen: FindCol('available length'),
  };
  const SkipSet = new Set([Cols.Era, Cols.Name, Cols.Quality, Cols.AvailLen, Cols.Notes]);

  let PendingDesc = '';

  for (const Row of Rows.slice(HeaderRowIdx + 1)) {
    const Era = Cell(Row, Cols.Era);
    const Name = Cell(Row, Cols.Name);
    if (!Era || !Name || ChangelogPattern.test(Era)) continue;

    if (SummaryPattern.test(Era)) {
      PendingDesc = Row.reduce((Best, Raw, J) => {
        const Val = Raw.trim();
        return Val.length > Best.length && !SkipSet.has(J) && !UrlPattern.test(Val) ? Val : Best;
      }, '');
      continue;
    }
    if (SummaryPattern.test(Name)) continue;

    if (PendingDesc) {
      const Key = Era.toLowerCase().replace(/\s+/g, ' ').trim();
      EraDescs[Key] ||= PendingDesc;
      PendingDesc = '';
    }

    (EraMap[Era] ??= []).push([
      Name,
      Cell(Row, Cols.Quality),
      Cell(Row, Cols.Link),
      Cell(Row, Cols.Notes),
      Cell(Row, Cols.LeakDate),
      Cell(Row, Cols.AvailLen),
    ]);
  }

  return { EraMap, EraDescs };
}

const Sleep = Ms => new Promise(Resolve => setTimeout(Resolve, Ms));

async function FetchCsv(SheetId) {
  const Url = `https://docs.google.com/spreadsheets/d/${encodeURIComponent(SheetId)}/export?format=csv`;
  for (let Attempt = 1; ; Attempt++) {
    const Controller = new AbortController();
    const TimeoutId = setTimeout(() => Controller.abort(), FetchTimeoutMs);
    try {
      const Res = await fetch(Url, { signal: Controller.signal, credentials: 'omit' });
      if (!Res.ok) throw new LoadError('http', `HTTP ${Res.status}`, Res.status >= 500 || Res.status === 429);
      if ((Res.headers.get('content-type') || '').includes('text/html')) throw new LoadError('http', 'HTTP 403');
      return await Res.text();
    } catch (Err) {
      const Failure = Err instanceof LoadError
        ? Err
        : new LoadError(Controller.signal.aborted ? 'timeout' : 'network', Err?.message ?? String(Err), true);
      if (!Failure.retryable || Attempt === MaxAttempts) throw Failure;
    } finally {
      clearTimeout(TimeoutId);
    }
    await Sleep(700 * 2 ** (Attempt - 1));
  }
}

self.onmessage = async ({ data: SheetId }) => {
  try {
    const { EraMap, EraDescs } = BuildVaultData(ParseCsv(await FetchCsv(SheetId)));
    if (!Object.keys(EraMap).length) throw new LoadError('empty', 'No songs found in sheet');
    self.postMessage({ type: 'SUCCESS', json: JSON.stringify({ EraMap, EraDescs }) });
  } catch (Err) {
    self.postMessage({ type: 'ERROR', reason: Err.reason || 'network', message: Err.message ?? String(Err) });
  }
};
