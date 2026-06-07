'use strict';

const PRIMARY_SHEET_ID  = '1cC-caBQ4j-OWreS37ackw7Gkkq83Hvi6x-mIRHBLxJo';
const FALLBACK_SHEET_ID = '12nGHPPh5dVTfLuBLVQYzC3QgPxKfvp-jgCoNccvEasM';
const RECENT_SONGS_LIMIT = 200;
const CHUNK_SIZE       = 60;
const CHUNK_THRESHOLD  = 60;

let vaultData        = null;
let currentTab       = 'all';
let activeQualities  = new Set(['high', 'low', 'rec', 'cd', 'lossless', 'unavail']);
let searchDebounce   = null;
let renderGeneration = 0;
let eraListEl        = null;

const panelLoadingSet = new WeakSet();

const QUALITY_MATCHERS = {
  high:     label => label.includes('high'),
  low:      label => label.includes('low') && !label.includes('high'),
  rec:      label => label.includes('record'),
  cd:       label => label.includes('cd'),
  lossless: label => label.includes('lossless'),
  unavail:  label => label.includes('not avail') || label.includes('unavail')
};

function getQualityClass(quality) {
  if (!quality) return 'q-other';
  const lower = quality.toLowerCase();
  if (lower.includes('lossless')) return 'q-lossless';
  if (lower.includes('high'))     return 'q-high';
  if (lower.includes('cd'))       return 'q-cd';
  if (lower.includes('low'))      return 'q-low';
  if (lower.includes('record'))   return 'q-rec';
  return 'q-other';
}

function getAvailableLengthClass(availableLength) {
  if (!availableLength) return 'tl-other';
  const lower = availableLength.toLowerCase();
  if (/\bog\b/.test(lower))       return 'tl-og';
  if (lower.includes('lossless')) return 'tl-other';
  if (lower.includes('stem'))     return 'tl-stem';
  if (lower.includes('full'))     return 'tl-full';
  if (lower.includes('tagged'))   return 'tl-tagged';
  if (lower.includes('partial'))  return 'tl-partial';
  if (lower.includes('snippet'))  return 'tl-snippet';
  if (lower.includes('unavail'))  return 'tl-unavail';
  if (lower.includes('confirmed')) return 'tl-confirmed';
  if (lower.includes('rumored'))  return 'tl-rumored';
  if (lower.includes('vox'))      return 'tl-vox';
  return 'tl-other';
}

function isQualityVisible(quality) {
  const lower = (quality || '').toLowerCase();
  if (!lower) return activeQualities.has('unavail');
  for (const key of activeQualities) {
    if (QUALITY_MATCHERS[key](lower)) return true;
  }
  return false;
}

function escapeHtml(str) {
  return String(str)
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;');
}

function SetMediaSession(TrackName) {
  if (!('mediaSession' in navigator)) return;
  navigator.mediaSession.metadata = new MediaMetadata({
    title:  TrackName,
    artist: 'YE VAULT',
    album:  'Ye Vault'
  });
}

function parseCsv(text) {
  const rows = [];
  let field = '';
  let row = [];
  let insideQuotes = false;
  for (let i = 0; i < text.length; i++) {
    const char = text[i];
    if (insideQuotes) {
      if (char === '"' && text[i + 1] === '"') { field += '"'; i++; }
      else if (char === '"') insideQuotes = false;
      else field += char;
    } else {
      if (char === '"')  insideQuotes = true;
      else if (char === ',') { row.push(field); field = ''; }
      else if (char === '\n') { row.push(field); rows.push(row); row = []; field = ''; }
      else if (char !== '\r') field += char;
    }
  }
  if (field || row.length) { row.push(field); rows.push(row); }
  return rows;
}

