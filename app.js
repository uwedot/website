'use strict';

const PrimarySheetId   = '1cC-caBQ4j-OWreS37ackw7Gkkq83Hvi6x-mIRHBLxJo';
const FallbackSheetId  = '12nGHPPh5dVTfLuBLVQYzC3QgPxKfvp-jgCoNccvEasM';
const RecentSongsLimit = 200;
const FetchTimeoutMs   = 12000;

const TabMarkers = {
  best:    ['⭐'],
  special: ['✨'],
  grails:  ['🏆', '🏅'],
  ai:      ['🤖']
};

const QualityMatchers = {
  high:     label => label.includes('high'),
  low:      label => label.includes('low') && !label.includes('high'),
  rec:      label => label.includes('record'),
  cd:       label => label.includes('cd'),
  lossless: label => label.includes('lossless'),
  unavail:  label => label.includes('not avail') || label.includes('unavail')
};

let VaultData        = null;
let EraDescriptions  = {};
let CurrentTab      = 'all';
let ActiveQualities = new Set(['high', 'low', 'rec', 'cd', 'lossless', 'unavail']);
let SearchDebounce  = null;
let EraListEl       = null;
let HasOpenDropdown = false;

const PlayBtnMap = new Map();
const OpenPanels = new Set();
const DateCache  = new Map();

function EscapeHtml(str) {
  return String(str)
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;');
}

function FormatTime(seconds) {
  if (!isFinite(seconds) || seconds < 0) return '0:00';
  return `${Math.floor(seconds / 60)}:${String(Math.floor(seconds % 60)).padStart(2, '0')}`;
}

function ParseDateToTimestamp(dateString) {
  if (!dateString) return 0;
  if (DateCache.has(dateString)) return DateCache.get(dateString);
  const parsed = Date.parse(dateString);
  if (!isNaN(parsed)) { DateCache.set(dateString, parsed); return parsed; }
  const yearMatch = dateString.match(/\b(19|20)\d{2}\b/);
  const result = yearMatch ? new Date(yearMatch[0], 0, 1).getTime() : 0;
  DateCache.set(dateString, result);
  return result;
}

function ResolveUrl(url) {
  try { return new URL(url).href; } catch { return url; }
}

function GetQualityClass(quality) {
  if (!quality) return 'q-other';
  const lower = quality.toLowerCase();
  if (lower.includes('lossless')) return 'q-lossless';
  if (lower.includes('high'))     return 'q-high';
  if (lower.includes('cd'))       return 'q-cd';
  if (lower.includes('low'))      return 'q-low';
  if (lower.includes('record'))   return 'q-rec';
  return 'q-other';
}

function GetAvailableLengthClass(availableLength) {
  if (!availableLength) return 'tl-other';
  const lower = availableLength.toLowerCase();
  if (/\bog\b/.test(lower))        return 'tl-og';
  if (lower.includes('lossless'))  return 'tl-other';
  if (lower.includes('stem'))      return 'tl-stem';
  if (lower.includes('full'))      return 'tl-full';
  if (lower.includes('tagged'))    return 'tl-tagged';
  if (lower.includes('partial'))   return 'tl-partial';
  if (lower.includes('snippet'))   return 'tl-snippet';
  if (lower.includes('unavail'))   return 'tl-unavail';
  if (lower.includes('confirmed')) return 'tl-confirmed';
  if (lower.includes('rumored'))   return 'tl-rumored';
  if (lower.includes('vox'))       return 'tl-vox';
  return 'tl-other';
}

function IsQualityVisible(quality) {
  const lower = (quality || '').toLowerCase();
  if (!lower) return ActiveQualities.has('unavail');
  for (const key of ActiveQualities) {
    if (QualityMatchers[key](lower)) return true;
  }
  return false;
}

function ParseCsv(text) {
  const rows = [];
  let field = '', row = [];
  let insideQuotes = false;
  for (let i = 0; i < text.length; i++) {
    const char = text[i];
    if (insideQuotes) {
      if (char === '"' && text[i + 1] === '"') { field += '"'; i++; }
      else if (char === '"') insideQuotes = false;
      else field += char;
    } else {
      if (char === '"')       insideQuotes = true;
      else if (char === ',')  { row.push(field); field = ''; }
      else if (char === '\n') { row.push(field); rows.push(row); row = []; field = ''; }
      else if (char !== '\r') field += char;
    }
  }
  if (field || row.length) { row.push(field); rows.push(row); }
  return rows;
}

