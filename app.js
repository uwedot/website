'use strict';

const DefaultSheetId     = '12nGHPPh5dVTfLuBLVQYzC3QgPxKfvp-jgCoNccvEasM';
const RecentSongsLimit   = 200;
const SheetRateWindowMs  = 60_000;
const SheetRateMax       = 3;
const SearchDebounceMs   = 200;
const ReloadCountdownMs  = 5_000;

const TabMarkers = {
  best:    ['⭐'],
  special: ['✨'],
  grails:  ['🏆', '🏅'],
  ai:      ['🤖'],
};

const QualityMap = [
  { key: 'lossless', cls: 'q-lossless', test: l => l.includes('lossless') },
  { key: 'high',     cls: 'q-high',     test: l => l.includes('high') },
  { key: 'cd',       cls: 'q-cd',       test: l => l.includes('cd') },
  { key: 'rec',      cls: 'q-rec',      test: l => l.includes('record') },
  { key: 'low',      cls: 'q-low',      test: l => l.includes('low') },
  { key: 'unavail',  cls: null,         test: l => l.includes('not avail') || l.includes('unavail') },
];

const AvailLenClassMap = [
  { test: l => /\bog\b/.test(l),        cls: 'tl-og' },
  { test: l => l.includes('lossless'),  cls: 'tl-other' },
  { test: l => l.includes('stem'),      cls: 'tl-stem' },
  { test: l => l.includes('full'),      cls: 'tl-full' },
  { test: l => l.includes('tagged'),    cls: 'tl-tagged' },
  { test: l => l.includes('partial'),   cls: 'tl-partial' },
  { test: l => l.includes('snippet'),   cls: 'tl-snippet' },
  { test: l => l.includes('unavail'),   cls: 'tl-unavail' },
  { test: l => l.includes('confirmed'), cls: 'tl-confirmed' },
  { test: l => l.includes('rumored'),   cls: 'tl-rumored' },
  { test: l => l.includes('vox'),       cls: 'tl-vox' },
];

const VersionPattern = /[[(]v(?:ersion)?\s*\d+[\])]/i;
const PillowsHost    = 'pillows.su/f/';
const PillowsApi     = 'api.pillows.su/api/get/';

const state = {
  primarySheetId:        DefaultSheetId,
  vaultData:             null,
  eraDescriptions:       {},
  currentTab:            'all',
  activeQualities:       new Set(['high', 'low', 'rec', 'cd', 'lossless', 'unavail']),
  showPlayableOnly:      false,
  hasOpenDropdown:       false,
  searchDebounceId:      null,
  countdownId:           null,
  cooldownIntervalId:    null,
  sheetChangeTimestamps: JSON.parse(localStorage.getItem('sheetChangeTs') || '[]').filter(t => Date.now() - t < SheetRateWindowMs),
};

const playBtnMap = new Map();
const openPanels = new Set();
const dateCache  = new Map();

function escapeHtml(str) {
  return String(str)
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;');
}

function formatTime(seconds) {
  if (!isFinite(seconds) || seconds < 0) return '0:00';
  const s = Math.floor(seconds);
  return `${Math.floor(s / 60)}:${String(s % 60).padStart(2, '0')}`;
}

function formatCountdown(ms) {
  if (ms <= 0) return '0s';
  const totalSec = Math.ceil(ms / 1000);
  const min = Math.floor(totalSec / 60);
  const sec = totalSec % 60;
  return min > 0 ? `${min}m ${sec}s` : `${sec}s`;
}

function parseDateToTimestamp(dateStr) {
  if (!dateStr) return 0;
  const cached = dateCache.get(dateStr);
  if (cached !== undefined) return cached;
  let result = Date.parse(dateStr);
  if (isNaN(result)) {
    const m = dateStr.match(/\b(19|20)\d{2}\b/);
    result = m ? new Date(m[0], 0, 1).getTime() : 0;
  }
  if (dateCache.size >= 500) dateCache.clear();
  dateCache.set(dateStr, result);
  return result;
}

function resolveUrl(url) {
  try { return new URL(url).href; } catch { return url; }
}

function safePlay(audio) {
  audio.play().catch(e => { if (e.name !== 'AbortError') console.warn('Play failed:', e); });
}

function normaliseHeader(h) {
  return h.split('\n')[0].trim().toLowerCase();
}

function normaliseKey(s) {
  return s.toLowerCase().replace(/\s+/g, ' ').trim();
}

function getQualityClass(quality) {
  if (!quality) return 'q-other';
  const l = quality.toLowerCase();
  for (const { test, cls } of QualityMap) {
    if (cls && test(l)) return cls;
  }
  return 'q-other';
}