function buildVaultData(rows) {
  const eraMap = {};
  if (rows.length < 2) return eraMap;

  const headers = rows[0].map(h => h.trim().toLowerCase());

  let leakDateIndex = headers.indexOf('leak date');
  if (leakDateIndex === -1) leakDateIndex = headers.findIndex(h => h.includes('date'));

  let linkIndex = headers.indexOf('link(s)');
  if (linkIndex === -1) linkIndex = headers.findIndex(h => h.includes('link'));

  const columns = {
    era:             headers.indexOf('era'),
    name:            headers.indexOf('name'),
    quality:         headers.indexOf('quality'),
    link:            linkIndex,
    notes:           headers.indexOf('notes'),
    leakDate:        leakDateIndex,
    availableLength: headers.findIndex(h => h.includes('available length'))
  };

  const summaryRowPattern = /^\d+\s+(og file|full|tagged|partial|snippet|stem bounce|unavailable)/i;

  for (let rowIndex = 1; rowIndex < rows.length; rowIndex++) {
    const row = rows[rowIndex];
    if (!row || row.every(cell => !cell.trim())) continue;

    const era  = (row[columns.era]  || '').trim();
    const name = (row[columns.name] || '').trim();
    if (!era || !name) continue;
    if (summaryRowPattern.test(name) || summaryRowPattern.test(era)) continue;

    if (!eraMap[era]) eraMap[era] = [];
    eraMap[era].push([
      name,
      (row[columns.quality] || '').trim(),
      columns.link            !== -1 ? (row[columns.link]            || '').trim() : '',
      (row[columns.notes]    || '').trim(),
      columns.leakDate        !== -1 ? (row[columns.leakDate]        || '').trim() : '',
      columns.availableLength !== -1 ? (row[columns.availableLength] || '').trim() : ''
    ]);
  }
  return eraMap;
}

function parseDateToTimestamp(dateString) {
  if (!dateString) return 0;
  const parsed = Date.parse(dateString);
  if (!isNaN(parsed)) return parsed;
  const yearMatch = dateString.match(/\b(19|20)\d{2}\b/);
  return yearMatch ? new Date(yearMatch[0], 0, 1).getTime() : 0;
}

const playBtnMap = new Map();

function registerPlayBtn(btn, url) {
  if (!playBtnMap.has(url)) playBtnMap.set(url, new Set());
  playBtnMap.get(url).add(btn);
}

function unregisterPlayBtn(btn, url) {
  const s = playBtnMap.get(url);
  if (s) { s.delete(btn); if (!s.size) playBtnMap.delete(url); }
}

function syncPlayButtonStates(audioElement) {
  if (!audioElement) return;
  let currentHref = '';
  try { if (audioElement.src) currentHref = new URL(audioElement.src).href; } catch {}
  const isPaused = audioElement.paused;

  for (const [urlHref, btns] of playBtnMap) {
    const isCurrentTrack = urlHref === currentHref;
    const label = (isCurrentTrack && !isPaused) ? 'Pause' : 'Play';
    for (const btn of btns) btn.textContent = label;
  }
}

function closeAllLinkDropdowns() {
  document.querySelectorAll('.song-dropdown-menu.open').forEach(menu => menu.classList.remove('open'));
}

