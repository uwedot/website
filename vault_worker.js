'use strict';

const FetchTimeoutMs = 12000;
const UrlPattern = /^https?:/i;
const SummaryPattern = /^\d+\s+(?:total\s+)?(og file|full|tagged|partial(?:\s*\/\s*cut)?|snippet|stem bounce|unavailable)/i;
const ChangelogPattern = /^\((?:jan|feb|mar|apr|may|jun|jul|aug|sep|oct|nov|dec)[a-z]*\s+\d+(?:st|nd|rd|th)?,\s*\d{4}\)$/i;

function ParseCsv(Text) {
  const Rows = [];
  let Chars = [];
  let Row = [];
  let InQuotes = false;

  const PushField = () => { Row.push(Chars.join('')); Chars = []; };
  const PushRow = () => { PushField(); Rows.push(Row); Row = []; };

  for (let I = 0; I < Text.length; I++) {
    const Ch = Text[I];
    if (InQuotes) {
      if (Ch === '"' && Text[I + 1] === '"') { Chars.push('"'); I++; }
      else if (Ch === '"') InQuotes = false;
      else Chars.push(Ch);
    } else {
      if (Ch === '"') InQuotes = true;
      else if (Ch === ',') PushField();
      else if (Ch === '\n') PushRow();
      else if (Ch !== '\r') Chars.push(Ch);
    }
  }

  if (Chars.length || Row.length) PushRow();
  return Rows;
}

function BuildVaultData(Rows) {
  const EraMap = {};
  const EraDescs = {};
  if (Rows.length < 2) return { EraMap, EraDescs };

  let HeaderRowIdx = 0;
  for (let I = 0; I < Math.min(Rows.length, 10); I++) {
    const Headers = Rows[I].map(H => H.split('\n')[0].replace(/\r/g, '').trim().toLowerCase());
    if (Headers.includes('era') && Headers.some(H => H.includes('name'))) {
      HeaderRowIdx = I;
      break;
    }
  }

  const Headers = Rows[HeaderRowIdx].map(H => H.split('\n')[0].replace(/\r/g, '').trim().toLowerCase());

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
  let CurrentEra = '';

  for (let I = HeaderRowIdx + 1; I < Rows.length; I++) {
    const Row = Rows[I];
    if (!Row || Row.every(C => !C.trim())) continue;

    const Era = (Row[Cols.Era] || '').trim();
    const Name = (Row[Cols.Name] || '').trim();

    if (!Era || !Name) continue;
    if (ChangelogPattern.test(Era)) continue;

    if (SummaryPattern.test(Era)) {
      let Desc = '';
      for (let J = 0; J < Row.length; J++) {
        const Val = (Row[J] || '').trim();
        if (!Val || SkipSet.has(J) || UrlPattern.test(Val)) continue;
        if (Val.length > Desc.length) Desc = Val;
      }
      PendingDesc = Desc;
      CurrentEra = Era;
      continue;
    }
    if (SummaryPattern.test(Name)) continue;

    if (Era !== CurrentEra) {
      CurrentEra = Era;
    }

    if (PendingDesc) {
      const Key = Era.toLowerCase().replace(/\s+/g, ' ').trim();
      if (!EraDescs[Key]) EraDescs[Key] = PendingDesc;
      PendingDesc = '';
    }

    if (!EraMap[Era]) EraMap[Era] = [];
    EraMap[Era].push([
      Name,
      (Row[Cols.Quality] || '').trim(),
      Cols.Link >= 0 ? (Row[Cols.Link] || '').trim() : '',
      (Row[Cols.Notes] || '').trim(),
      Cols.LeakDate >= 0 ? (Row[Cols.LeakDate] || '').trim() : '',
      Cols.AvailLen >= 0 ? (Row[Cols.AvailLen] || '').trim() : '',
      '',
    ]);
  }

  return { EraMap, EraDescs };
}

async function FetchSheetCsv(SheetId, Gid, Signal) {
  const GidParam = Gid ? `&gid=${Gid}` : '';
  const Res = await fetch(
    `https://docs.google.com/spreadsheets/d/${SheetId}/export?format=csv${GidParam}`,
    { Signal }
  );
  if (!Res.ok) throw new Error(`HTTP ${Res.status}`);
  return Res.text();
}

let CurrentController = null;

async function HandleLoad(SheetId, Gid) {
  CurrentController?.abort();

  const Controller = new AbortController();
  CurrentController = Controller;
  const TimeoutId = setTimeout(() => Controller.abort(), FetchTimeoutMs);

  try {
    const CsvText = await FetchSheetCsv(SheetId, Gid, Controller.signal);
    clearTimeout(TimeoutId);
    if (CurrentController !== Controller) return;
    CurrentController = null;

    const Rows = ParseCsv(CsvText);
    const { EraMap, EraDescs } = BuildVaultData(Rows);
    self.postMessage({ type: 'SUCCESS', EraMap, EraDescs });
  } catch (Err) {
    clearTimeout(TimeoutId);
    if (CurrentController !== Controller) return;
    CurrentController = null;

    const IsAbort = Err.name === 'AbortError' || Err.name === 'TimeoutError';
    const IsHttp = Err.message?.startsWith('HTTP');

    self.postMessage({
      type: 'ERROR',
      reason: IsAbort ? 'timeout' : IsHttp ? 'http' : 'network',
      message: Err.message ?? String(Err),
    });
  }
}

self.addEventListener('message', ({ data }) => {
  if (data.type === 'ABORT') {
    CurrentController?.abort();
    CurrentController = null;
    return;
  }
  if (data.type === 'LOAD') HandleLoad(data.sheetId, data.gid);
});