function getAvailableLengthClass(availLen) {
  if (!availLen) return 'tl-other';
  const l = availLen.toLowerCase();
  for (const { test, cls } of AvailLenClassMap) {
    if (test(l)) return cls;
  }
  return 'tl-other';
}

function isQualityVisible(quality) {
  const l = (quality || '').toLowerCase();
  if (!l) return state.activeQualities.has('unavail');
  for (const { key, test } of QualityMap) {
    if (state.activeQualities.has(key) && test(l)) return true;
  }
  return false;
}

function isPlayable(linkString, quality) {
  if (!linkString) return false;
  const q = (quality || '').toLowerCase();
  if (q.includes('unavail') || q.includes('not avail')) return false;
  return linkString.split(/[\s,\n\r]+/).some(u => u.includes(PillowsHost));
}

function registerPlayBtn(btn, resolvedUrl) {
  if (!playBtnMap.has(resolvedUrl)) playBtnMap.set(resolvedUrl, new Set());
  playBtnMap.get(resolvedUrl).add(btn);
}

function syncPlayButtonStates(audio) {
  if (!audio) return;
  const current = audio.src ? resolveUrl(audio.src) : '';
  const playing = !audio.paused;
  for (const [href, btns] of playBtnMap) {
    const label = (href === current && playing) ? 'Pause' : 'Play';
    for (const btn of btns) btn.textContent = label;
  }
}

function closeAllLinkDropdowns() {
  if (!state.hasOpenDropdown) return;
  document.querySelectorAll('.song-dropdown-menu.open').forEach(m => {
    m.classList.remove('open');
    const btn = m.previousElementSibling;
    if (btn) btn.setAttribute('aria-expanded', 'false');
  });
  state.hasOpenDropdown = false;
}

function toggleDropdown(btn, menu) {
  const isOpen = menu.classList.toggle('open');
  btn.setAttribute('aria-expanded', String(isOpen));
}

function closeDropdown(btn, menu) {
  menu.classList.remove('open');
  btn.setAttribute('aria-expanded', 'false');
}

function collapsePanel(panel) {
  if (!openPanels.has(panel)) return;
  panel.classList.remove('open');
  openPanels.delete(panel);
  const eraRow = panel.previousElementSibling;
  if (eraRow) {
    eraRow.classList.remove('active');
    eraRow.setAttribute('aria-expanded', 'false');
  }
}

function collapseAllEraPanels() {
  for (const panel of [...openPanels]) collapsePanel(panel);
}

function openPanel(panel, eraRow) {
  panel.classList.add('open');
  openPanels.add(panel);
  eraRow.classList.add('active');
  eraRow.setAttribute('aria-expanded', 'true');
}

function setMediaSession(trackName) {
  if (!('mediaSession' in navigator)) return;
  navigator.mediaSession.metadata = new MediaMetadata({
    title:  trackName,
    artist: 'Mistape',
  });
}

function bindMediaSessionHandlers(audio) {
  if (!('mediaSession' in navigator)) return;
  const ms = navigator.mediaSession;
  ms.setActionHandler('play',         () => safePlay(audio));
  ms.setActionHandler('pause',        () => audio.pause());
  ms.setActionHandler('stop',         () => { audio.pause(); audio.currentTime = 0; });
  ms.setActionHandler('seekto',       d => { if (d.seekTime !== undefined && audio.duration) audio.currentTime = d.seekTime; });
  ms.setActionHandler('seekbackward', d => { audio.currentTime = Math.max(0, audio.currentTime - (d.seekOffset || 10)); });
  ms.setActionHandler('seekforward',  d => { audio.currentTime = Math.min(audio.duration || 0, audio.currentTime + (d.seekOffset || 10)); });
}