function buildSongElement(songName, quality, linkString, notes, trackNumber, availableLength, audioElement, rawName) {
  const hasNotes = notes.trim() !== '';

  const links = linkString
    ? linkString.split(/[\s,\n\r]+/).map(url => url.trim()).filter(url => /^https?:/i.test(url))
    : [];

  const hasLinks = links.length > 0;

  const availableLengthLower = availableLength.toLowerCase();
  const isRumoredOrConfirmed = availableLengthLower.includes('rumored') || availableLengthLower.includes('confirmed');
  const displayQuality = (hasLinks || isRumoredOrConfirmed) ? quality : 'Unavailable';
  const isQualityUnavailable = !displayQuality || displayQuality.toLowerCase().includes('unavail') || displayQuality.toLowerCase().includes('not avail');

  const pillowsLink = links.find(url => url.includes('pillows.su/f/'));
  let playButtonHtml = '';
  let downloadUrl = '';

  if (pillowsLink && !isQualityUnavailable) {
    downloadUrl = pillowsLink.replace('pillows.su/f/', 'api.pillows.su/api/download/');
    let buttonLabel = 'Play';
    if (audioElement?.src) {
      try {
        let currentHref = '';
        try { currentHref = new URL(audioElement.src).href; } catch {}
        if (currentHref === new URL(downloadUrl, location.href).href && !audioElement.paused)
          buttonLabel = 'Pause';
      } catch {}
    }
    playButtonHtml = `<button type="button" class="song-play-btn play-btn" data-url="${escapeHtml(downloadUrl)}" data-name="${escapeHtml(rawName || songName)}">${buttonLabel}</button>`;
  }

  let linksHtml = '';
  if (links.length > 1) {
    const linkItems = links.map((url, index) =>
      `<a class="song-dropdown-item" href="${escapeHtml(url)}" target="_blank" rel="noopener noreferrer">Link ${index + 1}</a>`
    ).join('');
    linksHtml = `<div class="song-dropdown">
      <button type="button" class="song-dropdown-btn" aria-haspopup="true" aria-expanded="false">
        <span>Links</span>
        <svg class="dropdown-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true"><polyline points="6,9 12,15 18,9"/></svg>
      </button>
      <div class="song-dropdown-menu" role="menu">${linkItems}</div>
    </div>`;
  } else if (links.length === 1) {
    linksHtml = `<a class="song-link-btn" href="${escapeHtml(links[0])}" target="_blank" rel="noopener noreferrer">View</a>`;
  }

  const noteToggleHtml = hasNotes
    ? `<div class="note-toggle" role="button" tabindex="0" aria-label="Show note">＋</div>`
    : '';

  const pillsHtml =
    (displayQuality  ? `<div class="song-quality ${getQualityClass(displayQuality)}">${escapeHtml(displayQuality)}</div>` : '') +
    (availableLength ? `<div class="song-type ${getAvailableLengthClass(availableLength)}">${escapeHtml(availableLength)}</div>` : '');

  const songEl = document.createElement('div');
  songEl.className = 'song-item';
  songEl.setAttribute('role', 'listitem');
  songEl.innerHTML = `
    <div class="song-num">${trackNumber}</div>
    <div class="song-name" title="${escapeHtml(songName)}">${escapeHtml(songName)}</div>
    <div class="song-pills">${pillsHtml}</div>
    <div class="song-btns">${playButtonHtml}${linksHtml}${noteToggleHtml}</div>
  `;

  if (links.length > 1) {
    const dropdownButton = songEl.querySelector('.song-dropdown-btn');
    const dropdownMenu   = songEl.querySelector('.song-dropdown-menu');
    dropdownButton.addEventListener('click', event => {
      event.stopPropagation();
      const wasOpen = dropdownMenu.classList.contains('open');
      closeAllLinkDropdowns();
      if (!wasOpen) {
        dropdownMenu.classList.add('open');
        dropdownButton.setAttribute('aria-expanded', 'true');
      }
    });
  }

  const playButton = songEl.querySelector('.play-btn');
  if (playButton && downloadUrl) {
    let resolvedUrl = downloadUrl;
    try { resolvedUrl = new URL(downloadUrl, location.href).href; } catch {}
    registerPlayBtn(playButton, resolvedUrl);

    const cleanupObserver = new MutationObserver(() => {
      if (!songEl.isConnected) {
        unregisterPlayBtn(playButton, resolvedUrl);
        cleanupObserver.disconnect();
      }
    });
    cleanupObserver.observe(document.body, { childList: true, subtree: true });

    playButton.addEventListener('click', event => {
      event.stopPropagation();
      closeAllLinkDropdowns();
      const trackUrl   = resolvedUrl;
      const player     = document.getElementById('global-player');
      let currentHref = '';
      try { if (audioElement.src) currentHref = new URL(audioElement.src).href; } catch {}
      const isCurrentTrack = currentHref === trackUrl;
      if (isCurrentTrack) {
        audioElement.paused ? audioElement.play().catch(() => {}) : audioElement.pause();
      } else {
        document.getElementById('player-track-name').textContent = playButton.dataset.name;
        SetMediaSession(playButton.dataset.name);
        audioElement.src = trackUrl;
        audioElement.load();
        player.removeAttribute('hidden');
        audioElement.play().catch(() => {});
      }
    });
  }

  if (hasNotes) {
    const noteEl     = document.createElement('div');
    noteEl.className = 'song-note';
    noteEl.textContent = notes;

    const noteToggle = songEl.querySelector('.note-toggle');
    const toggleNoteVisibility = () => {
      const isExpanded = songEl.classList.toggle('expanded');
      noteToggle.textContent = isExpanded ? '－' : '＋';
      noteToggle.setAttribute('aria-label', isExpanded ? 'Hide note' : 'Show note');
    };
    noteToggle.addEventListener('click', event => { event.stopPropagation(); toggleNoteVisibility(); });
    noteToggle.addEventListener('keydown', event => {
      if (event.key === 'Enter' || event.key === ' ') { event.preventDefault(); toggleNoteVisibility(); }
    });
    return [songEl, noteEl];
  }

  return [songEl];
}

