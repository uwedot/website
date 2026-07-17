'use strict';

const DefaultSheetId = '1cC-caBQ4j-OWreS37ackw7Gkkq83Hvi6x-mIRHBLxJo';
const StemsSheetGid  = '495336364';
const StemCategories  = ['Studio Stems', 'Instrumentals', 'Acapellas', 'TV Tracks', 'Stem Player Stems', 'Sessions'];

const ArtistPresets = [
  { name: 'Kanye West',     id: '1cC-caBQ4j-OWreS37ackw7Gkkq83Hvi6x-mIRHBLxJo' },
  { name: 'Kanye West Alt', id: '12nGHPPh5dVTfLuBLVQYzC3QgPxKfvp-jgCoNccvEasM' },
  { name: 'Drake',          id: '1v55XAPLzw1iuWxH1OQKajCIYPhW2BXcLoV4mXDZ55DI' },
  { name: 'Playboi Carti',  id: '1Irtfvymu26CShYowLMMfD-rM0o9CJqE6-BBSlYsAaF4' },
];

const RecentSongsLimit  = 100;
const SheetRateWindow   = 60_000;
const SheetRateMax      = 3;
const SearchDebounceMs  = 200;
const ReloadCountdownMs = 5_000;

const TabMarkers = {
  best:    ['⭐'],
  special: ['✨'],
};

const QualityMap = [
  { key: 'lossless', cls: 'q-lossless', test: l => l.includes('lossless') },
  { key: 'high',     cls: 'q-high',     test: l => l.includes('high')     },
  { key: 'cd',       cls: 'q-cd',       test: l => l.includes('cd')       },
  { key: 'rec',      cls: 'q-rec',      test: l => l.includes('record')   },
  { key: 'low',      cls: 'q-low',      test: l => l.includes('low')      },
  { key: 'unavail',  cls: null,         test: l => l.includes('not avail') || l.includes('unavail') },
];

const AvailLenClassMap = [
  { test: l => /\bog\b/.test(l),        cls: 'tl-og'        },
  { test: l => l.includes('lossless'),  cls: 'tl-other'     },
  { test: l => l.includes('stem'),      cls: 'tl-stem'      },
  { test: l => l.includes('full'),      cls: 'tl-full'      },
  { test: l => l.includes('tagged'),    cls: 'tl-tagged'    },
  { test: l => l.includes('partial'),   cls: 'tl-partial'   },
  { test: l => l.includes('snippet'),   cls: 'tl-snippet'   },
  { test: l => l.includes('unavail'),   cls: 'tl-unavail'   },
  { test: l => l.includes('confirmed'), cls: 'tl-confirmed' },
  { test: l => l.includes('rumored'),   cls: 'tl-rumored'   },
  { test: l => l.includes('vox'),       cls: 'tl-vox'       },
];

const VersionPattern = /[[(](v(?:ersion)?\s*\d+)[\])]/i;
const UrlPattern     = /^https?:/i;
const PillowsHost    = 'pillows.su/f/';
const PillowsApi     = 'https://api.pillows.su/api/get/';
const PillowsDlApi   = 'https://api.pillows.su/api/download/';

const AllQualityKeys = QualityMap.map(q => q.key);

const State = {
  PrimarySheetId:        DefaultSheetId,
  VaultData:             null,
  EraDescriptions:       {},
  StemsData:             null,
  CurrentTab:            'all',
  ActiveQualities:       new Set(AllQualityKeys),
  ShowPlayableOnly:      false,
  IsLoading:             false,
  HasOpenDropdown:       false,
  SearchDebounceId:      null,
  CountdownId:           null,
  CooldownIntervalId:    null,
  SheetChangeTimestamps: JSON.parse(localStorage.getItem('sheetChangeTs') || '[]'),
};

const PlayBtnMap  = new Map();
const OpenPanels  = new Set();
const DateCache   = new Map();