function BuildVaultData(rows) {
  const EraMap   = {};
  const EraDescs = {};
  if (rows.length < 2) return { EraMap, EraDescs };

  const headers = rows[0].map(h => h.trim().toLowerCase());

  let leakDateIndex = headers.indexOf('leak date');
  if (leakDateIndex === -1) leakDateIndex = headers.findIndex(h => h.includes('date'));

  let linkIndex = headers.indexOf('link(s)');
  if (linkIndex === -1) linkIndex = headers.findIndex(h => h.includes('link'));

  const Columns = {
    era:             headers.indexOf('era'),
    name:            headers.indexOf('name'),
    quality:         headers.indexOf('quality'),
    link:            linkIndex,
    notes:           headers.indexOf('notes'),
    leakDate:        leakDateIndex,
    availableLength: headers.findIndex(h => h.includes('available length'))
  };

  // The era header row has summary counts in the era cell and the era name in the name cell.
  // The description paragraph sits in the leakDate column of that same row.
  const SummaryRowPattern = /^\d+\s+(og file|full|tagged|partial|snippet|stem bounce|unavailable)/i;

  for (let i = 1; i < rows.length; i++) {
    const row = rows[i];
    if (!row || row.every(cell => !cell.trim())) continue;

    const era  = (row[Columns.era]  || '').trim();
    const name = (row[Columns.name] || '').trim();
    if (!era || !name) continue;

    // Era header row: summary counts in era col, era name in name col
    if (SummaryRowPattern.test(era)) {
      // name holds the era title (may include a subtitle in parens — strip it)
      const EraTitle = name.replace(/\s*\(.*$/s, '').trim();
      if (EraTitle && Columns.leakDate !== -1) {
        const desc = (row[Columns.leakDate] || '').trim();
        if (desc) EraDescs[EraTitle] = desc;
      }
      continue;
    }
    if (SummaryRowPattern.test(name)) continue;

    if (!EraMap[era]) EraMap[era] = [];
    EraMap[era].push([
      name,
      (row[Columns.quality] || '').trim(),
      Columns.link            !== -1 ? (row[Columns.link]            || '').trim() : '',
      (row[Columns.notes]    || '').trim(),
      Columns.leakDate        !== -1 ? (row[Columns.leakDate]        || '').trim() : '',
      Columns.availableLength !== -1 ? (row[Columns.availableLength] || '').trim() : ''
    ]);
  }
  return { EraMap, EraDescs };
}

function RegisterPlayBtn(btn, url) {
  if (!PlayBtnMap.has(url)) PlayBtnMap.set(url, new Set());
  PlayBtnMap.get(url).add(btn);
}

function SyncPlayButtonStates(Audio) {
  if (!Audio) return;
  const CurrentHref = Audio.src ? ResolveUrl(Audio.src) : '';
  const IsPaused = Audio.paused;
  for (const [UrlHref, Btns] of PlayBtnMap) {
    const Label = (UrlHref === CurrentHref && !IsPaused) ? 'Pause' : 'Play';
    for (const Btn of Btns) Btn.textContent = Label;
  }
}

function CloseAllLinkDropdowns() {
  if (!HasOpenDropdown) return;
  document.querySelectorAll('.song-dropdown-menu.open').forEach(menu => menu.classList.remove('open'));
  HasOpenDropdown = false;
}

function ToggleDropdown(Btn, Menu) {
  const IsOpen = Menu.classList.toggle('open');
  Btn.setAttribute('aria-expanded', String(IsOpen));
}

function CloseDropdown(Btn, Menu) {
  Menu.classList.remove('open');
  Btn.setAttribute('aria-expanded', 'false');
}

function CollapsePanel(SongsPanel) {
  if (!OpenPanels.has(SongsPanel)) return;
  SongsPanel.classList.remove('open');
  OpenPanels.delete(SongsPanel);
  const EraRow = SongsPanel.previousElementSibling;
  if (EraRow) { EraRow.classList.remove('active'); EraRow.setAttribute('aria-expanded', 'false'); }
}

function CollapseAllEraPanels() {
  for (const Panel of [...OpenPanels]) CollapsePanel(Panel);
}

function OpenPanel(SongsPanel, EraRow) {
  SongsPanel.classList.add('open');
  OpenPanels.add(SongsPanel);
  EraRow.classList.add('active');
  EraRow.setAttribute('aria-expanded', 'true');
}

function SetMediaSession(TrackName) {
  if (!('mediaSession' in navigator)) return;
  navigator.mediaSession.metadata = new MediaMetadata({
    title:  TrackName,
    artist: 'YE VAULT'
  });
}

function BindMediaSessionHandlers(Audio) {
  if (!('mediaSession' in navigator)) return;
  navigator.mediaSession.setActionHandler('play',         () => Audio.play().catch(() => {}));
  navigator.mediaSession.setActionHandler('pause',        () => Audio.pause());
  navigator.mediaSession.setActionHandler('stop',         () => { Audio.pause(); Audio.currentTime = 0; });
  navigator.mediaSession.setActionHandler('seekto',       d  => { if (d.seekTime !== undefined && Audio.duration) Audio.currentTime = d.seekTime; });
  navigator.mediaSession.setActionHandler('seekbackward', d  => { Audio.currentTime = Math.max(0, Audio.currentTime - (d.seekOffset || 10)); });
  navigator.mediaSession.setActionHandler('seekforward',  d  => { Audio.currentTime = Math.min(Audio.duration || 0, Audio.currentTime + (d.seekOffset || 10)); });
}

function BuildSongElement(SongName, Quality, LinkString, Notes, TrackNumber, AvailableLength, Audio, RawName) {
  const SafeNotes = (Notes || '').trim();
  const HasNotes  = SafeNotes !== '';

  const Links = LinkString
    ? LinkString.split(/[\s,\n\r]+/).map(u => u.trim()).filter(u => /^https?:/i.test(u))
    : [];

  const AvailLower         = (AvailableLength || '').toLowerCase();
  const IsRumoredOrConfirmed = AvailLower.includes('rumored') || AvailLower.includes('confirmed');
  const DisplayQuality     = (Links.length > 0 || IsRumoredOrConfirmed) ? Quality : 'Unavailable';
  const IsUnavailable      = !DisplayQuality || DisplayQuality.toLowerCase().includes('unavail') || DisplayQuality.toLowerCase().includes('not avail');

  const PillowsLink = Links.find(u => u.includes('pillows.su/f/'));
  let PlayButtonHtml = '';
  let DownloadUrl    = '';

  if (PillowsLink && !IsUnavailable) {
    DownloadUrl = PillowsLink.replace('pillows.su/f/', 'api.pillows.su/api/download/');
    let ButtonLabel = 'Play';
    if (Audio?.src) {
      try {
        if (ResolveUrl(Audio.src) === ResolveUrl(DownloadUrl) && !Audio.paused) ButtonLabel = 'Pause';
      } catch {}
    }
    PlayButtonHtml = `<button type="button" class="song-play-btn play-btn" data-name="${EscapeHtml(RawName || SongName)}">${ButtonLabel}</button>`;
  }

  let LinksHtml = '';
  if (Links.length > 1) {
    const LinkItems = Links.map((url, i) =>
      `<a class="song-dropdown-item" href="${EscapeHtml(url)}" target="_blank" rel="noopener noreferrer">Link ${i + 1}</a>`
    ).join('');
    LinksHtml = `<div class="song-dropdown">
      <button type="button" class="song-dropdown-btn" aria-haspopup="true" aria-expanded="false">
        <span>Links</span>
        <svg class="dropdown-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true"><polyline points="6,9 12,15 18,9"/></svg>
      </button>
      <div class="song-dropdown-menu" role="menu">${LinkItems}</div>
    </div>`;
  } else if (Links.length === 1) {
    LinksHtml = `<a class="song-link-btn" href="${EscapeHtml(Links[0])}" target="_blank" rel="noopener noreferrer">View</a>`;
  }

  const NoteToggleHtml = HasNotes
    ? `<div class="note-toggle" role="button" tabindex="0" aria-label="Show note">＋</div>`
    : '';

  const PillsHtml =
    (DisplayQuality  ? `<div class="song-quality ${GetQualityClass(DisplayQuality)}">${EscapeHtml(DisplayQuality)}</div>` : '') +
    (AvailableLength ? `<div class="song-type ${GetAvailableLengthClass(AvailableLength)}">${EscapeHtml(AvailableLength)}</div>` : '');

  const SongEl = document.createElement('div');
  SongEl.className = 'song-item';
  SongEl.setAttribute('role', 'listitem');
  SongEl.innerHTML = `
    <div class="song-num">${TrackNumber}</div>
    <div class="song-name" title="${EscapeHtml(SongName)}">${EscapeHtml(SongName)}</div>
    <div class="song-pills">${PillsHtml}</div>
    <div class="song-btns">${PlayButtonHtml}${LinksHtml}${NoteToggleHtml}</div>
  `;

  if (Links.length > 1) {
    const DropBtn  = SongEl.querySelector('.song-dropdown-btn');
    const DropMenu = SongEl.querySelector('.song-dropdown-menu');
    DropBtn.addEventListener('click', event => {
      event.stopPropagation();
      const WasOpen = DropMenu.classList.contains('open');
      CloseAllLinkDropdowns();
      if (!WasOpen) {
        DropMenu.classList.add('open');
        DropBtn.setAttribute('aria-expanded', 'true');
        HasOpenDropdown = true;
      }
    });
  }

  const PlayBtn = SongEl.querySelector('.play-btn');
  if (PlayBtn && DownloadUrl) {
    const ResolvedUrl = ResolveUrl(DownloadUrl);
    RegisterPlayBtn(PlayBtn, ResolvedUrl);

    PlayBtn.addEventListener('click', event => {
      event.stopPropagation();
      CloseAllLinkDropdowns();
      const Player     = document.getElementById('global-player');
      const CurrentHref = Audio.src ? ResolveUrl(Audio.src) : '';

      if (CurrentHref === ResolvedUrl) {
        if (Audio.paused) {
          Audio.play().catch(err => { if (err.name !== 'AbortError') console.warn('Play failed:', err); });
        } else {
          Audio.pause();
        }
      } else {
        document.getElementById('player-track-name').textContent = PlayBtn.dataset.name;
        SetMediaSession(PlayBtn.dataset.name);
        Audio.pause();
        Audio.src = ResolvedUrl;
        Audio.load();
        Player.removeAttribute('hidden');
        Audio.play().catch(err => { if (err.name !== 'AbortError') console.warn('Play failed:', err); });
      }
    });
  }

  if (HasNotes) {
    const NoteEl     = document.createElement('div');
    NoteEl.className = 'song-note';
    NoteEl.textContent = SafeNotes;

    const NoteToggle = SongEl.querySelector('.note-toggle');
    const ToggleNote = () => {
      const IsExpanded = SongEl.classList.toggle('expanded');
      NoteToggle.textContent = IsExpanded ? '－' : '＋';
      NoteToggle.setAttribute('aria-label', IsExpanded ? 'Hide note' : 'Show note');
    };
    NoteToggle.addEventListener('click',   event => { event.stopPropagation(); ToggleNote(); });
    NoteToggle.addEventListener('keydown', event => {
      if (event.key === 'Enter' || event.key === ' ') { event.preventDefault(); ToggleNote(); }
    });
    return [SongEl, NoteEl];
  }

  return [SongEl];
}

function RenderSongs(Songs, SongsInner, Audio) {
  const Fragment = document.createDocumentFragment();
  Songs.forEach(([Name, Quality, Link, Notes, , AvailableLength, RawName], Index) => {
    BuildSongElement(Name, Quality, Link, Notes, Index + 1, AvailableLength || '', Audio, RawName)
      .forEach(Node => Fragment.appendChild(Node));
  });
  SongsInner.appendChild(Fragment);
  SyncPlayButtonStates(Audio);
}

function BuildRecentEras(FilterLower) {
  const FlatSongs = [];
  for (const [Era, Songs] of Object.entries(VaultData)) {
    Songs.filter(([, Quality]) => IsQualityVisible(Quality)).forEach(Song => {
      FlatSongs.push({
        Era,
        Name:            Song[0],
        Quality:         Song[1],
        Link:            Song[2],
        Notes:           Song[3],
        LeakDate:        Song[4] || '',
        AvailableLength: Song[5] || ''
      });
    });
  }
  FlatSongs.sort((A, B) => ParseDateToTimestamp(B.LeakDate) - ParseDateToTimestamp(A.LeakDate));

  const Pool = FlatSongs.slice(0, RecentSongsLimit);
  const Filtered = FilterLower
    ? Pool.filter(S => S.Name.toLowerCase().includes(FilterLower) || S.Era.toLowerCase().includes(FilterLower))
    : Pool;

  if (!Filtered.length) return {};
  return {
    'Recent Leaks': Filtered.map(S => [
      `[${S.Era}] ${S.Name}${S.LeakDate ? ` (${S.LeakDate})` : ''}`,
      S.Quality, S.Link, S.Notes, S.LeakDate, S.AvailableLength,
      S.Name
    ])
  };
}

function BuildVisibleEras(FilterLower) {
  if (CurrentTab === 'recent') return BuildRecentEras(FilterLower);

  const Markers = TabMarkers[CurrentTab] || null;
  const Result  = {};

  for (const [Era, Songs] of Object.entries(VaultData)) {
    let Matched = Songs.filter(([, Quality]) => IsQualityVisible(Quality));
    if (Markers)     Matched = Matched.filter(([Name]) => Markers.some(M => Name.includes(M)));
    if (FilterLower) Matched = Matched.filter(([Name]) => Name.toLowerCase().includes(FilterLower) || Era.toLowerCase().includes(FilterLower));
    if (Matched.length) Result[Era] = Matched;
  }
  return Result;
}

function UpdateNavStats(EraKeys, TotalSongs) {
  const ErasStat = document.getElementById('stat-eras');
  if (CurrentTab === 'recent') {
    ErasStat.hidden = true;
  } else {
    ErasStat.hidden = false;
    document.getElementById('nav-eras').textContent = EraKeys.length.toLocaleString();
  }
  document.getElementById('nav-songs').textContent = TotalSongs.toLocaleString();
}

function BuildEraElement(Era, Songs, Audio) {
  const EraWrap = document.createElement('div');
  EraWrap.className = 'era-wrap';
  EraWrap.setAttribute('role', 'listitem');

  const EraRow = document.createElement('div');
  EraRow.className = 'era-row';
  EraRow.setAttribute('role', 'button');
  EraRow.setAttribute('tabindex', '0');
  EraRow.setAttribute('aria-expanded', 'false');
  EraRow.innerHTML = `
    <div class="era-row-name">${EscapeHtml(Era)}</div>
    <div class="era-row-right">
      <div class="era-pill">${Songs.length}</div>
      <svg class="era-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
        <polyline points="6,9 12,15 18,9"/>
      </svg>
    </div>
  `;

  const SongsPanel = document.createElement('div');
  SongsPanel.className = 'songs-panel';

  const EraDesc = EraDescriptions[Era] || '';
  if (EraDesc) {
    const DescBlock = document.createElement('div');
    DescBlock.className = 'era-desc-block';
    DescBlock.textContent = EraDesc;
    SongsPanel.appendChild(DescBlock);
  }

  const SongsInner = document.createElement('div');
  SongsInner.className = 'songs-inner';
  SongsInner.setAttribute('role', 'list');
  SongsInner.setAttribute('aria-label', Era + ' songs');
  SongsPanel.appendChild(SongsInner);

  const Toggle = () => {
    CloseAllLinkDropdowns();
    if (OpenPanels.has(SongsPanel)) {
      CollapsePanel(SongsPanel);
    } else {
      CollapseAllEraPanels();
      OpenPanel(SongsPanel, EraRow);
      EraRow.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
      if (!SongsInner.dataset.loaded) {
        SongsInner.dataset.loaded = '1';
        RenderSongs(Songs, SongsInner, Audio);
      }
    }
  };

  EraRow.addEventListener('click', Toggle);
  EraRow.addEventListener('keydown', event => {
    if (event.key === 'Enter' || event.key === ' ') { event.preventDefault(); Toggle(); }
  });

  EraWrap.appendChild(EraRow);
  EraWrap.appendChild(SongsPanel);
  return EraWrap;
}

function RenderEras(SearchFilter, Audio) {
  if (!EraListEl || !VaultData) return;

  const FilterLower  = (SearchFilter || '').trim().toLowerCase();
  const VisibleEras  = BuildVisibleEras(FilterLower);
  const EraKeys      = Object.keys(VisibleEras);
  const TotalSongs   = EraKeys.reduce((Sum, Key) => Sum + VisibleEras[Key].length, 0);

  CollapseAllEraPanels();
  CloseAllLinkDropdowns();
  PlayBtnMap.clear();

  UpdateNavStats(EraKeys, TotalSongs);

  const Fragment = document.createDocumentFragment();

  if (!EraKeys.length) {
    const Empty = document.createElement('div');
    Empty.className   = 'no-results';
    Empty.textContent = 'No results found.';
    Fragment.appendChild(Empty);
    EraListEl.replaceChildren(Fragment);
    return;
  }

  for (const Era of EraKeys) {
    Fragment.appendChild(BuildEraElement(Era, VisibleEras[Era], Audio));
  }
  EraListEl.replaceChildren(Fragment);
}

function InitPlayer(Audio, PlayerEl) {
  if (!Audio) return;

  const PlayIcon      = document.getElementById('player-play-icon');
  const PauseIcon     = document.getElementById('player-pause-icon');
  const PlayPauseBtn  = document.getElementById('player-play-btn');
  const CloseBtn      = document.getElementById('player-close-btn');
  const CurrentTimeEl = document.getElementById('player-current');
  const DurationEl    = document.getElementById('player-duration');
  const TrackCurrentEl= document.getElementById('player-track-current');
  const TrackLengthEl = document.getElementById('player-track-length');
  const ProgressFill  = document.getElementById('player-fill');
  const ProgressThumb = document.getElementById('player-thumb');
  const VolumeFill    = document.getElementById('player-vol-fill');
  const VolumeThumb   = document.getElementById('player-vol-thumb');
  const ScrubberEl    = document.getElementById('player-scrubber');
  const VolumeSlider  = document.getElementById('player-volume');

  const SetPlayState = IsPlaying => {
    PlayIcon.style.display  = IsPlaying ? 'none' : '';
    PauseIcon.style.display = IsPlaying ? '' : 'none';
    PlayPauseBtn.setAttribute('aria-label', IsPlaying ? 'Pause' : 'Play');
  };

  const SetProgress = Percent => {
    const Clamped = Math.max(0, Math.min(100, Percent));
    ProgressFill.style.width = ProgressThumb.style.left = Clamped + '%';
    ScrubberEl.setAttribute('aria-valuenow', Math.round(Clamped));
  };

  const SetVolume = Percent => {
    const Clamped = Math.max(0, Math.min(100, Percent));
    VolumeFill.style.width = VolumeThumb.style.left = Clamped + '%';
    Audio.volume = Clamped / 100;
    VolumeSlider.setAttribute('aria-valuenow', Math.round(Clamped));
  };

  const SetCurrentTime = T => { CurrentTimeEl.textContent = TrackCurrentEl.textContent = T; };
  const SetDuration    = T => { DurationEl.textContent    = TrackLengthEl.textContent  = T; };

  const PercentFromPointer = (Event, El) => {
    const Rect = El.getBoundingClientRect();
    if (!Rect.width) return 0;
    return Math.max(0, Math.min(1, (Event.clientX - Rect.left) / Rect.width));
  };

  Audio.addEventListener('play',           () => { SetPlayState(true);  SyncPlayButtonStates(Audio); });
  Audio.addEventListener('pause',          () => { SetPlayState(false); SyncPlayButtonStates(Audio); });
  Audio.addEventListener('ended',          () => { SetPlayState(false); SetProgress(0); SetCurrentTime('0:00'); SyncPlayButtonStates(Audio); });
  Audio.addEventListener('durationchange', () => SetDuration(FormatTime(Audio.duration)));
  Audio.addEventListener('loadedmetadata', () => SetDuration(FormatTime(Audio.duration)));
  Audio.addEventListener('error',          () => {
    SetPlayState(false);
    const NameEl = document.getElementById('player-track-name');
    if (NameEl) NameEl.textContent = 'Playback error — format not supported or unavailable';
  });
  Audio.addEventListener('timeupdate', () => {
    if (!Audio.duration) return;
    SetProgress((Audio.currentTime / Audio.duration) * 100);
    SetCurrentTime(FormatTime(Audio.currentTime));
    if ('mediaSession' in navigator && navigator.mediaSession.setPositionState && Audio.duration > 0) {
      navigator.mediaSession.setPositionState({
        duration:     Audio.duration,
        playbackRate: Audio.playbackRate,
        position:     Audio.currentTime
      });
    }
  });

  PlayPauseBtn.addEventListener('click', () => {
    if (Audio.paused) {
      Audio.play().catch(err => { if (err.name !== 'AbortError') console.warn('Play failed:', err); });
    } else {
      Audio.pause();
    }
  });

  CloseBtn.addEventListener('click', () => {
    Audio.pause();
    Audio.src = '';
    Audio.load();
    PlayerEl.setAttribute('hidden', '');
    if ('mediaSession' in navigator) navigator.mediaSession.metadata = null;
    SetPlayState(false); SetProgress(0); SetCurrentTime('0:00'); SetDuration('0:00');
    SyncPlayButtonStates(Audio);
  });

  let IsDraggingProgress = false;
  let IsDraggingVolume   = false;

  ScrubberEl.addEventListener('mousedown',  Event => { IsDraggingProgress = true; if (Audio.duration) Audio.currentTime = PercentFromPointer(Event, ScrubberEl) * Audio.duration; });
  VolumeSlider.addEventListener('mousedown', Event => { IsDraggingVolume = true; SetVolume(PercentFromPointer(Event, VolumeSlider) * 100); });
  window.addEventListener('mousemove', Event => {
    if (IsDraggingProgress && Audio.duration) Audio.currentTime = PercentFromPointer(Event, ScrubberEl) * Audio.duration;
    if (IsDraggingVolume) SetVolume(PercentFromPointer(Event, VolumeSlider) * 100);
  });
  window.addEventListener('mouseup', () => { IsDraggingProgress = false; IsDraggingVolume = false; });

  ScrubberEl.addEventListener('touchstart',  Event => { if (Audio.duration) Audio.currentTime = PercentFromPointer(Event.touches[0], ScrubberEl) * Audio.duration; }, { passive: true });
  ScrubberEl.addEventListener('touchmove',   Event => { if (Audio.duration) Audio.currentTime = PercentFromPointer(Event.touches[0], ScrubberEl) * Audio.duration; }, { passive: true });
  VolumeSlider.addEventListener('touchstart', Event => SetVolume(PercentFromPointer(Event.touches[0], VolumeSlider) * 100), { passive: true });
  VolumeSlider.addEventListener('touchmove',  Event => SetVolume(PercentFromPointer(Event.touches[0], VolumeSlider) * 100), { passive: true });

  ScrubberEl.addEventListener('keydown', Event => {
    if (!Audio.duration) return;
    const Step = Audio.duration * 0.02;
    if (Event.key === 'ArrowRight') { Event.preventDefault(); Audio.currentTime = Math.min(Audio.duration, Audio.currentTime + Step); }
    if (Event.key === 'ArrowLeft')  { Event.preventDefault(); Audio.currentTime = Math.max(0, Audio.currentTime - Step); }
  });

  BindMediaSessionHandlers(Audio);
  SetVolume(80);
}

function InitNav(SearchBox, NavTabBtn, NavTabMenu, NavBtnLabel, Audio) {
  NavTabBtn.addEventListener('click', Event => {
    Event.stopPropagation();
    ToggleDropdown(NavTabBtn, NavTabMenu);
  });

  document.querySelectorAll('.nav-dropdown-item').forEach(Item => {
    Item.addEventListener('click', () => {
      CloseDropdown(NavTabBtn, NavTabMenu);
      if (Item.dataset.tab === CurrentTab) return;
      CurrentTab = Item.dataset.tab;
      NavBtnLabel.textContent = Item.textContent.trim();
      document.querySelectorAll('.nav-dropdown-item').forEach(N => N.classList.toggle('active', N === Item));
      if (VaultData) RenderEras(SearchBox.value, Audio);
    });
  });
}

function InitQualityFilter(SearchBox, QualityFilterBtn, QualityFilterMenu, Audio) {
  QualityFilterBtn.addEventListener('click', Event => {
    Event.stopPropagation();
    ToggleDropdown(QualityFilterBtn, QualityFilterMenu);
  });

  QualityFilterMenu.addEventListener('click', Event => {
    const Item = Event.target.closest('.filter-item');
    if (!Item) return;
    const Key = Item.dataset.quality;
    if (ActiveQualities.has(Key)) {
      if (ActiveQualities.size === 1) return;
      ActiveQualities.delete(Key);
      Item.classList.remove('active');
      Item.setAttribute('aria-checked', 'false');
    } else {
      ActiveQualities.add(Key);
      Item.classList.add('active');
      Item.setAttribute('aria-checked', 'true');
    }
    if (VaultData) RenderEras(SearchBox.value, Audio);
  });
}

function InitGlobalHandlers(SearchBox, ScrollTopBtn, NavTabBtn, NavTabMenu, QualityFilterBtn, QualityFilterMenu, Audio) {
  SearchBox.addEventListener('input', Event => {
    clearTimeout(SearchDebounce);
    SearchDebounce = setTimeout(() => {
      if (VaultData) RenderEras(Event.target.value, Audio);
    }, 200);
  });

  document.addEventListener('keydown', Event => {
    if (Event.key === '/' && document.activeElement !== SearchBox) {
      Event.preventDefault();
      SearchBox.focus();
    }
    if (Event.key === 'Escape') {
      SearchBox.blur();
      CloseDropdown(QualityFilterBtn, QualityFilterMenu);
      CloseDropdown(NavTabBtn, NavTabMenu);
      CloseAllLinkDropdowns();
    }
  });

  document.addEventListener('click', Event => {
    if (!QualityFilterMenu.contains(Event.target) && Event.target !== QualityFilterBtn) CloseDropdown(QualityFilterBtn, QualityFilterMenu);
    if (!NavTabMenu.contains(Event.target) && !NavTabBtn.contains(Event.target)) CloseDropdown(NavTabBtn, NavTabMenu);
    if (!Event.target.closest('.song-dropdown')) CloseAllLinkDropdowns();
  });

  window.addEventListener('scroll', () => {
    ScrollTopBtn.classList.toggle('visible', scrollY > 400);
    CloseAllLinkDropdowns();
  }, { passive: true });

  ScrollTopBtn.addEventListener('click', () => scrollTo({ top: 0, behavior: 'smooth' }));
}

async function FetchSheetCsv(SheetId) {
  const Res = await fetch(
    `https://docs.google.com/spreadsheets/d/${SheetId}/export?format=csv`,
    { signal: AbortSignal.timeout(FetchTimeoutMs) }
  );
  if (!Res.ok) throw new Error(`HTTP ${Res.status}`);
  return Res.text();
}

async function LoadVaultData(Audio) {
  try {
    let CsvText;
    try       { CsvText = await FetchSheetCsv(PrimarySheetId); }
    catch (_) { CsvText = await FetchSheetCsv(FallbackSheetId); }

    try {
      const { EraMap, EraDescs } = BuildVaultData(ParseCsv(CsvText));
      VaultData       = EraMap;
      EraDescriptions = EraDescs;
    } catch (ParseErr) {
      throw new Error(`Data parse failed: ${ParseErr.message}`);
    }

    RenderEras('', Audio);
  } catch (Error) {
    console.error('Failed to load vault data:', Error);
    const IsTimeout = Error.name === 'AbortError' || Error.name === 'TimeoutError';
    const ErrorMsg  = document.createElement('div');
    ErrorMsg.className   = 'error-msg';
    ErrorMsg.textContent = IsTimeout
      ? 'Request timed out — check your connection and try reloading.'
      : 'Failed to load data — check your connection or sheet permissions.';
    document.getElementById('era-list').replaceChildren(ErrorMsg);
  }
}

document.addEventListener('DOMContentLoaded', () => {
  EraListEl = document.getElementById('era-list');

  const SearchBox         = document.getElementById('search-box');
  const QualityFilterBtn  = document.getElementById('quality-filter-btn');
  const QualityFilterMenu = document.getElementById('quality-filter-menu');
  const ScrollTopBtn      = document.getElementById('scroll-top');
  const NavTabBtn         = document.getElementById('nav-tab-btn');
  const NavTabMenu        = document.getElementById('nav-tab-menu');
  const NavBtnLabel       = document.getElementById('nav-btn-text');
  const Audio             = document.getElementById('main-audio');
  const PlayerEl          = document.getElementById('global-player');

  InitPlayer(Audio, PlayerEl);
  InitNav(SearchBox, NavTabBtn, NavTabMenu, NavBtnLabel, Audio);
  InitQualityFilter(SearchBox, QualityFilterBtn, QualityFilterMenu, Audio);
  InitGlobalHandlers(SearchBox, ScrollTopBtn, NavTabBtn, NavTabMenu, QualityFilterBtn, QualityFilterMenu, Audio);
  LoadVaultData(Audio);
});