function renderSongsChunked(songs, songsInner, audioElement, onComplete) {
  let index = 0;
  const total = songs.length;

  const loadingBar = document.createElement('div');
  loadingBar.className = 'songs-loading-bar';
  songsInner.parentElement.insertBefore(loadingBar, songsInner);

  function scheduleNextChunk(cb) {
    if (typeof scheduler !== 'undefined' && scheduler.postTask) {
      scheduler.postTask(cb, { priority: 'background' });
    } else if (typeof requestIdleCallback !== 'undefined') {
      requestIdleCallback(cb, { timeout: 300 });
    } else {
      setTimeout(cb, 0);
    }
  }

  function renderChunk() {
    if (!songsInner.isConnected) {
      panelLoadingSet.delete(songsInner);
      loadingBar.remove();
      return;
    }

    const end = Math.min(index + CHUNK_SIZE, total);
    const fragment = document.createDocumentFragment();

    for (; index < end; index++) {
      const [name, quality, link, notes, , availableLength, rawName] = songs[index];
      buildSongElement(name, quality, link, notes, index + 1, availableLength || '', audioElement, rawName)
        .forEach(node => fragment.appendChild(node));
    }

    songsInner.appendChild(fragment);

    if (index < total) {
      scheduleNextChunk(renderChunk);
    } else {
      panelLoadingSet.delete(songsInner);
      loadingBar.remove();
      syncPlayButtonStates(audioElement);
      if (onComplete) onComplete();
    }
  }

  panelLoadingSet.add(songsInner);
  scheduleNextChunk(renderChunk);
}

const openPanels = new Set();

function collapsePanel(songsPanel) {
  if (!openPanels.has(songsPanel)) return;
  songsPanel.classList.remove('open');
  openPanels.delete(songsPanel);
  const eraRow = songsPanel.previousElementSibling;
  if (eraRow) { eraRow.classList.remove('active'); eraRow.setAttribute('aria-expanded', 'false'); }
}

function collapseAllEraPanels() {
  for (const panel of openPanels) collapsePanel(panel);
}

function openPanel(songsPanel, eraRow) {
  songsPanel.classList.add('open');
  openPanels.add(songsPanel);
  eraRow.classList.add('active');
  eraRow.setAttribute('aria-expanded', 'true');
}

