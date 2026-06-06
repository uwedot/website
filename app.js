'use strict';

const SHEET_ID          = '1cC-caBQ4j-OWreS37ackw7Gkkq83Hvi6x-mIRHBLxJo';
const SHEET_ID_FALLBACK = '12nGHPPh5dVTfLuBLVQYzC3QgPxKfvp-jgCoNccvEasM';
const RECENT_LIMIT      = 200;

let allData        = null;
let currentTab     = 'all';
let activeQualities = new Set(['high', 'low', 'rec', 'cd', 'lossless']);
let searchTimer    = null;

const QUALITY_CHECKS = {
  high:    L => L.includes('high'),
  low:     L => L.includes('low') && !L.includes('high'),
  rec:     L => L.includes('record'),
  cd:      L => L.includes('cd'),
  lossless:L => L.includes('lossless'),
};

function qualityClass(q) {
  if (!q) return 'q-other';
  const l = q.toLowerCase();
  if (l.includes('high'))    return 'q-high';
  if (l.includes('cd'))      return 'q-cd';
  if (l.includes('low'))     return 'q-low';
  if (l.includes('record'))  return 'q-rec';
  if (l.includes('lossless'))return 'q-lossless';
  return 'q-other';
}

function typeClass(t) {
  if (!t) return 'tl-other';
  const l = t.toLowerCase();
  if (l.includes('og'))      return 'tl-og';
  if (l.includes('stem'))    return 'tl-stem';
  if (l.includes('full'))    return 'tl-full';
  if (l.includes('tagged'))  return 'tl-tagged';
  if (l.includes('partial')) return 'tl-partial';
  if (l.includes('snippet')) return 'tl-snippet';
  if (l.includes('unavail')) return 'tl-unavail';
  return 'tl-other';
}

function qualityAllowed(quality) {
  if (!quality) return false;
  const l = quality.toLowerCase();
  if (l.includes('not avail') || l.includes('unavail')) return false;
  for (const key of activeQualities) {
    if (QUALITY_CHECKS[key](l)) return true;
  }
  return false;
}

function escHtml(str) {
  return String(str)
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;');
}

function parseCsv(text) {
  const rows = [];
  let field = '', row = [], inQuote = false;
  for (let i = 0; i < text.length; i++) {
    const ch = text[i];
    if (inQuote) {
      if (ch === '"' && text[i + 1] === '"') { field += '"'; i++; }
      else if (ch === '"') inQuote = false;
      else field += ch;
    } else {
      if (ch === '"')  inQuote = true;
      else if (ch === ',') { row.push(field); field = ''; }
      else if (ch === '\n') { row.push(field); rows.push(row); row = []; field = ''; }
      else if (ch !== '\r') field += ch;
    }
  }
  if (field || row.length) { row.push(field); rows.push(row); }
  return rows;
}

function buildData(rows) {
  const map = {};
  if (rows.length < 2) return map;
  const header = rows[0].map(h => h.trim().toLowerCase());
  let leakDateIdx = header.indexOf('leak date');
  if (leakDateIdx === -1) leakDateIdx = header.findIndex(h => h.includes('date'));
  let urlIdx = header.indexOf('link(s)');
  if (urlIdx === -1) urlIdx = header.findIndex(h => h.includes('link'));
  const col = {
    era:     header.indexOf('era'),
    name:    header.indexOf('name'),
    quality: header.indexOf('quality'),
    url:     urlIdx,
    notes:   header.indexOf('notes'),
    date:    leakDateIdx,
    type:    header.findIndex(h => h.includes('available length')),
  };
  const summaryRe = /^\d+\s+(og file|full|tagged|partial|snippet|stem bounce|unavailable)/i;
  for (let i = 1; i < rows.length; i++) {
    const r = rows[i];
    if (!r || r.every(c => !c.trim())) continue;
    const era  = (r[col.era]  || '').trim();
    const name = (r[col.name] || '').trim();
    if (!era || !name) continue;
    if (summaryRe.test(name) || summaryRe.test(era)) continue;
    if (!map[era]) map[era] = [];
    map[era].push([
      name,
      (r[col.quality] || '').trim(),
      col.url  !== -1 ? (r[col.url]  || '').trim() : '',
      (r[col.notes]   || '').trim(),
      col.date !== -1 ? (r[col.date] || '').trim() : '',
      col.type !== -1 ? (r[col.type] || '').trim() : '',
    ]);
  }
  return map;
}