function buildSongElement({ songName, quality, linkString, notes, trackNumber, availLen, audio, rawName, recentEra, leakDate }) {
  const safeNotes = (notes || '').trim();
  const hasNotes  = safeNotes !== '';

  const links = linkString
    ? linkString.split(/[\s,\n\r]+/).map(u => u.trim()).filter(u => /^https?:/i.test(u))
    : [];

  const availLower      = (availLen || '').toLowerCase();
  const isRumoredOrConf = availLower.includes('rumored') || availLower.includes('confirmed');
  const displayQuality  = (links.length > 0 || isRumoredOrConf) ? quality : 'Unavailable';
  const isUnavailable   = !displayQuality ||
    displayQuality.toLowerCase().includes('unavail') ||
    displayQuality.toLowerCase().includes('not avail');

  const pillowsLink = links.find(u => u.includes(PillowsHost));
  let playBtnHtml = '';
  let downloadUrl = '';

  if (pillowsLink && !isUnavailable) {
    downloadUrl = pillowsLink.replace(PillowsHost, PillowsApi);
    let btnLabel = 'Play';
    if (audio?.src) {
      try {
        if (resolveUrl(audio.src) === resolveUrl(downloadUrl) && !audio.paused) btnLabel = 'Pause';
      } catch {}
    }
    playBtnHtml = `<button type="button" class="song-play-btn play-btn" data-name="${escapeHtml(rawName || songName)}">${btnLabel}</button>`;
  }

  let linksHtml = '';
  if (links.length > 1) {
    const items = links.map((url, i) =>
      `<a class="song-dropdown-item" href="${escapeHtml(url)}" target="_blank" rel="noopener noreferrer">Link ${i + 1}</a>`
    ).join('');
    linksHtml = `<div class="song-dropdown">
      <button type="button" class="song-dropdown-btn" aria-haspopup="true" aria-expanded="false">
        <span>Links</span>
        <svg class="dropdown-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true"><polyline points="6,9 12,15 18,9"/></svg>
      </button>
      <div class="song-dropdown-menu" role="menu">${items}</div>
    </div>`;
  } else if (links.length === 1) {
    linksHtml = `<a class="song-link-btn" href="${escapeHtml(links[0])}" target="_blank" rel="noopener noreferrer">View</a>`;
  }

  const noteToggleHtml = hasNotes
    ? `<div class="note-toggle" role="button" tabindex="0" aria-label="Show note">+</div>`
    : '';

  const versionMatch    = VersionPattern.exec(songName);
  const versionPillHtml = versionMatch
    ? `<div class="song-version-pill">${escapeHtml(versionMatch[0].replace(/[[\]()]/g, ''))}</div>`
    : '';
  const displayName = versionMatch
    ? songName.replace(versionMatch[0], '').replace(/\s{2,}/g, ' ').trim()
    : songName;

  let topRowHtml = '';
  if (recentEra) {
    let datePillHtml = '';
    if (leakDate) {
      const parsed = new Date(leakDate);
      if (!isNaN(parsed)) {
        const dd   = String(parsed.getUTCDate()).padStart(2, '0');
        const mm   = String(parsed.getUTCMonth() + 1).padStart(2, '0');
        const yyyy = parsed.getUTCFullYear();
        datePillHtml = `<div class="song-date-pill">${dd}/${mm}/${yyyy}</div>`;
      } else {
        datePillHtml = `<div class="song-date-pill">${escapeHtml(leakDate)}</div>`;
      }
    }
    topRowHtml = `<div class="song-top-row"><div class="song-era-pill">${escapeHtml(recentEra)}</div>${datePillHtml}</div>`;
  }

  const pillsHtml =
    versionPillHtml +
    (displayQuality ? `<div class="song-quality ${getQualityClass(displayQuality)}">${escapeHtml(displayQuality)}</div>` : '') +
    (availLen       ? `<div class="song-type ${getAvailableLengthClass(availLen)}">${escapeHtml(availLen)}</div>` : '');

  const songEl = document.createElement('div');
  songEl.className = 'song-item';
  songEl.setAttribute('role', 'listitem');
  songEl.innerHTML = `
    <div class="song-num">${trackNumber}</div>
    <div class="song-body">
      ${topRowHtml}
      <div class="song-name" title="${escapeHtml(songName)}">${escapeHtml(displayName)}</div>
      <div class="song-pills">${pillsHtml}</div>
    </div>
    <div class="song-btns">${playBtnHtml}${linksHtml}${noteToggleHtml}</div>
  `;

  if (links.length > 1) {
    const dropBtn  = songEl.querySelector('.song-dropdown-btn');
    const dropMenu = songEl.querySelector('.song-dropdown-menu');
    dropBtn.addEventListener('click', ev => {
      ev.stopPropagation();
      const wasOpen = dropMenu.classList.contains('open');
      closeAllLinkDropdowns();
      if (!wasOpen) {
        dropMenu.classList.add('open');
        dropBtn.setAttribute('aria-expanded', 'true');
        state.hasOpenDropdown = true;
      }
    });
  }

  const playBtn = songEl.querySelector('.play-btn');
  if (playBtn && downloadUrl) {
    const resolved = resolveUrl(downloadUrl);
    registerPlayBtn(playBtn, resolved);
    playBtn.addEventListener('click', ev => {
      ev.stopPropagation();
      closeAllLinkDropdowns();
      const player  = document.getElementById('global-player');
      const current = audio.src ? resolveUrl(audio.src) : '';
      if (current === resolved) {
        if (audio.paused) {
          safePlay(audio);
        } else {
          audio.pause();
        }
      } else {
        document.getElementById('player-track-name').textContent = playBtn.dataset.name;
        setMediaSession(playBtn.dataset.name);
        audio.pause();
        audio.removeAttribute('src');
        audio.load();
        audio.src = resolved;
        player.removeAttribute('hidden');
        safePlay(audio);
      }
    });
  }

  if (hasNotes) {
    const noteEl = document.createElement('div');
    noteEl.className   = 'song-note';
    noteEl.textContent = safeNotes;
    const noteToggle = songEl.querySelector('.note-toggle');
    const toggleNote = () => {
      const expanded = songEl.classList.toggle('expanded');
      noteToggle.textContent = expanded ? '-' : '+';
      noteToggle.setAttribute('aria-label', expanded ? 'Hide note' : 'Show note');
    };
    noteToggle.addEventListener('click', ev => { ev.stopPropagation(); toggleNote(); });
    noteToggle.addEventListener('keydown', ev => {
      if (ev.key === 'Enter' || ev.key === ' ') { ev.preventDefault(); toggleNote(); }
    });
    return [songEl, noteEl];
  }

  return [songEl];
}