function renderEras(searchFilter, audioElement) {
  const eraList     = eraListEl;
  const filterLower = (searchFilter || '').trim().toLowerCase();
  if (!vaultData) return;

  renderGeneration++;

  collapseAllEraPanels();
  closeAllLinkDropdowns();

  playBtnMap.clear();

  const TAB_MARKERS = {
    best:    ['⭐'],
    special: ['✨'],
    grails:  ['🏆', '🏅'],
    ai:      ['🤖']
  };
  const tabMarkers = TAB_MARKERS[currentTab] || null;
  const visibleEras = {};

  if (currentTab === 'recent') {
    const flatSongs = [];
    for (const [era, songs] of Object.entries(vaultData)) {
      songs.filter(([, quality]) => isQualityVisible(quality)).forEach(song => {
        flatSongs.push({
          era,
          name:            song[0],
          quality:         song[1],
          link:            song[2],
          notes:           song[3],
          leakDate:        song[4] || '',
          availableLength: song[5] || ''
        });
      });
    }
    flatSongs.sort((a, b) => parseDateToTimestamp(b.leakDate) - parseDateToTimestamp(a.leakDate));
    const recentPool = flatSongs.slice(0, RECENT_SONGS_LIMIT);
    const recentSongs = filterLower
      ? recentPool.filter(s => s.name.toLowerCase().includes(filterLower) || s.era.toLowerCase().includes(filterLower))
      : recentPool;
    if (recentSongs.length) {
      visibleEras['Recent Leaks'] = recentSongs.map(song => [
        `[${song.era}] ${song.name}${song.leakDate ? ` (${song.leakDate})` : ''}`,
        song.quality, song.link, song.notes, song.leakDate, song.availableLength,
        song.name
      ]);
    }
  } else {
    for (const [era, songs] of Object.entries(vaultData)) {
      let matched = songs.filter(([, quality]) => isQualityVisible(quality));
      if (tabMarkers)  matched = matched.filter(([name]) => tabMarkers.some(m => name.includes(m)));
      if (filterLower) matched = matched.filter(([name]) => name.toLowerCase().includes(filterLower) || era.toLowerCase().includes(filterLower));
      if (matched.length) visibleEras[era] = matched;
    }
  }

  const eraKeys    = Object.keys(visibleEras);
  const totalSongs = eraKeys.reduce((sum, key) => sum + visibleEras[key].length, 0);

  const erasStat = document.getElementById('stat-eras');
  if (currentTab === 'recent') {
    erasStat.hidden = true;
  } else {
    erasStat.hidden = false;
    document.getElementById('nav-eras').textContent = eraKeys.length.toLocaleString();
  }
  document.getElementById('nav-songs').textContent = totalSongs.toLocaleString();

  const fragment = document.createDocumentFragment();

  if (!eraKeys.length) {
    const emptyMessage = document.createElement('div');
    emptyMessage.className = 'no-results';
    emptyMessage.textContent = 'No results found.';
    fragment.appendChild(emptyMessage);
    eraList.replaceChildren(fragment);
    return;
  }

  for (const era of eraKeys) {
    const songs = visibleEras[era];

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

    const songsInner = document.createElement('div');
    songsInner.className = 'songs-inner';
    songsInner.setAttribute('role', 'list');
    songsInner.setAttribute('aria-label', era + ' songs');
    songsPanel.appendChild(songsInner);

    const togglePanel = () => {
      const isOpen = openPanels.has(songsPanel);
      closeAllLinkDropdowns();
      if (isOpen) {
        collapsePanel(songsPanel);
      } else {
        collapseAllEraPanels();
        openPanel(songsPanel, eraRow);
        eraRow.scrollIntoView({ behavior: 'smooth', block: 'nearest' });

        if (!songsInner.dataset.loaded) {
          songsInner.dataset.loaded = '1';
          if (songs.length > CHUNK_THRESHOLD) {
            renderSongsChunked(songs, songsInner, audioElement);
          } else {
            const songFragment = document.createDocumentFragment();
            songs.forEach(([name, quality, link, notes, , availableLength, rawName], index) => {
              buildSongElement(name, quality, link, notes, index + 1, availableLength || '', audioElement, rawName)
                .forEach(node => songFragment.appendChild(node));
            });
            songsInner.appendChild(songFragment);
            syncPlayButtonStates(audioElement);
          }
        }
      }
    };

    eraRow.addEventListener('click', togglePanel);
    eraRow.addEventListener('keydown', event => {
      if (event.key === 'Enter' || event.key === ' ') { event.preventDefault(); togglePanel(); }
    });

    eraWrap.appendChild(eraRow);
    eraWrap.appendChild(songsPanel);
    fragment.appendChild(eraWrap);
  }

  eraList.replaceChildren(fragment);
}