function getDateValue(str) {
  if (!str) return 0;
  const n = Date.parse(str);
  if (!isNaN(n)) return n;
  const m = str.match(/\b(19|20)\d{2}\b/);
  return m ? new Date(m[0], 0, 1).getTime() : 0;
}

function positionDropdown(btn, menu) {
  menu.style.cssText = 'visibility:hidden;display:flex';
  const mh = menu.offsetHeight;
  const mw = menu.offsetWidth;
  menu.style.cssText = '';
  const rect = btn.getBoundingClientRect();
  const spaceBelow = window.innerHeight - rect.bottom;
  const left = Math.max(4, Math.min(rect.right - mw, window.innerWidth - mw - 4));
  menu.style.top  = (spaceBelow < mh + 8 ? rect.top - mh - 4 : rect.bottom + 4) + 'px';
  menu.style.left = left + 'px';
  menu.style.right = '';
}

function updatePlayButtons(audio) {
  if (!audio) return;
  document.querySelectorAll('.play-btn').forEach(btn => {
    try {
      const isCurrent = audio.src &&
        new URL(audio.src).href === new URL(btn.dataset.url, location.href).href;
      btn.textContent = (isCurrent && !audio.paused) ? 'Pause' : 'Play';
    } catch {
      btn.textContent = 'Play';
    }
  });
}

function closeAllSongDropdowns() {
  document.querySelectorAll('.song-dropdown-menu.open').forEach(m => m.classList.remove('open'));
}