function renderSongs(songs, container, audio) {
  const frag = document.createDocumentFragment();
  songs.forEach(([name, quality, link, notes, leakDate, availLen, rawName, recentEra], idx) => {
    buildSongElement({
      songName:    name,
      quality,
      linkString:  link,
      notes,
      trackNumber: idx + 1,
      availLen:    availLen  || '',
      audio,
      rawName,
      recentEra:   recentEra || '',
      leakDate:    leakDate  || '',
    }).forEach(node => frag.appendChild(node));
  });
  container.appendChild(frag);
  syncPlayButtonStates(audio);
}

function buildRecentEras(filterLower) {
  const flat = [];
  for (const [era, songs] of Object.entries(state.vaultData)) {
    for (const s of songs) {
      const [, q] = s;
      if (!isQualityVisible(q)) continue;
      if (state.showPlayableOnly && !isPlayable(s[2], q)) continue;
      flat.push({ era, name: s[0], quality: q, link: s[2], notes: s[3], leakDate: s[4] || '', availLen: s[5] || '' });
    }
  }
  flat.sort((a, b) => parseDateToTimestamp(b.leakDate) - parseDateToTimestamp(a.leakDate));
  const pool     = flat.slice(0, RecentSongsLimit);
  const filtered = filterLower
    ? pool.filter(s => s.name.toLowerCase().includes(filterLower) || s.era.toLowerCase().includes(filterLower))
    : pool;
  if (!filtered.length) return {};
  return {
    'Recent Leaks': filtered.map(s => [s.name, s.quality, s.link, s.notes, s.leakDate, s.availLen, s.name, s.era]),
  };
}

function buildVisibleEras(filterLower) {
  if (state.currentTab === 'recent') return buildRecentEras(filterLower);
  const markers = TabMarkers[state.currentTab] || null;
  const result  = {};
  for (const [era, songs] of Object.entries(state.vaultData)) {
    let matched = songs.filter(([, q]) => isQualityVisible(q));
    if (state.showPlayableOnly) matched = matched.filter(([, q, link]) => isPlayable(link, q));
    if (markers)     matched = matched.filter(([n]) => markers.some(m => n.includes(m)));
    if (filterLower) matched = matched.filter(([n]) => n.toLowerCase().includes(filterLower) || era.toLowerCase().includes(filterLower));
    if (matched.length) result[era] = matched;
  }
  return result;
}

function updateNavStats(total) {
  document.getElementById('nav-songs').textContent = total.toLocaleString();
}

function buildEraElement(era, songs, audio) {
  const eraWrap = document.createElement('div');
  eraWrap.className = 'era-wrap';
  eraWrap.setAttribute('role', 'listitem');

  const eraRow = document.createElement('div');
  eraRow.className = 'era-row';
  eraRow.setAttribute('role', 'button');
  eraRow.setAttribute('tabindex', '0');
  eraRow.setAttribute('aria-expanded', 'false');
  eraRow.innerHTML = `
    <div class="era-row-name">${escapeHtml(era)}</div>
    <div class="era-row-right">
      <div class="era-pill">${songs.length}</div>
      <svg class="era-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
        <polyline points="6,9 12,15 18,9"/>
      </svg>
    </div>
  `;

  const songsPanel = document.createElement('div');
  songsPanel.className = 'songs-panel';

  const eraDesc = state.eraDescriptions[normaliseKey(era)] || '';
  if (eraDesc) {
    const descBlock = document.createElement('div');
    descBlock.className   = 'era-desc-block';
    descBlock.textContent = eraDesc;
    songsPanel.appendChild(descBlock);
  }

  const songsInner = document.createElement('div');
  songsInner.className = 'songs-inner';
  songsInner.setAttribute('role', 'list');
  songsInner.setAttribute('aria-label', `${era} songs`);
  songsPanel.appendChild(songsInner);

  const toggle = () => {
    closeAllLinkDropdowns();
    if (openPanels.has(songsPanel)) {
      collapsePanel(songsPanel);
    } else {
      collapseAllEraPanels();
      openPanel(songsPanel, eraRow);
      eraRow.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
      if (!songsInner.dataset.loaded) {
        songsInner.dataset.loaded = '1';
        renderSongs(songs, songsInner, audio);
      }
    }
  };

  eraRow.addEventListener('click', toggle);
  eraRow.addEventListener('keydown', ev => {
    if (ev.key === 'Enter' || ev.key === ' ') { ev.preventDefault(); toggle(); }
  });

  eraWrap.appendChild(eraRow);
  eraWrap.appendChild(songsPanel);
  return eraWrap;
}

