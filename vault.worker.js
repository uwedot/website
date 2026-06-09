'use strict';

const FetchTimeoutMs = 12_000;

const SummaryPattern   = /^\d+\s+(?:total\s+)?(og file|full|tagged|partial(?:\s*\/\s*cut)?|snippet|stem bounce|unavailable)/i;
const ChangelogPattern = /^\((?:jan|feb|mar|apr|may|jun|jul|aug|sep|oct|nov|dec)[a-z]*\s+\d+(?:st|nd|rd|th)?,\s*\d{4}\)$/i;

function parseCsv(text) {
  const rows = [];
  let field = '';
  let row = [];
  let inQuotes = false;
  for (let i = 0; i < text.length; i++) {
    const ch = text[i];
    if (inQuotes) {
      if (ch === '"' && text[i + 1] === '"') { field += '"'; i++; }
      else if (ch === '"')  inQuotes = false;
      else                  field += ch;
    } else {
      if      (ch === '"')  inQuotes = true;
      else if (ch === ',')  { row.push(field); field = ''; }
      else if (ch === '\n') { row.push(field); rows.push(row); row = []; field = ''; }
      else if (ch !== '\r') field += ch;
    }
  }
  if (field || row.length) { row.push(field); rows.push(row); }
  return rows;
}

function normaliseHeader(h) {
  return h.split('\n')[0].trim().toLowerCase();
}

function normaliseKey(s) {
  return s.toLowerCase().replace(/\s+/g, ' ').trim();
}

function buildVaultData(rows) {
  const eraMap   = {};
  const eraDescs = {};
  if (rows.length < 2) return { eraMap, eraDescs };

  let headerRowIdx = 0;
  for (let i = 0; i < Math.min(rows.length, 10); i++) {
    const candidate = rows[i].map(normaliseHeader);
    if (candidate.includes('era') && candidate.some(h => h.includes('name'))) {
      headerRowIdx = i;
      break;
    }
  }

  const headers = rows[headerRowIdx].map(normaliseHeader);

  const findCol = (...names) => {
    for (const n of names) {
      const idx = headers.indexOf(n);
      if (idx !== -1) return idx;
    }
    return headers.findIndex(h => names.some(n => h.includes(n)));
  };

  const cols = {
    era:      findCol('era'),
    name:     findCol('name'),
    quality:  findCol('quality'),
    link:     findCol('link(s)', 'link'),
    notes:    findCol('notes'),
    leakDate: findCol('leak date', 'date'),
    availLen: findCol('available length'),
  };

  let pendingDesc = '';

  for (let i = headerRowIdx + 1; i < rows.length; i++) {
    const row = rows[i];
    if (!row || row.every(c => !c.trim())) continue;

    const era  = (row[cols.era]  || '').trim();
    const name = (row[cols.name] || '').trim();
    if (!era || !name) continue;
    if (ChangelogPattern.test(era)) continue;

    if (SummaryPattern.test(era)) {
      const skipSet = new Set([cols.era, cols.name, cols.quality, cols.availLen, cols.notes]);
      let desc = '';
      for (let j = 0; j < row.length; j++) {
        const val = (row[j] || '').trim();
        if (!val || skipSet.has(j) || /^https?:/i.test(val)) continue;
        if (val.length > desc.length) desc = val;
      }
      pendingDesc = desc;
      continue;
    }

    if (SummaryPattern.test(name)) continue;

    if (pendingDesc) {
      const key = normaliseKey(era);
      if (!eraDescs[key]) eraDescs[key] = pendingDesc;
      pendingDesc = '';
    }

    if (!eraMap[era]) eraMap[era] = [];
    eraMap[era].push([
      name,
      (row[cols.quality] || '').trim(),
      cols.link    >= 0 ? (row[cols.link]    || '').trim() : '',
      (row[cols.notes]   || '').trim(),
      cols.leakDate >= 0 ? (row[cols.leakDate] || '').trim() : '',
      cols.availLen >= 0 ? (row[cols.availLen] || '').trim() : '',
    ]);
  }

  return { eraMap, eraDescs };
}

async function fetchSheetCsv(sheetId, signal) {
  const res = await fetch(
    `https://docs.google.com/spreadsheets/d/${sheetId}/export?format=csv`,
    { signal }
  );
  if (!res.ok) throw new Error(`HTTP ${res.status}`);
  return res.text();
}

let currentController = null;

self.addEventListener('message', async ({ data }) => {
  if (data.type === 'ABORT') {
    currentController?.abort();
    currentController = null;
    return;
  }

  if (data.type !== 'LOAD') return;

  currentController?.abort();

  const controller = new AbortController();
  currentController = controller;
  const timeoutId  = setTimeout(() => controller.abort(), FetchTimeoutMs);

  try {
    const csvText = await fetchSheetCsv(data.sheetId, controller.signal);
    clearTimeout(timeoutId);

    if (currentController !== controller) return;
    currentController = null;

    const rows = parseCsv(csvText);
    const { eraMap, eraDescs } = buildVaultData(rows);

    self.postMessage({ type: 'SUCCESS', eraMap, eraDescs });
  } catch (err) {
    clearTimeout(timeoutId);
    if (currentController !== controller) return;
    currentController = null;

    const isAbort = err.name === 'AbortError' || err.name === 'TimeoutError';
    const isHttp  = err.message?.startsWith('HTTP');

    self.postMessage({
      type:    'ERROR',
      reason:  isAbort ? 'timeout' : isHttp ? 'http' : 'network',
      message: err.message ?? String(err),
    });
  }
});