const HtmlEscapeMap = { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;' };
const HtmlEscapeRe  = /[&<>"]/g;

function EscapeHtml(str) {
  return String(str).replace(HtmlEscapeRe, c => HtmlEscapeMap[c]);
}

function FormatTime(seconds) {
  if (!isFinite(seconds) || seconds < 0) return '0:00';
  const s = Math.floor(seconds);
  return `${Math.floor(s / 60)}:${String(s % 60).padStart(2, '0')}`;
}

function FormatCountdown(ms) {
  if (ms <= 0) return '0s';
  const totalSec = Math.ceil(ms / 1000);
  const min = Math.floor(totalSec / 60);
  const sec = totalSec % 60;
  return min > 0 ? `${min}m ${sec}s` : `${sec}s`;
}

function ParseDateToTimestamp(dateStr) {
  if (!dateStr) return 0;
  const cached = DateCache.get(dateStr);
  if (cached !== undefined) return cached;

  let result = Date.parse(dateStr);
  if (isNaN(result)) {
    const m = dateStr.match(/\b(19|20)\d{2}\b/);
    result = m ? new Date(m[0], 0, 1).getTime() : 0;
  }

  if (DateCache.size >= 500) DateCache.clear();
  DateCache.set(dateStr, result);
  return result;
}

function ResolveUrl(url) {
  try { return new URL(url).href; } catch { return url; }
}

function NormaliseKey(s) {
  return s.toLowerCase().replace(/\s+/g, ' ').trim();
}

const Clamp = (v, lo, hi) => Math.max(lo, Math.min(hi, v));

function GetQualityClass(quality) {
  if (!quality) return 'q-other';
  const l = quality.toLowerCase();
  for (const { test, cls } of QualityMap) {
    if (cls && test(l)) return cls;
  }
  return 'q-other';
}

function GetAvailableLengthClass(availLen) {
  if (!availLen) return 'tl-other';
  const l = availLen.toLowerCase();
  for (const { test, cls } of AvailLenClassMap) {
    if (test(l)) return cls;
  }
  return 'tl-other';
}

function IsQualityVisible(quality) {
  const l = (quality || '').toLowerCase();
  if (!l) return State.ActiveQualities.has('unavail');
  for (const { key, test } of QualityMap) {
    if (State.ActiveQualities.has(key) && test(l)) return true;
  }
  return false;
}

function IsPlayable(linkString, quality) {
  if (!linkString) return false;
  const q = (quality || '').toLowerCase();
  if (q.includes('unavail') || q.includes('not avail')) return false;
  return linkString.split(/[\s,]+/).some(u => u.includes(PillowsHost));
}

const AudioPlayer = {
  AudioElement:    null,
  PlayerElement: null,
  Elements:      {},

  Init() {
    this.AudioElement    = document.getElementById('main-audio');
    this.PlayerElement = document.getElementById('global-player');
    if (!this.AudioElement || !this.PlayerElement) return;

    this.Elements = {
      PlayIcon:       document.getElementById('player-play-icon'),
      PauseIcon:      document.getElementById('player-pause-icon'),
      PlayPauseBtn:   document.getElementById('player-play-btn'),
      CloseBtn:       document.getElementById('player-close-btn'),
      CurrentTimeEl:  document.getElementById('player-current'),
      DurationEl:     document.getElementById('player-duration'),
      TrackNameEl:    document.getElementById('player-track-name'),
      TrackCurrentEl: document.getElementById('player-track-current'),
      TrackLengthEl:  document.getElementById('player-track-length'),
      ProgressFill:   document.getElementById('player-fill'),
      VolFill:        document.getElementById('player-vol-fill'),
      ScrubberEl:     document.getElementById('player-scrubber'),
      VolumeSlider:   document.getElementById('player-volume'),
    };

    this.BindAudioEvents();
    this.BindControls();
    this.BindSliders();
    this.BindMediaSession();
    this.SetVolume(80);
  },

  RegisterPlayBtn(btn, resolvedUrl) {
    if (!PlayBtnMap.has(resolvedUrl)) PlayBtnMap.set(resolvedUrl, new Set());
    PlayBtnMap.get(resolvedUrl).add(btn);
  },

  SyncPlayButtons() {
    const audio   = this.AudioElement;
    const current = audio.src ? ResolveUrl(audio.src) : '';
    const playing = !audio.paused;
    for (const [href, btns] of PlayBtnMap) {
      const label = (href === current && playing) ? 'Pause' : 'Play';
      for (const btn of btns) btn.textContent = label;
    }
  },

  ClearPlayButtons() {
    PlayBtnMap.clear();
  },

  SafePlay() {
    this.AudioElement.play().catch(() => {});
  },

  CurrentResolvedSrc() {
    return this.AudioElement.src ? ResolveUrl(this.AudioElement.src) : '';
  },

  PlayOrToggle(resolvedUrl, trackName) {
    const audio = this.AudioElement;
    if (this.CurrentResolvedSrc() === resolvedUrl) {
      if (audio.paused) this.SafePlay();
      else              audio.pause();
      return;
    }
    this.Elements.TrackNameEl.textContent = trackName;
    this.SetMediaSessionTrack(trackName);
    audio.pause();
    audio.removeAttribute('src');
    audio.load();
    audio.src = resolvedUrl;
    this.PlayerElement.removeAttribute('hidden');
    this.SafePlay();
  },

  Close() {
    const { AudioElement: audio, PlayerElement: playerEl } = this;
    audio.pause();
    audio.src = '';
    audio.load();
    playerEl.setAttribute('hidden', '');
    if ('mediaSession' in navigator) navigator.mediaSession.metadata = null;
    this.SetPlayState(false);
    this.SetProgress(0);
    this.SetCurrentTime('0:00');
    this.SetDuration('0:00');
    this.SyncPlayButtons();
  },

  SetVolume(pct) {
    const c = Clamp(pct, 0, 100);
    const { VolFill: volFill, VolumeSlider: volumeSlider } = this.Elements;
    volFill.style.width = `${c}%`;
    this.AudioElement.volume = c / 100;
    volumeSlider.setAttribute('aria-valuenow', Math.round(c));
  },

  SetPlayState(playing) {
    const { PlayIcon: playIcon, PauseIcon: pauseIcon, PlayPauseBtn: playPauseBtn } = this.Elements;
    playIcon.style.display  = playing ? 'none' : '';
    pauseIcon.style.display = playing ? ''     : 'none';
    playPauseBtn.setAttribute('aria-label', playing ? 'Pause' : 'Play');
  },

  SetProgress(pct) {
    const c = Clamp(pct, 0, 100);
    const { ProgressFill: progressFill, ScrubberEl: scrubberEl } = this.Elements;
    progressFill.style.width = `${c}%`;
    scrubberEl.setAttribute('aria-valuenow', Math.round(c));
  },

  SetCurrentTime(t) {
    this.Elements.CurrentTimeEl.textContent = this.Elements.TrackCurrentEl.textContent = t;
  },

  SetDuration(t) {
    this.Elements.DurationEl.textContent = this.Elements.TrackLengthEl.textContent = t;
  },

  BindAudioEvents() {
    const { AudioElement: audio, Elements: els } = this;

    audio.addEventListener('play',  () => { this.SetPlayState(true);  this.SyncPlayButtons(); });
    audio.addEventListener('pause', () => { this.SetPlayState(false); this.SyncPlayButtons(); });
    audio.addEventListener('ended', () => {
      this.SetPlayState(false);
      this.SetProgress(0);
      this.SetCurrentTime('0:00');
      this.SyncPlayButtons();
    });
    audio.addEventListener('loadedmetadata', () => this.SetDuration(FormatTime(audio.duration)));
    audio.addEventListener('error', () => {
      this.SetPlayState(false);
      els.TrackNameEl.textContent = 'Playback error, format not supported or unavailable';
    });
    audio.addEventListener('timeupdate', () => {
      if (!audio.duration) return;
      this.SetProgress((audio.currentTime / audio.duration) * 100);
      this.SetCurrentTime(FormatTime(audio.currentTime));
      if ('mediaSession' in navigator && navigator.mediaSession.setPositionState) {
        navigator.mediaSession.setPositionState({
          duration:     audio.duration,
          playbackRate: audio.playbackRate,
          position:     audio.currentTime,
        });
      }
    });
  },

  BindControls() {
    const { AudioElement: audio, Elements: els } = this;

    els.PlayPauseBtn.addEventListener('click', () => {
      if (audio.paused) this.SafePlay();
      else              audio.pause();
    });

    els.CloseBtn.addEventListener('click', () => this.Close());
  },

  BindSliders() {
    const { AudioElement: audio, Elements: els } = this;
    const { ScrubberEl: scrubberEl, VolumeSlider: volumeSlider } = els;

    const pctFromPointer = (ev, el) => {
      const rect = el.getBoundingClientRect();
      return rect.width ? Clamp((ev.clientX - rect.left) / rect.width, 0, 1) : 0;
    };
    const bindTouchSlider = (el, handler) => {
      el.addEventListener('touchstart', ev => handler(ev.touches[0]), { passive: true });
      el.addEventListener('touchmove',  ev => handler(ev.touches[0]), { passive: true });
    };

    let draggingProgress = false;
    let draggingVolume   = false;

    scrubberEl.addEventListener('mousedown', ev => {
      draggingProgress = true;
      if (audio.duration) audio.currentTime = pctFromPointer(ev, scrubberEl) * audio.duration;
    });
    volumeSlider.addEventListener('mousedown', ev => {
      draggingVolume = true;
      this.SetVolume(pctFromPointer(ev, volumeSlider) * 100);
    });
    window.addEventListener('mousemove', ev => {
      if (draggingProgress && audio.duration) audio.currentTime = pctFromPointer(ev, scrubberEl) * audio.duration;
      if (draggingVolume)                     this.SetVolume(pctFromPointer(ev, volumeSlider) * 100);
    });
    window.addEventListener('mouseup', () => { draggingProgress = false; draggingVolume = false; });

    bindTouchSlider(scrubberEl,   t => { if (audio.duration) audio.currentTime = pctFromPointer(t, scrubberEl) * audio.duration; });
    bindTouchSlider(volumeSlider, t => this.SetVolume(pctFromPointer(t, volumeSlider) * 100));

    scrubberEl.addEventListener('keydown', ev => {
      if (!audio.duration) return;
      const step = audio.duration * 0.02;
      if (ev.key === 'ArrowRight') { ev.preventDefault(); audio.currentTime = Math.min(audio.duration, audio.currentTime + step); }
      if (ev.key === 'ArrowLeft')  { ev.preventDefault(); audio.currentTime = Math.max(0,              audio.currentTime - step); }
    });
  },

  SetMediaSessionTrack(trackName) {
    if (!('mediaSession' in navigator)) return;
    navigator.mediaSession.metadata = new MediaMetadata({
      title:  trackName,
      artist: 'Mistape',
    });
  },

  BindMediaSession() {
    if (!('mediaSession' in navigator)) return;
    const { AudioElement: audio } = this;
    const ms = navigator.mediaSession;
    ms.setActionHandler('play',         () => this.SafePlay());
    ms.setActionHandler('pause',        () => audio.pause());
    ms.setActionHandler('stop',         () => { audio.pause(); audio.currentTime = 0; });
    ms.setActionHandler('seekto',       d => { if (d.seekTime !== undefined && audio.duration) audio.currentTime = d.seekTime; });
    ms.setActionHandler('seekbackward', d => { audio.currentTime = Math.max(0, audio.currentTime - (d.seekOffset || 10)); });
    ms.setActionHandler('seekforward',  d => { audio.currentTime = Math.min(audio.duration || 0, audio.currentTime + (d.seekOffset || 10)); });
  },
};

function CloseAllLinkDropdowns() {
  if (!State.HasOpenDropdown) return;
  document.querySelectorAll('.song-dropdown-menu.open').forEach(menu => {
    menu.classList.remove('open');
    menu.style.position = '';
    menu.style.top      = '';
    menu.style.left     = '';
    const btn = menu.previousElementSibling;
    if (btn) btn.setAttribute('aria-expanded', 'false');
  });
  State.HasOpenDropdown = false;
}

function PositionDropdown(menu, btn) {
  if (!menu || !btn) return;

  const btnRect = btn.getBoundingClientRect();
  const GAP = 4;

  const prevVis = menu.style.visibility;
  menu.style.visibility = 'hidden';
  menu.style.position   = 'fixed';
  menu.style.top        = '0';
  menu.style.left       = '0';
  menu.style.right      = 'auto';
  menu.style.margin     = '0';

  const menuH = menu.offsetHeight || 160;
  menu.style.visibility = prevVis;

  let top  = btnRect.bottom + GAP;
  let left = btnRect.right - menu.offsetWidth;
  if (left < 4) left = 4;
  if (top + menuH > window.innerHeight - 8) top = btnRect.top - menuH - GAP;

  menu.style.top  = top  + 'px';
  menu.style.left = left + 'px';
}

function ToggleDropdown(btn, menu) {
  const isOpen = menu.classList.toggle('open');
  btn.setAttribute('aria-expanded', String(isOpen));
  if (isOpen) {
    PositionDropdown(menu, btn);
  }
}

function CloseDropdown(btn, menu) {
  menu.classList.remove('open');
  btn.setAttribute('aria-expanded', 'false');
}

function CollapsePanel(panel) {
  if (!OpenPanels.has(panel)) return;
  panel.classList.remove('open');
  OpenPanels.delete(panel);
  const eraRow = panel.previousElementSibling;
  if (eraRow) {
    eraRow.classList.remove('active');
    eraRow.setAttribute('aria-expanded', 'false');
  }
}

function CollapseAllEraPanels() {
  for (const panel of OpenPanels) CollapsePanel(panel);
}

function OpenPanel(panel, eraRow) {
  panel.classList.add('open');
  OpenPanels.add(panel);
  eraRow.classList.add('active');
  eraRow.setAttribute('aria-expanded', 'true');
}

function BuildSongControls({ links, displayQuality, isUnavailable, songName, noPlay }) {
  let playBtnHtml = '';
  let downloadBtnHtml = '';
  let resolvedDownload = '';

  const pillowsLink = links.find(u => u.includes(PillowsHost));
  if (pillowsLink && !isUnavailable) {
    const pathStart = pillowsLink.indexOf(PillowsHost) + PillowsHost.length;
    const filePath  = pillowsLink.slice(pathStart);
    resolvedDownload = PillowsApi + filePath;
    if (noPlay) {
      const downloadUrl = PillowsDlApi + filePath;
      downloadBtnHtml = `<a class="song-download-btn" href="${EscapeHtml(downloadUrl)}" download target="_blank" rel="noopener noreferrer">Download</a>`;
    } else {
      playBtnHtml = `<button type="button" class="song-play-btn" data-name="${EscapeHtml(songName)}">Play</button>`;
    }
  }

  let linksHtml = '';
  if (links.length > 1) {
    const items = links.map((url, i) =>
      `<a class="song-dropdown-item" href="${EscapeHtml(url)}" target="_blank" rel="noopener noreferrer">Link ${i + 1}</a>`
    ).join('');
    linksHtml = `
      <div class="song-dropdown">
        <button type="button" class="song-dropdown-btn" aria-haspopup="true" aria-expanded="false">
          <span>Links</span>
          <svg class="dropdown-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true"><polyline points="6,9 12,15 18,9"/></svg>
        </button>
        <div class="song-dropdown-menu" role="menu">${items}</div>
      </div>`;
  } else if (links.length === 1) {
    linksHtml = `<a class="song-link-btn" href="${EscapeHtml(links[0])}" target="_blank" rel="noopener noreferrer">View</a>`;
  }

  return { playBtnHtml, downloadBtnHtml, linksHtml, resolvedDownload };
}

function BuildDatePillHtml(leakDate) {
  if (!leakDate) return '';
  const parsed = new Date(leakDate);
  if (isNaN(parsed)) return `<div class="song-date-pill">${EscapeHtml(leakDate)}</div>`;
  const dd   = String(parsed.getUTCDate()).padStart(2, '0');
  const mm   = String(parsed.getUTCMonth() + 1).padStart(2, '0');
  const yyyy = parsed.getUTCFullYear();
  return `<div class="song-date-pill">${dd}/${mm}/${yyyy}</div>`;
}

function BuildSongElement({ songName, quality, linkString, notes, trackNumber, availLen, recentEra, leakDate, noPlay }) {
  const safeNotes = (notes || '').trim();
  const hasNotes  = safeNotes !== '';

  const links = linkString
    ? linkString.split(/[\s,]+/).map(u => u.trim()).filter(u => UrlPattern.test(u))
    : [];

  const availLower      = (availLen || '').toLowerCase();
  const isRumoredOrConf = availLower.includes('rumored') || availLower.includes('confirmed');
  const displayQuality  = (links.length > 0 || isRumoredOrConf) ? quality : 'Unavailable';
  const displayQualLow  = (displayQuality || '').toLowerCase();
  const isUnavailable   = !displayQuality ||
    displayQualLow.includes('unavail') ||
    displayQualLow.includes('not avail');

  const { playBtnHtml, downloadBtnHtml, linksHtml, resolvedDownload } = BuildSongControls({
    links, displayQuality, isUnavailable, songName, noPlay,
  });

  const noteToggleHtml = hasNotes
    ? `<div class="note-toggle" role="button" tabindex="0" aria-label="Show note"></div>`
    : '';

  const versionMatch    = VersionPattern.exec(songName);
  const versionPillHtml = versionMatch
    ? `<div class="song-version-pill">${EscapeHtml(versionMatch[1])}</div>`
    : '';
  const displayName = versionMatch
    ? songName.replace(versionMatch[0], '').replace(/\s{2,}/g, ' ').trim()
    : songName;

  let topRowHtml = '';
  if (recentEra) {
    const datePillHtml = BuildDatePillHtml(leakDate);
    topRowHtml = `<div class="song-top-row"><div class="song-era-pill">${EscapeHtml(recentEra)}</div>${datePillHtml}</div>`;
  }

  const pillsHtml =
    versionPillHtml +
    (displayQuality ? `<div class="song-quality ${GetQualityClass(displayQuality)}">${EscapeHtml(displayQuality)}</div>` : '') +
    (availLen       ? `<div class="song-type ${GetAvailableLengthClass(availLen)}">${EscapeHtml(availLen)}</div>` : '');

  const songEl = document.createElement('div');
  songEl.className = 'song-item';
  songEl.setAttribute('role', 'listitem');
  songEl.innerHTML = `
    <div class="song-num">${trackNumber}</div>
    <div class="song-body">
      ${topRowHtml}
      <div class="song-name" title="${EscapeHtml(songName)}">${EscapeHtml(displayName)}</div>
      <div class="song-pills">${pillsHtml}</div>
    </div>
    <div class="song-btns">${playBtnHtml}${downloadBtnHtml}${linksHtml}${noteToggleHtml}</div>
  `;

  if (links.length > 1) {
    const dropBtn  = songEl.querySelector('.song-dropdown-btn');
    const dropMenu = songEl.querySelector('.song-dropdown-menu');
    dropBtn.addEventListener('click', ev => {
      ev.stopPropagation();
      const wasOpen = dropMenu.classList.contains('open');
      CloseAllLinkDropdowns();
      if (!wasOpen) {
        dropMenu.classList.add('open');
        dropBtn.setAttribute('aria-expanded', 'true');
        State.HasOpenDropdown = true;
        PositionDropdown(dropMenu, dropBtn);
      }
    });
  }

  const playBtn = songEl.querySelector('.song-play-btn');
  if (playBtn && resolvedDownload) {
    AudioPlayer.RegisterPlayBtn(playBtn, resolvedDownload);
    playBtn.addEventListener('click', ev => {
      ev.stopPropagation();
      CloseAllLinkDropdowns();
      AudioPlayer.PlayOrToggle(resolvedDownload, playBtn.dataset.name);
    });
  }

  if (hasNotes) {
    const noteEl = document.createElement('div');
    noteEl.className   = 'song-note';
    noteEl.textContent = safeNotes;
    const noteToggle = songEl.querySelector('.note-toggle');
    const toggleNote = () => {
      const expanded = songEl.classList.toggle('expanded');
      noteToggle.setAttribute('aria-label', expanded ? 'Hide note' : 'Show note');
    };
    noteToggle.addEventListener('click',   ev => { ev.stopPropagation(); toggleNote(); });
    noteToggle.addEventListener('keydown', ev => {
      if (ev.key === 'Enter' || ev.key === ' ') { ev.preventDefault(); toggleNote(); }
    });
    return [songEl, noteEl];
  }

  return [songEl];
}

function RenderSongs(songs, container) {
  const frag = document.createDocumentFragment();
  songs.forEach(([name, quality, link, notes, leakDate, availLen, recentEra], idx) => {
    BuildSongElement({
      songName:    name,
      quality,
      linkString:  link,
      notes,
      trackNumber: idx + 1,
      availLen:    availLen  || '',
      recentEra:   recentEra || '',
      leakDate:    leakDate  || '',
    }).forEach(node => frag.appendChild(node));
  });
  container.appendChild(frag);
  AudioPlayer.SyncPlayButtons();
}

function RenderStemsSongs(songs, container) {
  const byCategory = new Map();
  for (const song of songs) {
    const category = song[7] || '';
    if (!byCategory.has(category)) byCategory.set(category, []);
    byCategory.get(category).push(song);
  }

  const frag = document.createDocumentFragment();
  let trackNumber = 1;
  for (const category of StemCategories) {
    const group = byCategory.get(category);
    if (!group || !group.length) continue;

    const divider = document.createElement('div');
    divider.className   = 'stems-category-divider';
    divider.textContent = category;
    frag.appendChild(divider);

    group.forEach(([name, quality, link, notes, leakDate, availLen]) => {
      BuildSongElement({
        songName:    name,
        quality,
        linkString:  link,
        notes,
        trackNumber: trackNumber++,
        availLen:    availLen || '',
        recentEra:   '',
        leakDate:    leakDate || '',
        noPlay:      true,
      }).forEach(node => frag.appendChild(node));
    });
  }
  container.appendChild(frag);
  AudioPlayer.SyncPlayButtons();
}

function BuildFlatSongList(songs) {
  const wrap = document.createElement('div');
  wrap.className = 'songs-flat';
  wrap.setAttribute('role', 'list');
  wrap.setAttribute('aria-label', 'Recent songs');
  RenderSongs(songs, wrap);
  return wrap;
}

function BuildEraElement(era, songs) {
  const eraWrap = document.createElement('div');
  eraWrap.className = 'era-wrap';
  eraWrap.setAttribute('role', 'listitem');

  const eraRow = document.createElement('div');
  eraRow.className = 'era-row';
  eraRow.setAttribute('role', 'button');
  eraRow.setAttribute('tabindex', '0');
  eraRow.setAttribute('aria-expanded', 'false');
  eraRow.innerHTML = `
    <div class="era-row-name">${EscapeHtml(era)}</div>
    <div class="era-row-right">
      <div class="era-pill">${songs.length}</div>
      <svg class="era-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
        <polyline points="6,9 12,15 18,9"/>
      </svg>
    </div>
  `;

  const songsPanel = document.createElement('div');
  songsPanel.className = 'songs-panel';

  const eraDesc = State.EraDescriptions[NormaliseKey(era)] || '';
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
    CloseAllLinkDropdowns();
    if (OpenPanels.has(songsPanel)) {
      CollapsePanel(songsPanel);
    } else {
      CollapseAllEraPanels();
      OpenPanel(songsPanel, eraRow);
      eraRow.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
      if (!songsInner.dataset.loaded) {
        songsInner.dataset.loaded = '1';
        if (State.CurrentTab === 'stems') RenderStemsSongs(songs, songsInner);
        else                              RenderSongs(songs, songsInner);
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

function BuildRecentEras(filterLower) {
  const flat = [];
  for (const [era, songs] of Object.entries(State.VaultData)) {
    const eraLow = era.toLowerCase();
    for (const s of songs) {
      const [, q] = s;
      if (!IsQualityVisible(q)) continue;
      if (State.ShowPlayableOnly && !IsPlayable(s[2], q)) continue;
      flat.push({ era, eraLow, nameLow: s[0].toLowerCase(), name: s[0], quality: q, link: s[2], notes: s[3], leakDate: s[4] || '', availLen: s[5] || '' });
    }
  }
  flat.sort((a, b) => ParseDateToTimestamp(b.leakDate) - ParseDateToTimestamp(a.leakDate));

  const pool     = flat.slice(0, RecentSongsLimit);
  const filtered = filterLower
    ? pool.filter(s => s.nameLow.includes(filterLower))
    : pool;

  if (!filtered.length) return {};
  return {
    'Recent Leaks': filtered.map(s => [s.name, s.quality, s.link, s.notes, s.leakDate, s.availLen, s.era]),
  };
}

function BuildStemsEras(filterLower) {
  const result = {};
  if (!State.StemsData) return result;

  for (const [era, songs] of Object.entries(State.StemsData)) {
    const eraLow = filterLower ? era.toLowerCase() : '';
    const matched = songs.filter(song => {
      const [name, quality, link, , , , , category] = song;
      if (!category) return false;
      if (!IsQualityVisible(quality)) return false;
      if (State.ShowPlayableOnly && !IsPlayable(link, quality)) return false;
      if (filterLower && !name.toLowerCase().includes(filterLower)) return false;
      return true;
    });
    if (matched.length) result[era] = matched;
  }
  return result;
}

function BuildVisibleEras(filterLower) {
  if (State.CurrentTab === 'recent') return BuildRecentEras(filterLower);
  if (State.CurrentTab === 'stems')  return BuildStemsEras(filterLower);

  const markers = TabMarkers[State.CurrentTab] || null;
  const result  = {};
  for (const [era, songs] of Object.entries(State.VaultData)) {
    const eraLow = filterLower ? era.toLowerCase() : '';
    let matched = songs.filter(([, q]) => IsQualityVisible(q));
    if (State.ShowPlayableOnly) matched = matched.filter(([, q, link]) => IsPlayable(link, q));
    if (markers)     matched = matched.filter(([n]) => markers.some(m => n.includes(m)));
    if (filterLower) matched = matched.filter(([n]) => n.toLowerCase().includes(filterLower));
    if (matched.length) result[era] = matched;
  }
  return result;
}

function UpdateNavStats(total) {
  document.getElementById('nav-songs').textContent = total.toLocaleString();
}

function RenderEras(searchFilter) {
  const eraListEl = document.getElementById('era-list');
  if (!eraListEl || !State.VaultData) return;
  if (State.CurrentTab === 'stems' && !State.StemsData) {
    const msgEl = document.createElement('div');
    msgEl.className   = 'loading-msg';
    msgEl.textContent = 'Loading Data…';
    eraListEl.replaceChildren(msgEl);
    StemsLoader.Load();
    return;
  }

  const filterLower = (searchFilter || '').trim().toLowerCase();
  const visible     = BuildVisibleEras(filterLower);
  const keys        = Object.keys(visible);
  const total       = keys.reduce((sum, k) => sum + visible[k].length, 0);

  CollapseAllEraPanels();
  CloseAllLinkDropdowns();
  AudioPlayer.ClearPlayButtons();
  UpdateNavStats(total);

  const frag = document.createDocumentFragment();
  if (!keys.length) {
    const empty = document.createElement('div');
    empty.className   = 'no-results';
    empty.textContent = 'No results found.';
    frag.appendChild(empty);
  } else if (State.CurrentTab === 'recent') {
    for (const era of keys) frag.appendChild(BuildFlatSongList(visible[era]));
  } else {
    for (const era of keys) frag.appendChild(BuildEraElement(era, visible[era]));
  }
  eraListEl.replaceChildren(frag);
  OpenPanels.clear();
}

function GetSheetRateState() {
  const now            = Date.now();
  const recentTs       = State.SheetChangeTimestamps.filter(t => now - t < SheetRateWindow);
  const remaining      = SheetRateMax - recentTs.length;
  const oldestInWindow = recentTs[0] ?? null;
  const cooldownMs     = (remaining <= 0 && oldestInWindow)
    ? SheetRateWindow - (now - oldestInWindow)
    : 0;
  return { remaining, cooldownMs };
}

function RecordSheetChange() {
  const now = Date.now();
  State.SheetChangeTimestamps = State.SheetChangeTimestamps.filter(t => now - t < SheetRateWindow);
  State.SheetChangeTimestamps.push(now);
  localStorage.setItem('sheetChangeTs', JSON.stringify(State.SheetChangeTimestamps));
}

const VaultLoader = {
  Worker: new Worker('vault_worker.js'),
  LoadId: 0,

  Load(statusEl = null) {
    const loadId = ++this.LoadId;
    State.IsLoading = true;

    const showError = text => {
      let target = statusEl;
      if (!target) {
        target = document.createElement('div');
        document.getElementById('era-list').replaceChildren(target);
      }
      target.className   = 'error-msg';
      target.textContent = text;
    };

    this.Worker.postMessage({ type: 'ABORT' });
    this.Worker.postMessage({ type: 'LOAD', sheetId: State.PrimarySheetId });

    this.Worker.onmessage = ({ data }) => {
      if (loadId !== this.LoadId) return;

      if (data.type === 'SUCCESS') {
        State.IsLoading       = false;
        State.VaultData       = data.eraMap;
        State.EraDescriptions = data.eraDescs;
        RenderEras('');
        return;
      }

      if (data.type === 'ERROR') {
        State.IsLoading = false;
        const errText =
          data.reason === 'timeout' ? 'Request timed out, check your connection and try reloading.'
          : data.reason === 'http'  ? `Failed to load sheet (${data.message}), make sure it is publicly shared.`
          :                           'Failed to load data, check your connection or sheet permissions.';
        showError(errText);
      }
    };

    this.Worker.onerror = () => {
      if (loadId !== this.LoadId) return;
      State.IsLoading = false;
      showError('An unexpected error occurred while loading data.');
    };
  },

  Abort() {
    this.Worker.postMessage({ type: 'ABORT' });
  },
};

const StemsLoader = {
  Worker: new Worker('vault_worker.js'),
  LoadId: 0,

  Load() {
    const loadId = ++this.LoadId;

    this.Worker.postMessage({ type: 'ABORT' });
    this.Worker.postMessage({ type: 'LOAD', sheetId: State.PrimarySheetId, gid: StemsSheetGid });

    this.Worker.onmessage = ({ data }) => {
      if (loadId !== this.LoadId) return;

      if (data.type === 'SUCCESS') {
        State.StemsData = data.eraMap;
        if (State.CurrentTab === 'stems') RenderEras(document.getElementById('search-box')?.value ?? '');
        return;
      }

      if (data.type === 'ERROR') {
        if (State.CurrentTab !== 'stems') return;
        const eraList = document.getElementById('era-list');
        const errText =
          data.reason === 'timeout' ? 'Request timed out, check your connection and try reloading.'
          : data.reason === 'http'  ? `Failed to load stems (${data.message}), make sure the sheet is publicly shared.`
          :                           'Failed to load stems, check your connection or sheet permissions.';
        const errEl = document.createElement('div');
        errEl.className   = 'error-msg';
        errEl.textContent = errText;
        eraList.replaceChildren(errEl);
      }
    };

    this.Worker.onerror = () => {
      if (loadId !== this.LoadId) return;
      if (State.CurrentTab !== 'stems') return;
      const eraList = document.getElementById('era-list');
      const errEl = document.createElement('div');
      errEl.className   = 'error-msg';
      errEl.textContent = 'An unexpected error occurred while loading stems.';
      eraList.replaceChildren(errEl);
    };
  },

  Abort() {
    this.Worker.postMessage({ type: 'ABORT' });
  },
};

const RecentEnabledIds = new Set(
  ArtistPresets.filter(p => p.name.startsWith('Kanye West')).map(p => p.id)
);

function SyncRecentTabVisibility() {
  const recentItem = document.querySelector('.nav-dropdown-item[data-tab="recent"]');
  if (!recentItem) return;

  const IsRecentEnabled = RecentEnabledIds.has(State.PrimarySheetId);
  recentItem.style.display = IsRecentEnabled ? '' : 'none';

  if (!IsRecentEnabled && State.CurrentTab === 'recent') {
    State.CurrentTab = 'all';
    const navBtnLabel = document.getElementById('nav-btn-text');
    if (navBtnLabel) navBtnLabel.textContent = 'Unreleased';
    document.querySelectorAll('.nav-dropdown-item').forEach(n => {
      n.classList.toggle('active', n.dataset.tab === 'all');
    });
  }
}

function SyncStemsTabVisibility() {
  const stemsItem = document.querySelector('.nav-dropdown-item[data-tab="stems"]');
  if (!stemsItem) return;

  const isStemsEnabled = State.PrimarySheetId === DefaultSheetId;
  stemsItem.style.display = isStemsEnabled ? '' : 'none';

  if (!isStemsEnabled && State.CurrentTab === 'stems') {
    State.CurrentTab = 'all';
    const navBtnLabel = document.getElementById('nav-btn-text');
    if (navBtnLabel) navBtnLabel.textContent = 'Unreleased';
    document.querySelectorAll('.nav-dropdown-item').forEach(n => {
      n.classList.toggle('active', n.dataset.tab === 'all');
    });
  }
}

function ReloadWithSheetId(newId) {
  if (State.CountdownId !== null) {
    clearTimeout(State.CountdownId);
    State.CountdownId = null;
  }
  VaultLoader.Abort();
  StemsLoader.Abort();

  State.PrimarySheetId  = newId;
  State.VaultData       = null;
  State.EraDescriptions = {};
  State.StemsData       = null;
  State.IsLoading       = true;
  AudioPlayer.ClearPlayButtons();
  SyncRecentTabVisibility();
  SyncStemsTabVisibility();

  const eraList   = document.getElementById('era-list');
  const startTime = Date.now();
  const msgEl     = document.createElement('div');
  msgEl.className = 'loading-msg';
  eraList.replaceChildren(msgEl);

  const tick = () => {
    const elapsed   = Date.now() - startTime;
    const remaining = Math.max(0, ReloadCountdownMs - elapsed);
    msgEl.textContent = `Loading in ${FormatCountdown(remaining)}…`;
    if (remaining <= 0) {
      State.CountdownId = null;
      msgEl.textContent = 'Loading Data…';
      VaultLoader.Load(msgEl);
    } else {
      State.CountdownId = setTimeout(tick, 1_000);
    }
  };

  tick();
}

function InitNav(searchBox, navTabBtn, navTabMenu, navBtnLabel) {
  navTabBtn.addEventListener('click', ev => {
    ev.stopPropagation();
    ToggleDropdown(navTabBtn, navTabMenu);
  });
  document.querySelectorAll('.nav-dropdown-item').forEach(item => {
    item.addEventListener('click', () => {
      CloseDropdown(navTabBtn, navTabMenu);
      if (item.dataset.tab === State.CurrentTab) return;
      State.CurrentTab = item.dataset.tab;
      navBtnLabel.textContent = item.textContent.trim();
      document.querySelectorAll('.nav-dropdown-item').forEach(n => n.classList.toggle('active', n === item));
      if (State.VaultData) RenderEras(searchBox.value);
    });
  });
}

function InitQualityFilter(searchBox, filterBtn, filterMenu) {
  filterBtn.addEventListener('click', ev => {
    ev.stopPropagation();
    ToggleDropdown(filterBtn, filterMenu);
  });
  filterMenu.addEventListener('click', ev => {
    const item = ev.target.closest('.filter-item');
    if (!item) return;
    const key = item.dataset.quality;
    if (State.ActiveQualities.has(key)) {
      if (State.ActiveQualities.size === 1) return;
      State.ActiveQualities.delete(key);
      item.classList.remove('active');
      item.setAttribute('aria-checked', 'false');
    } else {
      State.ActiveQualities.add(key);
      item.classList.add('active');
      item.setAttribute('aria-checked', 'true');
    }
    if (State.VaultData) RenderEras(searchBox.value);
  });
}

function InitGlobalHandlers(searchBox, navTabBtn, navTabMenu, filterBtn, filterMenu) {
  searchBox.addEventListener('input', ev => {
    clearTimeout(State.SearchDebounceId);
    State.SearchDebounceId = setTimeout(() => {
      if (State.VaultData) RenderEras(ev.target.value);
    }, SearchDebounceMs);
  });

  document.addEventListener('keydown', ev => {
    if (ev.key === '/' && document.activeElement !== searchBox) {
      ev.preventDefault();
      searchBox.focus();
    }
    if (ev.key === 'Escape') {
      searchBox.blur();
      CloseDropdown(filterBtn, filterMenu);
      CloseDropdown(navTabBtn, navTabMenu);
      CloseAllLinkDropdowns();
    }
  });

  document.addEventListener('click', ev => {
    if (!filterMenu.contains(ev.target) && ev.target !== filterBtn) CloseDropdown(filterBtn, filterMenu);
    if (!navTabMenu.contains(ev.target) && !navTabBtn.contains(ev.target)) CloseDropdown(navTabBtn, navTabMenu);
    if (!ev.target.closest('.song-dropdown')) CloseAllLinkDropdowns();
  });

  window.addEventListener('scroll', () => {
    CloseAllLinkDropdowns();
  }, { passive: true });

  window.addEventListener('resize', () => {
    CloseAllLinkDropdowns();
  });
}

function InitSettings() {
  const settingsBtn    = document.getElementById('settings-btn');
  const modal          = document.getElementById('settings-modal');
  const closeBtn       = document.getElementById('settings-close-btn');
  const applyBtn       = document.getElementById('settings-apply-btn');
  const resetBtn       = document.getElementById('settings-reset-btn');
  const rateMsgEl      = document.getElementById('settings-rate-msg');
  const playableToggle = document.getElementById('playable-only-toggle');
  const artistSelect   = document.getElementById('settings-artist-select');

  const syncToggleUi = () => {
    playableToggle?.setAttribute('aria-checked', String(State.ShowPlayableOnly));
  };

  playableToggle?.addEventListener('click', () => {
    State.ShowPlayableOnly = playableToggle.getAttribute('aria-checked') !== 'true';
    syncToggleUi();
    if (State.VaultData) {
      const searchBox = document.getElementById('search-box');
      RenderEras(searchBox?.value ?? '');
    }
  });

  const stopCooldown = () => {
    clearInterval(State.CooldownIntervalId);
    State.CooldownIntervalId = null;
  };

  const getSelectedId = () => artistSelect?.value ?? '';

  const syncApplyBtn = () => {
    const { remaining } = GetSheetRateState();
    const selectedId    = getSelectedId();
    applyBtn.disabled   = !selectedId || selectedId === State.PrimarySheetId || remaining <= 0 || State.IsLoading;
  };

  const updateRateUi = () => {
    const { remaining, cooldownMs } = GetSheetRateState();
    if (remaining <= 0) {
      applyBtn.disabled     = true;
      rateMsgEl.textContent = `Rate limit reached. Try again in ${FormatCountdown(cooldownMs)}.`;
      rateMsgEl.hidden      = false;
      if (!State.CooldownIntervalId) {
        State.CooldownIntervalId = setInterval(() => {
          const { remaining: r, cooldownMs: c } = GetSheetRateState();
          if (r > 0) {
            rateMsgEl.hidden      = true;
            rateMsgEl.textContent = '';
            stopCooldown();
            syncApplyBtn();
          } else {
            rateMsgEl.textContent = `Rate limit reached. Try again in ${FormatCountdown(c)}.`;
          }
        }, 1_000);
      }
    } else {
      rateMsgEl.hidden      = true;
      rateMsgEl.textContent = '';
      stopCooldown();
    }
  };

  const syncArtistSelect = () => {
    if (!artistSelect) return;
    const match = ArtistPresets.find(p => p.id === State.PrimarySheetId);
    if (match) artistSelect.value = match.id;
  };

  artistSelect?.addEventListener('change', syncApplyBtn);

  const applySheetId = newId => {
    const { remaining } = GetSheetRateState();
    if (remaining <= 0) { updateRateUi(); return; }
    RecordSheetChange();
    closeModal();
    ReloadWithSheetId(newId);
  };

  const openModal = () => {
    syncToggleUi();
    syncArtistSelect();
    updateRateUi();
    syncApplyBtn();
    modal.removeAttribute('hidden');
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

  applyBtn.addEventListener('click', () => {
    const newId = getSelectedId();
    if (!newId || newId === State.PrimarySheetId) { closeModal(); return; }
    applySheetId(newId);
  });

  resetBtn.addEventListener('click', () => {
    if (State.PrimarySheetId === DefaultSheetId) { closeModal(); return; }
    applySheetId(DefaultSheetId);
  });
}

document.addEventListener('DOMContentLoaded', () => {
  const searchBox   = document.getElementById('search-box');
  const filterBtn   = document.getElementById('quality-filter-btn');
  const filterMenu  = document.getElementById('quality-filter-menu');
  const navTabBtn   = document.getElementById('nav-tab-btn');
  const navTabMenu  = document.getElementById('nav-tab-menu');
  const navBtnLabel = document.getElementById('nav-btn-text');

  AudioPlayer.Init();
  InitNav(searchBox, navTabBtn, navTabMenu, navBtnLabel);
  InitQualityFilter(searchBox, filterBtn, filterMenu);
  InitGlobalHandlers(searchBox, navTabBtn, navTabMenu, filterBtn, filterMenu);
  InitSettings();
  SyncRecentTabVisibility();
  SyncStemsTabVisibility();
  VaultLoader.Load();
});