function renderEras(searchFilter, audio) {
  const eraListEl = document.getElementById('era-list');
  if (!eraListEl || !state.vaultData) return;

  const filterLower = (searchFilter || '').trim().toLowerCase();
  const visible     = buildVisibleEras(filterLower);
  const keys        = Object.keys(visible);
  const total       = keys.reduce((sum, k) => sum + visible[k].length, 0);

  collapseAllEraPanels();
  closeAllLinkDropdowns();
  playBtnMap.clear();
  updateNavStats(total);

  const frag = document.createDocumentFragment();
  if (!keys.length) {
    const empty = document.createElement('div');
    empty.className   = 'no-results';
    empty.textContent = 'No results found.';
    frag.appendChild(empty);
  } else {
    for (const era of keys) frag.appendChild(buildEraElement(era, visible[era], audio));
  }
  eraListEl.replaceChildren(frag);
  openPanels.clear();
}

function getSheetRateState() {
  const now            = Date.now();
  const recentTs       = state.sheetChangeTimestamps.filter(t => now - t < SheetRateWindowMs);
  const remaining      = SheetRateMax - recentTs.length;
  const oldestInWindow = recentTs[0] ?? null;
  const cooldownMs     = (remaining <= 0 && oldestInWindow)
    ? SheetRateWindowMs - (now - oldestInWindow)
    : 0;
  return { remaining, cooldownMs };
}

function recordSheetChange() {
  const now = Date.now();
  state.sheetChangeTimestamps = state.sheetChangeTimestamps.filter(t => now - t < SheetRateWindowMs);
  state.sheetChangeTimestamps.push(now);
  localStorage.setItem('sheetChangeTs', JSON.stringify(state.sheetChangeTimestamps));
}

const vaultWorker = new Worker('vault.worker.js');

let _vaultLoadId = 0;

function loadVaultData(audio, statusEl = null) {
  const loadId = ++_vaultLoadId;

  const showError = text => {
    let target = statusEl;
    if (!target) {
      target = document.createElement('div');
      document.getElementById('era-list').replaceChildren(target);
    }
    target.className   = 'error-msg';
    target.textContent = text;
  };

  vaultWorker.postMessage({ type: 'ABORT' });
  vaultWorker.postMessage({ type: 'LOAD', sheetId: state.primarySheetId });

  vaultWorker.onmessage = ({ data }) => {
    if (loadId !== _vaultLoadId) return;

    if (data.type === 'SUCCESS') {
      state.vaultData       = data.eraMap;
      state.eraDescriptions = data.eraDescs;
      renderEras('', audio);
      return;
    }

    if (data.type === 'ERROR') {
      console.error('Vault worker error:', data.message);
      const errText =
        data.reason === 'timeout' ? 'Request timed out, check your connection and try reloading.'
        : data.reason === 'http'  ? `Failed to load sheet (${data.message}), make sure it is publicly shared.`
        :                           'Failed to load data, check your connection or sheet permissions.';
      showError(errText);
    }
  };

  vaultWorker.onerror = err => {
    if (loadId !== _vaultLoadId) return;
    console.error('Vault worker uncaught error:', err);
    showError('An unexpected error occurred while loading data.');
  };
}