function makeSongEl(name, quality, url, notes, num, trackType, audio) {
  const hasNote = notes.trim() !== '';
  const urlList = url
    ? url.split(/[\s,\n\r]+/).map(u => u.trim()).filter(u => /^https?:/i.test(u))
    : [];
  const hasUrl = urlList.length > 0;
  const displayQuality = hasUrl ? quality : 'Unavailable';

  const pillowsUrl = urlList.find(u => u.includes('pillows.su/f/'));
  let playBtnHtml = '';
  if (pillowsUrl) {
    const dlUrl = pillowsUrl.replace('pillows.su/f/', 'api.pillows.su/api/download/');
    let btnText = 'Play';
    if (audio?.src) {
      try {
        if (new URL(audio.src).href === new URL(dlUrl, location.href).href && !audio.paused)
          btnText = 'Pause';
      } catch {}
    }
    playBtnHtml = `<button type="button" class="song-play-btn play-btn" data-url="${escHtml(dlUrl)}" data-name="${escHtml(name)}">${btnText}</button>`;
  }

  let linksHtml = '';
  if (urlList.length > 1) {
    const items = urlList.map((u, i) =>
      `<a class="song-dropdown-item" href="${escHtml(u)}" target="_blank" rel="noopener noreferrer">Link ${i + 1}</a>`
    ).join('');
    linksHtml = `<div class="song-dropdown">
      <button type="button" class="song-dropdown-btn" aria-haspopup="true" aria-expanded="false">
        <span>Links</span>
        <svg class="dropdown-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true"><polyline points="6,9 12,15 18,9"/></svg>
      </button>
      <div class="song-dropdown-menu" role="menu">${items}</div>
    </div>`;
  } else if (urlList.length === 1) {
    linksHtml = `<a class="song-link-btn" href="${escHtml(urlList[0])}" target="_blank" rel="noopener noreferrer">View</a>`;
  }

  const noteHtml = hasNote
    ? `<div class="note-toggle" role="button" tabindex="0" aria-label="Show note">＋</div>`
    : '';
  const pillsHtml =
    (displayQuality ? `<div class="song-quality ${qualityClass(displayQuality)}">${escHtml(displayQuality)}</div>` : '') +
    (trackType      ? `<div class="song-type ${typeClass(trackType)}">${escHtml(trackType)}</div>` : '');

  const el = document.createElement('div');
  el.className = 'song-item';
  el.setAttribute('role', 'listitem');
  el.innerHTML = `
    <div class="song-num">${num}</div>
    <div class="song-name" title="${escHtml(name)}">${escHtml(name)}</div>
    <div class="song-pills">${pillsHtml}</div>
    <div class="song-btns">${playBtnHtml}${linksHtml}${noteHtml}</div>
  `;

  if (urlList.length > 1) {
    const dropBtn  = el.querySelector('.song-dropdown-btn');
    const dropMenu = el.querySelector('.song-dropdown-menu');
    dropBtn.addEventListener('click', ev => {
      ev.stopPropagation();
      const isOpen = dropMenu.classList.contains('open');
      closeAllSongDropdowns();
      if (!isOpen) {
        positionDropdown(dropBtn, dropMenu);
        dropMenu.classList.add('open');
        dropBtn.setAttribute('aria-expanded', 'true');
      }
    });
  }

  const playBtn = el.querySelector('.play-btn');
  if (playBtn) {
    playBtn.addEventListener('click', ev => {
      ev.stopPropagation();
      closeAllSongDropdowns();
      const trackUrl = new URL(playBtn.dataset.url, location.href).href;
      const player   = document.getElementById('global-player');
      const isCurrent = audio.src && new URL(audio.src).href === trackUrl;
      if (isCurrent) {
        audio.paused ? audio.play().catch(() => {}) : audio.pause();
      } else {
        document.getElementById('player-track-name').textContent = playBtn.dataset.name;
        audio.src = trackUrl;
        player.removeAttribute('hidden');
        audio.play().catch(() => {});
      }
    });
  }

  if (hasNote) {
    const noteEl     = document.createElement('div');
    noteEl.className = 'song-note';
    noteEl.textContent = notes;
    const noteToggle = el.querySelector('.note-toggle');
    const toggleNote = () => {
      const expanded = el.classList.toggle('expanded');
      noteToggle.textContent = expanded ? '－' : '＋';
      noteToggle.setAttribute('aria-label', expanded ? 'Hide note' : 'Show note');
    };
    noteToggle.addEventListener('click', ev => { ev.stopPropagation(); toggleNote(); });
    noteToggle.addEventListener('keydown', ev => {
      if (ev.key === 'Enter' || ev.key === ' ') { ev.preventDefault(); toggleNote(); }
    });
    return [el, noteEl];
  }

  return [el];
}

function collapseAllPanels() {
  document.querySelectorAll('.songs-panel.open').forEach(panel => {
    panel.classList.remove('open');
    const row = panel.previousElementSibling;
    if (row) { row.classList.remove('active'); row.setAttribute('aria-expanded', 'false'); }
  });
}