document.addEventListener('DOMContentLoaded', () => {
  eraListEl              = document.getElementById('era-list');
  const searchBox        = document.getElementById('search-box');
  const qualityFilterBtn = document.getElementById('quality-filter-btn');
  const qualityFilterMenu= document.getElementById('quality-filter-menu');
  const scrollTopBtn     = document.getElementById('scroll-top');
  const navTabBtn        = document.getElementById('nav-tab-btn');
  const navTabMenu       = document.getElementById('nav-tab-menu');
  const navBtnLabel      = document.getElementById('nav-btn-text');
  const audioElement     = document.getElementById('main-audio');
  const playerEl         = document.getElementById('global-player');

  searchBox.addEventListener('input', event => {
    clearTimeout(searchDebounce);
    searchDebounce = setTimeout(() => { if (vaultData) renderEras(event.target.value, audioElement); }, 200);
  });

  if (audioElement) {
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
    const volumeFill     = document.getElementById('player-vol-fill');
    const volumeThumb    = document.getElementById('player-vol-thumb');
    const scrubberEl     = document.getElementById('player-scrubber');
    const volumeSlider   = document.getElementById('player-volume');

    const formatTime = seconds => {
      if (!isFinite(seconds) || seconds < 0) return '0:00';
      return `${Math.floor(seconds / 60)}:${String(Math.floor(seconds % 60)).padStart(2, '0')}`;
    };

    const setPlayState = isPlaying => {
      playIcon.style.display  = isPlaying ? 'none' : '';
      pauseIcon.style.display = isPlaying ? '' : 'none';
      playPauseBtn.setAttribute('aria-label', isPlaying ? 'Pause' : 'Play');
    };

    const setProgress = percent => {
      const clamped = Math.max(0, Math.min(100, percent));
      progressFill.style.width = progressThumb.style.left = clamped + '%';
      scrubberEl.setAttribute('aria-valuenow', Math.round(clamped));
    };

    const setVolume = percent => {
      const clamped = Math.max(0, Math.min(100, percent));
      volumeFill.style.width = volumeThumb.style.left = clamped + '%';
      audioElement.volume = clamped / 100;
      volumeSlider.setAttribute('aria-valuenow', Math.round(clamped));
    };

    const percentFromPointer = (event, element) => {
      const rect = element.getBoundingClientRect();
      return Math.max(0, Math.min(1, (event.clientX - rect.left) / rect.width));
    };

    const setCurrentTime = timeString => { currentTimeEl.textContent = trackCurrentEl.textContent = timeString; };
    const setDuration    = timeString => { durationEl.textContent    = trackLengthEl.textContent  = timeString; };

    audioElement.addEventListener('play',     () => { setPlayState(true);  syncPlayButtonStates(audioElement); });
    audioElement.addEventListener('pause',    () => { setPlayState(false); syncPlayButtonStates(audioElement); });
    audioElement.addEventListener('ended',    () => { setPlayState(false); setProgress(0); setCurrentTime('0:00'); syncPlayButtonStates(audioElement); });
    audioElement.addEventListener('timeupdate', () => {
      if (!audioElement.duration) return;
      setProgress((audioElement.currentTime / audioElement.duration) * 100);
      setCurrentTime(formatTime(audioElement.currentTime));
      if ('mediaSession' in navigator && navigator.mediaSession.setPositionState && audioElement.duration > 0) {
        navigator.mediaSession.setPositionState({
          duration:     audioElement.duration,
          playbackRate: audioElement.playbackRate,
          position:     audioElement.currentTime
        });
      }
    });
    audioElement.addEventListener('durationchange', () => setDuration(formatTime(audioElement.duration)));
    audioElement.addEventListener('loadedmetadata', () => setDuration(formatTime(audioElement.duration)));
    audioElement.addEventListener('error', (e) => {
      setPlayState(false);
      document.getElementById('player-track-name').textContent = 'Playback error: Format not supported';
      console.error('Audio playback error:', e);
    });

    if ('mediaSession' in navigator) {
      navigator.mediaSession.setActionHandler('play',  () => audioElement.play().catch(() => {}));
      navigator.mediaSession.setActionHandler('pause', () => audioElement.pause());
      navigator.mediaSession.setActionHandler('stop',  () => {
        audioElement.pause();
        audioElement.currentTime = 0;
      });
      navigator.mediaSession.setActionHandler('seekto', Details => {
        if (Details.seekTime !== undefined && audioElement.duration) {
          audioElement.currentTime = Details.seekTime;
        }
      });
      navigator.mediaSession.setActionHandler('seekbackward', Details => {
        audioElement.currentTime = Math.max(0, audioElement.currentTime - (Details.seekOffset || 10));
      });
      navigator.mediaSession.setActionHandler('seekforward', Details => {
        audioElement.currentTime = Math.min(audioElement.duration || 0, audioElement.currentTime + (Details.seekOffset || 10));
      });
    }

    playPauseBtn.addEventListener('click', () => {
      audioElement.paused ? audioElement.play().catch(() => {}) : audioElement.pause();
    });

    closeBtn.addEventListener('click', () => {
      audioElement.pause();
      audioElement.src = '';
      playerEl.setAttribute('hidden', '');
      if ('mediaSession' in navigator) navigator.mediaSession.metadata = null;
      setPlayState(false); setProgress(0); setCurrentTime('0:00'); setDuration('0:00');
      syncPlayButtonStates(audioElement);
    });

    let isDraggingProgress = false;
    let isDraggingVolume   = false;

    scrubberEl.addEventListener('mousedown', event => {
      isDraggingProgress = true;
      if (audioElement.duration) audioElement.currentTime = percentFromPointer(event, scrubberEl) * audioElement.duration;
    });
    volumeSlider.addEventListener('mousedown', event => {
      isDraggingVolume = true;
      setVolume(percentFromPointer(event, volumeSlider) * 100);
    });
    window.addEventListener('mousemove', event => {
      if (isDraggingProgress && audioElement.duration) audioElement.currentTime = percentFromPointer(event, scrubberEl) * audioElement.duration;
      if (isDraggingVolume) setVolume(percentFromPointer(event, volumeSlider) * 100);
    });
    window.addEventListener('mouseup', () => { isDraggingProgress = false; isDraggingVolume = false; });

    scrubberEl.addEventListener('touchstart', event => {
      if (audioElement.duration) audioElement.currentTime = percentFromPointer(event.touches[0], scrubberEl) * audioElement.duration;
    }, { passive: true });
    scrubberEl.addEventListener('touchmove', event => {
      if (audioElement.duration) audioElement.currentTime = percentFromPointer(event.touches[0], scrubberEl) * audioElement.duration;
    }, { passive: true });
    volumeSlider.addEventListener('touchstart', event => setVolume(percentFromPointer(event.touches[0], volumeSlider) * 100), { passive: true });
    volumeSlider.addEventListener('touchmove',  event => setVolume(percentFromPointer(event.touches[0], volumeSlider) * 100), { passive: true });

    scrubberEl.addEventListener('keydown', event => {
      if (!audioElement.duration) return;
      const step = audioElement.duration * 0.02;
      if (event.key === 'ArrowRight') { event.preventDefault(); audioElement.currentTime = Math.min(audioElement.duration, audioElement.currentTime + step); }
      if (event.key === 'ArrowLeft')  { event.preventDefault(); audioElement.currentTime = Math.max(0, audioElement.currentTime - step); }
    });

    setVolume(80);
  }

  navTabBtn.addEventListener('click', event => {
    event.stopPropagation();
    const isOpen = navTabMenu.classList.toggle('open');
    navTabBtn.setAttribute('aria-expanded', String(isOpen));
  });

  document.querySelectorAll('.nav-dropdown-item').forEach(item => {
    item.addEventListener('click', () => {
      navTabMenu.classList.remove('open');
      navTabBtn.setAttribute('aria-expanded', 'false');
      if (item.dataset.tab === currentTab) return;
      currentTab = item.dataset.tab;
      navBtnLabel.textContent = item.textContent.trim();
      document.querySelectorAll('.nav-dropdown-item').forEach(navItem => navItem.classList.toggle('active', navItem === item));
      if (vaultData) renderEras(searchBox.value, audioElement);
    });
  });

  qualityFilterBtn.addEventListener('click', event => {
    event.stopPropagation();
    const isOpen = qualityFilterMenu.classList.toggle('open');
    qualityFilterBtn.setAttribute('aria-expanded', String(isOpen));
  });

  qualityFilterMenu.addEventListener('click', event => {
    const item = event.target.closest('.filter-item');
    if (!item) return;
    const key = item.dataset.quality;
    if (activeQualities.has(key)) {
      if (activeQualities.size === 1) return;
      activeQualities.delete(key);
      item.classList.remove('active');
      item.setAttribute('aria-checked', 'false');
    } else {
      activeQualities.add(key);
      item.classList.add('active');
      item.setAttribute('aria-checked', 'true');
    }
    if (vaultData) renderEras(searchBox.value, audioElement);
  });

  document.addEventListener('keydown', event => {
    if (event.key === '/' && document.activeElement !== searchBox) {
      event.preventDefault();
      searchBox.focus();
    }
    if (event.key === 'Escape') {
      searchBox.blur();
      qualityFilterMenu.classList.remove('open');
      qualityFilterBtn.setAttribute('aria-expanded', 'false');
      navTabMenu.classList.remove('open');
      navTabBtn.setAttribute('aria-expanded', 'false');
      closeAllLinkDropdowns();
    }
  });

  document.addEventListener('click', event => {
    if (!qualityFilterMenu.contains(event.target) && event.target !== qualityFilterBtn) {
      qualityFilterMenu.classList.remove('open');
      qualityFilterBtn.setAttribute('aria-expanded', 'false');
    }
    if (!navTabMenu.contains(event.target) && !navTabBtn.contains(event.target)) {
      navTabMenu.classList.remove('open');
      navTabBtn.setAttribute('aria-expanded', 'false');
    }
    if (!event.target.closest('.song-dropdown')) closeAllLinkDropdowns();
  });

  window.addEventListener('scroll', () => {
    scrollTopBtn.classList.toggle('visible', scrollY > 400);
    closeAllLinkDropdowns();
  }, { passive: true });

  scrollTopBtn.addEventListener('click', () => scrollTo({ top: 0, behavior: 'smooth' }));

  (async () => {
    const fetchSheetAsCsv = async sheetId => {
      const response = await fetch(`https://docs.google.com/spreadsheets/d/${sheetId}/export?format=csv`);
      if (!response.ok) throw new Error(`HTTP ${response.status}`);
      return response.text();
    };

    try {
      let csvText;
      try       { csvText = await fetchSheetAsCsv(PRIMARY_SHEET_ID); }
      catch (_) { csvText = await fetchSheetAsCsv(FALLBACK_SHEET_ID); }
      vaultData = buildVaultData(parseCsv(csvText));
      renderEras('', audioElement);
    } catch (error) {
      console.error('Failed to load vault data:', error);
      const errorMessage = document.createElement('div');
      errorMessage.className = 'error-msg';
      errorMessage.textContent = 'Failed to load data, check your connection or sheet permissions.';
      document.getElementById('era-list').replaceChildren(errorMessage);
    }
  })();
});