function reloadWithSheetId(newId, audio) {
  if (state.countdownId !== null) {
    clearTimeout(state.countdownId);
    state.countdownId = null;
  }
  vaultWorker.postMessage({ type: 'ABORT' });

  state.primarySheetId  = newId;
  state.vaultData       = null;
  state.eraDescriptions = {};

  const eraList   = document.getElementById('era-list');
  const startTime = Date.now();
  const msgEl     = document.createElement('div');
  msgEl.className = 'loading-msg';
  eraList.replaceChildren(msgEl);

  const tick = () => {
    const elapsed   = Date.now() - startTime;
    const remaining = Math.max(0, ReloadCountdownMs - elapsed);
    msgEl.textContent = `Loading in ${formatCountdown(remaining)}…`;
    if (remaining <= 0) {
      state.countdownId = null;
      msgEl.textContent = 'Loading Data…';
      loadVaultData(audio, msgEl);
    } else {
      state.countdownId = setTimeout(tick, 1_000);
    }
  };

  tick();
}

function initPlayer(audio, playerEl) {
  if (!audio) return;

  const playIcon       = document.getElementById('player-play-icon');
  const pauseIcon      = document.getElementById('player-pause-icon');
  const playPauseBtn   = document.getElementById('player-play-btn');
  const closeBtn       = document.getElementById('player-close-btn');
  const currentTimeEl  = document.getElementById('player-current');
  const durationEl     = document.getElementById('player-duration');
  const trackCurrentEl = document.getElementById('player-track-current');
  const trackLengthEl  = document.getElementById('player-track-length');
  const progressFill   = document.getElementById('player-fill');
  const progressThumb  = document.getElementById('player-thumb');
  const volFill        = document.getElementById('player-vol-fill');
  const volThumb       = document.getElementById('player-vol-thumb');
  const scrubberEl     = document.getElementById('player-scrubber');
  const volumeSlider   = document.getElementById('player-volume');

  const setPlayState = playing => {
    playIcon.style.display  = playing ? 'none' : '';
    pauseIcon.style.display = playing ? '' : 'none';
    playPauseBtn.setAttribute('aria-label', playing ? 'Pause' : 'Play');
  };

  const clamp = (v, lo, hi) => Math.max(lo, Math.min(hi, v));

  const setProgress = pct => {
    const c = clamp(pct, 0, 100);
    progressFill.style.width = progressThumb.style.left = `${c}%`;
    scrubberEl.setAttribute('aria-valuenow', Math.round(c));
  };

  const setVolume = pct => {
    const c = clamp(pct, 0, 100);
    volFill.style.width = volThumb.style.left = `${c}%`;
    audio.volume = c / 100;
    volumeSlider.setAttribute('aria-valuenow', Math.round(c));
  };

  const setCurrentTime = t => { currentTimeEl.textContent = trackCurrentEl.textContent = t; };
  const setDuration    = t => { durationEl.textContent    = trackLengthEl.textContent   = t; };

  const pctFromPointer = (ev, el) => {
    const rect = el.getBoundingClientRect();
    return rect.width ? clamp((ev.clientX - rect.left) / rect.width, 0, 1) : 0;
  };

  const bindTouchSlider = (el, handler) => {
    el.addEventListener('touchstart', ev => handler(ev.touches[0]), { passive: true });
    el.addEventListener('touchmove',  ev => handler(ev.touches[0]), { passive: true });
  };

  audio.addEventListener('play',           () => { setPlayState(true);  syncPlayButtonStates(audio); });
  audio.addEventListener('pause',          () => { setPlayState(false); syncPlayButtonStates(audio); });
  audio.addEventListener('ended',          () => { setPlayState(false); setProgress(0); setCurrentTime('0:00'); syncPlayButtonStates(audio); });
  audio.addEventListener('durationchange', () => setDuration(formatTime(audio.duration)));
  audio.addEventListener('loadedmetadata', () => setDuration(formatTime(audio.duration)));
  audio.addEventListener('error', () => {
    setPlayState(false);
    const nameEl = document.getElementById('player-track-name');
    if (nameEl) nameEl.textContent = 'Playback error, format not supported or unavailable';
  });
  audio.addEventListener('timeupdate', () => {
    if (!audio.duration) return;
    setProgress((audio.currentTime / audio.duration) * 100);
    setCurrentTime(formatTime(audio.currentTime));
    if ('mediaSession' in navigator && navigator.mediaSession.setPositionState && audio.duration > 0) {
      navigator.mediaSession.setPositionState({
        duration:     audio.duration,
        playbackRate: audio.playbackRate,
        position:     audio.currentTime,
      });
    }
  });

  playPauseBtn.addEventListener('click', () => {
    if (audio.paused) {
      safePlay(audio);
    } else {
      audio.pause();
    }
  });

  closeBtn.addEventListener('click', () => {
    audio.pause();
    audio.src = '';
    audio.load();
    playerEl.setAttribute('hidden', '');
    if ('mediaSession' in navigator) navigator.mediaSession.metadata = null;
    setPlayState(false); setProgress(0); setCurrentTime('0:00'); setDuration('0:00');
    syncPlayButtonStates(audio);
  });

  let draggingProgress = false;
  let draggingVolume   = false;

  scrubberEl.addEventListener('mousedown', ev => {
    draggingProgress = true;
    if (audio.duration) audio.currentTime = pctFromPointer(ev, scrubberEl) * audio.duration;
  });
  volumeSlider.addEventListener('mousedown', ev => {
    draggingVolume = true;
    setVolume(pctFromPointer(ev, volumeSlider) * 100);
  });
  window.addEventListener('mousemove', ev => {
    if (draggingProgress && audio.duration) audio.currentTime = pctFromPointer(ev, scrubberEl) * audio.duration;
    if (draggingVolume) setVolume(pctFromPointer(ev, volumeSlider) * 100);
  });
  window.addEventListener('mouseup', () => { draggingProgress = false; draggingVolume = false; });

  bindTouchSlider(scrubberEl,    t => { if (audio.duration) audio.currentTime = pctFromPointer(t, scrubberEl) * audio.duration; });
  bindTouchSlider(volumeSlider,  t => setVolume(pctFromPointer(t, volumeSlider) * 100));

  scrubberEl.addEventListener('keydown', ev => {
    if (!audio.duration) return;
    const step = audio.duration * 0.02;
    if (ev.key === 'ArrowRight') { ev.preventDefault(); audio.currentTime = Math.min(audio.duration, audio.currentTime + step); }
    if (ev.key === 'ArrowLeft')  { ev.preventDefault(); audio.currentTime = Math.max(0, audio.currentTime - step); }
  });

  bindMediaSessionHandlers(audio);
  setVolume(80);
}

