'use strict';

const FETCH_TIMEOUT_MS = 12_000;
const URL_PATTERN      = /^https?:/i;

const SUMMARY_PATTERN   = /^\d+\s+(?:total\s+)?(og file|full|tagged|partial(?:\s*\/\s*cut)?|snippet|stem bounce|unavailable)/i;
const CHANGELOG_PATTERN = /^\((?:jan|feb|mar|apr|may|jun|jul|aug|sep|oct|nov|dec)[a-z]*\s+\d+(?:st|nd|rd|th)?,\s*\d{4}\)$/i;

const STEM_CATEGORIES   = ['Studio Stems', 'Instrumentals', 'Acapellas', 'TV Tracks', 'Stem Player Stems', 'Sessions'];
const STEM_CATEGORY_MAP = new Map(STEM_CATEGORIES.map(c => [c.toLowerCase(), c]));

function parseCsv(text) {
  const rows = [];
  let chars    = [];
  let row      = [];
  let inQuotes = false;

  const pushField = () => { row.push(chars.join('')); chars = []; };
  const pushRow   = () => { pushField(); rows.push(row); row = []; };

  for (let i = 0; i < text.length; i++) {
    const ch = text[i];
    if (inQuotes) {
      if (ch === '"' && text[i + 1] === '"') { chars.push('"'); i++; }
      else if (ch === '"')  inQuotes = false;
      else                  chars.push(ch);
    } else {
      if      (ch === '"')  inQuotes = true;
      else if (ch === ',')  pushField();
      else if (ch === '\n') pushRow();
      else if (ch !== '\r') chars.push(ch);
    }
  }

  if (chars.length || row.length) pushRow();
  return rows;
}

function normaliseHeader(h) {
  return h.split('\n')[0].replace(/\r/g, '').trim().toLowerCase();
}

function normaliseKey(s) {
  return s.toLowerCase().replace(/\s+/g, ' ').trim();
}

function findHeaderRowIndex(rows) {
  for (let i = 0; i < Math.min(rows.length, 10); i++) {
    const candidate = rows[i].map(normaliseHeader);
    if (candidate.includes('era') && candidate.some(h => h.includes('name'))) return i;
  }
  return 0;
}

function resolveColumns(headers) {
  const findCol = (...names) => {
    for (const n of names) {
      const idx = headers.indexOf(n);
      if (idx !== -1) return idx;
    }
    return headers.findIndex(h => names.some(n => h.includes(n)));
  };

  return {
    era:      findCol('era'),
    name:     findCol('name'),
    quality:  findCol('quality'),
    link:     findCol('link(s)', 'link'),
    notes:    findCol('notes'),
    leakDate: findCol('leak date', 'date'),
    availLen: findCol('available length'),
  };
}

function extractEraDescription(row, cols, skipSet) {
  let desc = '';
  for (let j = 0; j < row.length; j++) {
    const val = (row[j] || '').trim();
    if (!val || skipSet.has(j) || URL_PATTERN.test(val)) continue;
    if (val.length > desc.length) desc = val;
  }
  return desc;
}

function buildVaultData(rows) {
  const eraMap   = {};
  const eraDescs = {};
  if (rows.length < 2) return { eraMap, eraDescs };

  const headerRowIdx = findHeaderRowIndex(rows);
  const headers      = rows[headerRowIdx].map(normaliseHeader);
  const cols         = resolveColumns(headers);
  const skipSet      = new Set([cols.era, cols.name, cols.quality, cols.availLen, cols.notes]);

  let pendingDesc  = '';
  let currentEra   = '';
  let currentCat   = '';

  for (let i = headerRowIdx + 1; i < rows.length; i++) {
    const row = rows[i];
    if (!row || row.every(c => !c.trim())) continue;

    const era  = (row[cols.era]  || '').trim();
    const name = (row[cols.name] || '').trim();

    if (!era && name) {
      const catMatch = STEM_CATEGORY_MAP.get(name.toLowerCase());
      if (catMatch) { currentCat = catMatch; continue; }
    }

    if (!era || !name) continue;
    if (CHANGELOG_PATTERN.test(era)) continue;

    if (SUMMARY_PATTERN.test(era)) {
      pendingDesc = extractEraDescription(row, cols, skipSet);
      currentEra  = era;
      currentCat  = '';
      continue;
    }
    if (SUMMARY_PATTERN.test(name)) continue;

    if (era !== currentEra) {
      currentEra = era;
      currentCat = '';
    }

    if (pendingDesc) {
      const key = normaliseKey(era);
      if (!eraDescs[key]) eraDescs[key] = pendingDesc;
      pendingDesc = '';
    }

    if (!eraMap[era]) eraMap[era] = [];
    eraMap[era].push([
      name,
      (row[cols.quality] || '').trim(),
      cols.link     >= 0 ? (row[cols.link]     || '').trim() : '',
      (row[cols.notes]   || '').trim(),
      cols.leakDate >= 0 ? (row[cols.leakDate] || '').trim() : '',
      cols.availLen >= 0 ? (row[cols.availLen] || '').trim() : '',
      '',
      currentCat,
    ]);
  }

  return { eraMap, eraDescs };
}

async function fetchSheetCsv(sheetId, gid, signal) {
  const gidParam = gid ? `&gid=${gid}` : '';
  const res = await fetch(
    `https://docs.google.com/spreadsheets/d/${sheetId}/export?format=csv${gidParam}`,
    { signal }
  );
  if (!res.ok) throw new Error(`HTTP ${res.status}`);
  return res.text();
}

let currentController = null;

async function handleLoad(sheetId, gid) {
  currentController?.abort();

  const controller  = new AbortController();
  currentController = controller;
  const timeoutId   = setTimeout(() => controller.abort(), FETCH_TIMEOUT_MS);

  try {
    const csvText = await fetchSheetCsv(sheetId, gid, controller.signal);
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
}

self.addEventListener('message', ({ data }) => {
  if (data.type === 'ABORT') {
    currentController?.abort();
    currentController = null;
    return;
  }
  if (data.type === 'LOAD') handleLoad(data.sheetId, data.gid);
});