function renderEras(filter, audio) {
  const list = document.getElementById('era-list');
  const f    = (filter || '').trim().toLowerCase();
  if (!allData) return;

  collapseAllPanels();
  closeAllSongDropdowns();

  const tabEmoji = currentTab === 'best' ? '⭐' : currentTab === 'special' ? '✨' : null;
  const filtered = {};

  if (currentTab === 'recent') {
    const allSongs = [];
    for (const [era, songs] of Object.entries(allData)) {
      songs.filter(([, q]) => qualityAllowed(q)).forEach(song => {
        if (!f || song[0].toLowerCase().includes(f) || era.toLowerCase().includes(f)) {
          allSongs.push({
            era, name: song[0], quality: song[1], url: song[2],
            notes: song[3], dateStr: song[4] || '', trackType: song[5] || '',
          });
        }
      });
    }
    allSongs.sort((a, b) => getDateValue(b.dateStr) - getDateValue(a.dateStr));
    const recent = allSongs.slice(0, RECENT_LIMIT);
    if (recent.length) {
      filtered['Recent Leaks'] = recent.map(s => [
        `[${s.era}] ${s.name}${s.dateStr ? ` (${s.dateStr})` : ''}`,
        s.quality, s.url, s.notes, s.dateStr, s.trackType,
      ]);
    }
  } else {
    for (const [era, songs] of Object.entries(allData)) {
      let matched = songs.filter(([, q]) => qualityAllowed(q));
      if (tabEmoji) matched = matched.filter(([n]) => n.includes(tabEmoji));
      if (f)        matched = matched.filter(([n]) => n.toLowerCase().includes(f) || era.toLowerCase().includes(f));
      if (matched.length) filtered[era] = matched;
    }
  }

  const eraKeys   = Object.keys(filtered);
  const totalSongs = eraKeys.reduce((s, k) => s + filtered[k].length, 0);

  const erasStat = document.getElementById('stat-eras');
  if (currentTab === 'recent') {
    erasStat.hidden = true;
  } else {
    erasStat.hidden = false;
    document.getElementById('nav-eras').textContent = eraKeys.length.toLocaleString();
  }
  document.getElementById('nav-songs').textContent = totalSongs.toLocaleString();

  const frag = document.createDocumentFragment();

  if (!eraKeys.length) {
    const el = document.createElement('div');
    el.className = 'no-results';
    el.textContent = 'No results found.';
    frag.appendChild(el);
    list.replaceChildren(frag);
    return;
  }

  for (const era of eraKeys) {
    const songs = filtered[era];

    const wrap = document.createElement('div');
    wrap.className = 'era-wrap';
    wrap.setAttribute('role', 'listitem');

    const row = document.createElement('div');
    row.className = 'era-row';
    row.setAttribute('role', 'button');
    row.setAttribute('tabindex', '0');
    row.setAttribute('aria-expanded', 'false');
    row.innerHTML = `
      <div class="era-row-name">${escHtml(era)}</div>
      <div class="era-row-right">
        <div class="era-pill">${songs.length}</div>
        <svg class="era-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
          <polyline points="6,9 12,15 18,9"/>
        </svg>
      </div>
    `;

    const panel = document.createElement('div');
    panel.className = 'songs-panel';

    const inner = document.createElement('div');
    inner.className = 'songs-inner';
    inner.setAttribute('role', 'list');
    panel.appendChild(inner);

    const toggle = () => {
      const isOpen = panel.classList.contains('open');
      closeAllSongDropdowns();
      if (isOpen) {
        panel.classList.remove('open');
        row.classList.remove('active');
        row.setAttribute('aria-expanded', 'false');
      } else {
        panel.classList.add('open');
        row.classList.add('active');
        row.setAttribute('aria-expanded', 'true');
        if (!inner.dataset.loaded) {
          inner.dataset.loaded = '1';
          const songFrag = document.createDocumentFragment();
          songs.forEach(([n, q, u, no, , tt], i) => {
            makeSongEl(n, q, u, no, i + 1, tt || '', audio)
              .forEach(node => songFrag.appendChild(node));
          });
          inner.appendChild(songFrag);
          updatePlayButtons(audio);
        }
      }
    };

    row.addEventListener('click', toggle);
    row.addEventListener('keydown', ev => {
      if (ev.key === 'Enter' || ev.key === ' ') { ev.preventDefault(); toggle(); }
    });

    wrap.appendChild(row);
    wrap.appendChild(panel);
    frag.appendChild(wrap);
  }

  list.replaceChildren(frag);
}