function initNav(searchBox, navTabBtn, navTabMenu, navBtnLabel, audio) {
  navTabBtn.addEventListener('click', ev => {
    ev.stopPropagation();
    toggleDropdown(navTabBtn, navTabMenu);
  });
  document.querySelectorAll('.nav-dropdown-item').forEach(item => {
    item.addEventListener('click', () => {
      closeDropdown(navTabBtn, navTabMenu);
      if (item.dataset.tab === state.currentTab) return;
      state.currentTab = item.dataset.tab;
      navBtnLabel.textContent = item.textContent.trim();
      document.querySelectorAll('.nav-dropdown-item').forEach(n => n.classList.toggle('active', n === item));
      if (state.vaultData) renderEras(searchBox.value, audio);
    });
  });
}

function initQualityFilter(searchBox, filterBtn, filterMenu, audio) {
  filterBtn.addEventListener('click', ev => {
    ev.stopPropagation();
    toggleDropdown(filterBtn, filterMenu);
  });
  filterMenu.addEventListener('click', ev => {
    const item = ev.target.closest('.filter-item');
    if (!item) return;
    const key = item.dataset.quality;
    if (state.activeQualities.has(key)) {
      if (state.activeQualities.size === 1) return;
      state.activeQualities.delete(key);
      item.classList.remove('active');
      item.setAttribute('aria-checked', 'false');
    } else {
      state.activeQualities.add(key);
      item.classList.add('active');
      item.setAttribute('aria-checked', 'true');
    }
    if (state.vaultData) renderEras(searchBox.value, audio);
  });
}

function initGlobalHandlers(searchBox, scrollTopBtn, navTabBtn, navTabMenu, filterBtn, filterMenu, audio) {
  searchBox.addEventListener('input', ev => {
    clearTimeout(state.searchDebounceId);
    state.searchDebounceId = setTimeout(() => {
      if (state.vaultData) renderEras(ev.target.value, audio);
    }, SearchDebounceMs);
  });

  document.addEventListener('keydown', ev => {
    if (ev.key === '/' && document.activeElement !== searchBox) {
      ev.preventDefault();
      searchBox.focus();
    }
    if (ev.key === 'Escape') {
      searchBox.blur();
      closeDropdown(filterBtn, filterMenu);
      closeDropdown(navTabBtn, navTabMenu);
      closeAllLinkDropdowns();
    }
  });

  document.addEventListener('click', ev => {
    if (!filterMenu.contains(ev.target) && ev.target !== filterBtn) closeDropdown(filterBtn, filterMenu);
    if (!navTabMenu.contains(ev.target) && !navTabBtn.contains(ev.target)) closeDropdown(navTabBtn, navTabMenu);
    if (!ev.target.closest('.song-dropdown')) closeAllLinkDropdowns();
  });

  window.addEventListener('scroll', () => {
    scrollTopBtn.classList.toggle('visible', scrollY > 400);
    closeAllLinkDropdowns();
  }, { passive: true });

  scrollTopBtn.addEventListener('click', () => scrollTo({ top: 0, behavior: 'smooth' }));
}