document.addEventListener('DOMContentLoaded', () => {
  const searchBox = document.getElementById('search-box');
  const filterBtn = document.getElementById('filter-btn');
  const filterMenu= document.getElementById('filter-menu');
  const scrollBtn = document.getElementById('scroll-top');
  const navBtn    = document.getElementById('nav-tab-btn');
  const navMenu   = document.getElementById('nav-tab-menu');
  const navText   = document.getElementById('nav-btn-text');
  const audio     = document.getElementById('main-audio');
  const player    = document.getElementById('global-player');

  searchBox.addEventListener('input', ev => {
    clearTimeout(searchTimer);
    searchTimer = setTimeout(() => { if (allData) renderEras(ev.target.value, audio); }, 180);
  });

  if (audio) {
    const playIcon    = document.getElementById('player-play-icon');
    const pauseIcon   = document.getElementById('player-pause-icon');
    const playBtn     = document.getElementById('player-play-btn');
    const closeBtn    = document.getElementById('player-close-btn');
    const currentEl   = document.getElementById('player-current');
    const durationEl  = document.getElementById('player-duration');
    const trackCurEl  = document.getElementById('player-track-current');
    const trackLenEl  = document.getElementById('player-track-length');
    const fill        = document.getElementById('player-fill');
    const thumb       = document.getElementById('player-thumb');
    const volFill     = document.getElementById('player-vol-fill');
    const volThumb    = document.getElementById('player-vol-thumb');
    const scrubber    = document.getElementById('player-scrubber');
    const volSlider   = document.getElementById('player-volume');

    const fmtTime = s => {
      if (!isFinite(s) || s < 0) return '0:00';
      return `${Math.floor(s / 60)}:${String(Math.floor(s % 60)).padStart(2, '0')}`;
    };
    const setPlayState = playing => {
      playIcon.style.display  = playing ? 'none' : '';
      pauseIcon.style.display = playing ? '' : 'none';
      playBtn.setAttribute('aria-label', playing ? 'Pause' : 'Play');
    };
    const setProgress = pct => {
      const p = Math.max(0, Math.min(100, pct));
      fill.style.width = thumb.style.left = p + '%';
      scrubber.setAttribute('aria-valuenow', Math.round(p));
    };
    const setVolume = pct => {
      const p = Math.max(0, Math.min(100, pct));
      volFill.style.width = volThumb.style.left = p + '%';
      audio.volume = p / 100;
      volSlider.setAttribute('aria-valuenow', Math.round(p));
    };
    const pctFromEvent = (ev, el) => {
      const r = el.getBoundingClientRect();
      return Math.max(0, Math.min(1, (ev.clientX - r.left) / r.width));
    };
    const setTime     = t => { currentEl.textContent = trackCurEl.textContent = t; };
    const setDuration = t => { durationEl.textContent = trackLenEl.textContent = t; };

    audio.addEventListener('play',     () => { setPlayState(true);  updatePlayButtons(audio); });
    audio.addEventListener('pause',    () => { setPlayState(false); updatePlayButtons(audio); });
    audio.addEventListener('ended',    () => { setPlayState(false); setProgress(0); setTime('0:00'); updatePlayButtons(audio); });
    audio.addEventListener('timeupdate', () => {
      if (!audio.duration) return;
      setProgress((audio.currentTime / audio.duration) * 100);
      setTime(fmtTime(audio.currentTime));
    });
    audio.addEventListener('durationchange', () => setDuration(fmtTime(audio.duration)));
    audio.addEventListener('loadedmetadata', () => setDuration(fmtTime(audio.duration)));
    audio.addEventListener('error', () => {
      setPlayState(false);
      document.getElementById('player-track-name').textContent = 'Failed to load track';
    });

    playBtn.addEventListener('click', () => {
      audio.paused ? audio.play().catch(() => {}) : audio.pause();
    });
    closeBtn.addEventListener('click', () => {
      audio.pause();
      audio.src = '';
      player.setAttribute('hidden', '');
      setPlayState(false); setProgress(0); setTime('0:00'); setDuration('0:00');
      updatePlayButtons(audio);
    });

    let scrubDragging = false, volDragging = false;
    scrubber.addEventListener('mousedown', ev => {
      scrubDragging = true;
      if (audio.duration) audio.currentTime = pctFromEvent(ev, scrubber) * audio.duration;
    });
    volSlider.addEventListener('mousedown', ev => {
      volDragging = true;
      setVolume(pctFromEvent(ev, volSlider) * 100);
    });
    window.addEventListener('mousemove', ev => {
      if (scrubDragging && audio.duration) audio.currentTime = pctFromEvent(ev, scrubber) * audio.duration;
      if (volDragging) setVolume(pctFromEvent(ev, volSlider) * 100);
    });
    window.addEventListener('mouseup', () => { scrubDragging = false; volDragging = false; });

    scrubber.addEventListener('touchstart', ev => {
      if (audio.duration) audio.currentTime = pctFromEvent(ev.touches[0], scrubber) * audio.duration;
    }, { passive: true });
    scrubber.addEventListener('touchmove', ev => {
      if (audio.duration) audio.currentTime = pctFromEvent(ev.touches[0], scrubber) * audio.duration;
    }, { passive: true });
    volSlider.addEventListener('touchstart', ev => setVolume(pctFromEvent(ev.touches[0], volSlider) * 100), { passive: true });
    volSlider.addEventListener('touchmove',  ev => setVolume(pctFromEvent(ev.touches[0], volSlider) * 100), { passive: true });

    scrubber.addEventListener('keydown', ev => {
      if (!audio.duration) return;
      const step = audio.duration * 0.02;
      if (ev.key === 'ArrowRight') { ev.preventDefault(); audio.currentTime = Math.min(audio.duration, audio.currentTime + step); }
      if (ev.key === 'ArrowLeft')  { ev.preventDefault(); audio.currentTime = Math.max(0, audio.currentTime - step); }
    });

    setVolume(80);
  }

  navBtn.addEventListener('click', ev => {
    ev.stopPropagation();
    const open = navMenu.classList.toggle('open');
    navBtn.setAttribute('aria-expanded', String(open));
  });

  document.querySelectorAll('.nav-dropdown-item').forEach(item => {
    item.addEventListener('click', () => {
      navMenu.classList.remove('open');
      navBtn.setAttribute('aria-expanded', 'false');
      if (item.dataset.tab === currentTab) return;
      currentTab = item.dataset.tab;
      navText.textContent = item.textContent.trim();
      document.querySelectorAll('.nav-dropdown-item').forEach(i => i.classList.toggle('active', i === item));
      if (allData) renderEras(searchBox.value, audio);
    });
  });

  filterBtn.addEventListener('click', ev => {
    ev.stopPropagation();
    const open = filterMenu.classList.toggle('open');
    filterBtn.setAttribute('aria-expanded', String(open));
  });

  filterMenu.addEventListener('click', ev => {
    const item = ev.target.closest('.filter-item');
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
    if (allData) renderEras(searchBox.value, audio);
  });

  document.addEventListener('keydown', ev => {
    if (ev.key === '/' && document.activeElement !== searchBox) {
      ev.preventDefault();
      searchBox.focus();
    }
    if (ev.key === 'Escape') {
      searchBox.blur();
      filterMenu.classList.remove('open');
      filterBtn.setAttribute('aria-expanded', 'false');
      navMenu.classList.remove('open');
      navBtn.setAttribute('aria-expanded', 'false');
      closeAllSongDropdowns();
    }
  });

  document.addEventListener('click', ev => {
    if (!filterMenu.contains(ev.target) && ev.target !== filterBtn) {
      filterMenu.classList.remove('open');
      filterBtn.setAttribute('aria-expanded', 'false');
    }
    if (!navMenu.contains(ev.target) && !navBtn.contains(ev.target)) {
      navMenu.classList.remove('open');
      navBtn.setAttribute('aria-expanded', 'false');
    }
    if (!ev.target.closest('.song-dropdown')) closeAllSongDropdowns();
  });

  window.addEventListener('scroll', () => {
    const show = scrollY > 400;
    scrollBtn.classList.toggle('visible', show);
    closeAllSongDropdowns();
  }, { passive: true });

  scrollBtn.addEventListener('click', () => scrollTo({ top: 0, behavior: 'smooth' }));

  (async () => {
    const fetchCsv = async id => {
      const res = await fetch(`https://docs.google.com/spreadsheets/d/${id}/export?format=csv`);
      if (!res.ok) throw new Error(`HTTP ${res.status}`);
      return res.text();
    };

    try {
      let csv;
      try       { csv = await fetchCsv(SHEET_ID); }
      catch (_) { csv = await fetchCsv(SHEET_ID_FALLBACK); }
      allData = buildData(parseCsv(csv));
      renderEras('', audio);
    } catch (err) {
      console.error('Failed to load vault data:', err);
      const el = document.createElement('div');
      el.className = 'error-msg';
      el.textContent = 'Failed to load data — check your connection or sheet permissions.';
      document.getElementById('era-list').replaceChildren(el);
    }
  })();
});