function initSettings(audio) {
  const settingsBtn    = document.getElementById('settings-btn');
  const modal          = document.getElementById('settings-modal');
  const closeBtn       = document.getElementById('settings-close-btn');
  const input          = document.getElementById('sheet-id-input');
  const applyBtn       = document.getElementById('settings-apply-btn');
  const resetBtn       = document.getElementById('settings-reset-btn');
  const rateMsgEl      = document.getElementById('settings-rate-msg');
  const playableToggle = document.getElementById('playable-only-toggle');

  const syncToggleUi = () => {
    playableToggle?.setAttribute('aria-checked', String(state.showPlayableOnly));
  };

  playableToggle?.addEventListener('click', () => {
    state.showPlayableOnly = playableToggle.getAttribute('aria-checked') !== 'true';
    syncToggleUi();
    if (state.vaultData) {
      const searchBox = document.getElementById('search-box');
      renderEras(searchBox?.value ?? '', audio);
    }
  });

  const stopCooldown = () => {
    clearInterval(state.cooldownIntervalId);
    state.cooldownIntervalId = null;
  };

  const updateRateUi = () => {
    const { remaining, cooldownMs } = getSheetRateState();
    if (remaining <= 0) {
      applyBtn.disabled     = true;
      rateMsgEl.textContent = `Rate limit reached. Try again in ${formatCountdown(cooldownMs)}.`;
      rateMsgEl.hidden      = false;
      if (!state.cooldownIntervalId) {
        state.cooldownIntervalId = setInterval(() => {
          const { remaining: r, cooldownMs: c } = getSheetRateState();
          if (r > 0) {
            rateMsgEl.hidden      = true;
            rateMsgEl.textContent = '';
            stopCooldown();
            syncApplyBtn();
          } else {
            rateMsgEl.textContent = `Rate limit reached. Try again in ${formatCountdown(c)}.`;
          }
        }, 1_000);
      }
    } else {
      rateMsgEl.hidden      = true;
      rateMsgEl.textContent = '';
      stopCooldown();
    }
  };

  const syncApplyBtn = () => {
    const { remaining } = getSheetRateState();
    const isDifferent = input.value.trim() !== state.primarySheetId && input.value.trim() !== '';
    applyBtn.disabled = !isDifferent || remaining <= 0;
  };

  input.addEventListener('input', syncApplyBtn);

  const openModal = () => {
    input.value = state.primarySheetId;
    syncToggleUi();
    updateRateUi();
    syncApplyBtn();
    modal.removeAttribute('hidden');
    input.focus();
  };

  const closeModal = () => {
    modal.setAttribute('hidden', '');
    stopCooldown();
  };

  settingsBtn.addEventListener('click', ev => { ev.stopPropagation(); openModal(); });
  closeBtn.addEventListener('click', closeModal);
  modal.addEventListener('click', ev => { if (ev.target === modal) closeModal(); });
  document.addEventListener('keydown', ev => {
    if (ev.key === 'Escape' && !modal.hasAttribute('hidden')) closeModal();
  });

  const applySheetId = newId => {
    const { remaining } = getSheetRateState();
    if (remaining <= 0) { updateRateUi(); return; }
    recordSheetChange();
    closeModal();
    reloadWithSheetId(newId, audio);
  };

  applyBtn.addEventListener('click', () => {
    const newId = input.value.trim();
    if (!newId || newId === state.primarySheetId) { closeModal(); return; }
    applySheetId(newId);
  });

  resetBtn.addEventListener('click', () => {
    if (state.primarySheetId === DefaultSheetId) { closeModal(); return; }
    applySheetId(DefaultSheetId);
  });
}

document.addEventListener('DOMContentLoaded', () => {
  const searchBox   = document.getElementById('search-box');
  const filterBtn   = document.getElementById('quality-filter-btn');
  const filterMenu  = document.getElementById('quality-filter-menu');
  const scrollBtn   = document.getElementById('scroll-top');
  const navTabBtn   = document.getElementById('nav-tab-btn');
  const navTabMenu  = document.getElementById('nav-tab-menu');
  const navBtnLabel = document.getElementById('nav-btn-text');
  const audio       = document.getElementById('main-audio');
  const playerEl    = document.getElementById('global-player');

  initPlayer(audio, playerEl);
  initNav(searchBox, navTabBtn, navTabMenu, navBtnLabel, audio);
  initQualityFilter(searchBox, filterBtn, filterMenu, audio);
  initGlobalHandlers(searchBox, scrollBtn, navTabBtn, navTabMenu, filterBtn, filterMenu, audio);
  initSettings(audio);
  loadVaultData(audio);
});
