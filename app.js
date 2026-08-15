'use strict';

const DefaultSheetId = '1wQ0WC0U9q10fLWpy9CO8YR128eE8msGXqtZI8_cNyTA';

const TabMarkers = {
  grails: ['⭐', '✨'],
};

const QualityMap = [
  { Key: 'lossless', Cls: 'q-lossless', Test: L => L.includes('lossless') },
  { Key: 'high', Cls: 'q-high', Test: L => L.includes('high') },
  { Key: 'cd', Cls: 'q-cd', Test: L => L.includes('cd') },
  { Key: 'rec', Cls: 'q-rec', Test: L => L.includes('record') },
  { Key: 'low', Cls: 'q-low', Test: L => L.includes('low') },
  { Key: 'unavail', Cls: null, Test: L => L.includes('not avail') || L.includes('unavail') },
];

const AvailLenClassMap = [
  { Test: L => /\bog\b/.test(L), Cls: 'tl-og' },
  { Test: L => L.includes('lossless'), Cls: 'tl-other' },
  { Test: L => L.includes('stem'), Cls: 'tl-stem' },
  { Test: L => L.includes('full'), Cls: 'tl-full' },
  { Test: L => L.includes('tagged'), Cls: 'tl-tagged' },
  { Test: L => L.includes('partial'), Cls: 'tl-partial' },
  { Test: L => L.includes('snippet'), Cls: 'tl-snippet' },
  { Test: L => L.includes('unavail'), Cls: 'tl-unavail' },
  { Test: L => L.includes('confirmed'), Cls: 'tl-confirmed' },
  { Test: L => L.includes('rumored'), Cls: 'tl-rumored' },
  { Test: L => L.includes('vox'), Cls: 'tl-vox' },
];

const VersionPattern = /[[(](v(?:ersion)?\s*\d+)[\])]/i;
const UrlPattern = /^https?:/i;
const PillowsHost = 'pillows.su/f/';
const PillowsApi = 'https://api.pillows.su/api/get/';
const AllQualityKeys = QualityMap.map(Q => Q.Key);

const State = {
  PrimarySheetId: DefaultSheetId,
  VaultData: null,
  EraDescriptions: {},
  CurrentTab: 'all',
  ActiveQualities: new Set(AllQualityKeys),
  ShowPlayableOnly: false,
  IsLoading: false,
  HasOpenDropdown: false,
  SearchDebounceId: null,
};

const PlayBtnMap = new Map();
const OpenPanels = new Set();

const HtmlEscapeMap = { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;' };
const HtmlEscapeRe = /[&<>"]/g;

function EscapeHtml(Str) {
  return String(Str).replace(HtmlEscapeRe, C => HtmlEscapeMap[C]);
}

function FormatTime(Seconds) {
  if (!isFinite(Seconds) || Seconds < 0) return '0:00';
  const S = Math.floor(Seconds);
  return `${Math.floor(S / 60)}:${String(S % 60).padStart(2, '0')}`;
}

function ParseDateToTimestamp(DateStr) {
  if (!DateStr) return 0;
  let Result = Date.parse(DateStr);
  if (isNaN(Result)) {
    const M = DateStr.match(/\b(19|20)\d{2}\b/);
    Result = M ? new Date(M[0], 0, 1).getTime() : 0;
  }
  return Result;
}

function ResolveUrl(Url) {
  try { return new URL(Url).href; } catch { return Url; }
}

function NormaliseKey(S) {
  return S.toLowerCase().replace(/\s+/g, ' ').trim();
}

const Clamp = (V, Lo, Hi) => Math.max(Lo, Math.min(Hi, V));

function GetQualityClass(Quality) {
  if (!Quality) return 'q-other';
  const L = Quality.toLowerCase();
  for (const { Test, Cls } of QualityMap) {
    if (Cls && Test(L)) return Cls;
  }
  return 'q-other';
}

function GetAvailableLengthClass(AvailLen) {
  if (!AvailLen) return 'tl-other';
  const L = AvailLen.toLowerCase();
  for (const { Test, Cls } of AvailLenClassMap) {
    if (Test(L)) return Cls;
  }
  return 'tl-other';
}

function IsQualityVisible(Quality) {
  const L = (Quality || '').toLowerCase();
  if (!L) return State.ActiveQualities.has('unavail');
  for (const { Key, Test } of QualityMap) {
    if (State.ActiveQualities.has(Key) && Test(L)) return true;
  }
  return false;
}

function IsPlayable(LinkString, Quality) {
  if (!LinkString) return false;
  const Q = (Quality || '').toLowerCase();
  if (Q.includes('unavail') || Q.includes('not avail')) return false;
  return LinkString.split(/[\s,]+/).some(U => U.includes(PillowsHost));
}

const AudioPlayer = {
  AudioElement: null,
  PlayerElement: null,
  Elements: {},

  Init() {
    this.AudioElement = document.getElementById('main-audio');
    this.PlayerElement = document.getElementById('global-player');
    if (!this.AudioElement || !this.PlayerElement) return;

    this.Elements = {
      PlayIcon: document.getElementById('player-play-icon'),
      PauseIcon: document.getElementById('player-pause-icon'),
      PlayPauseBtn: document.getElementById('player-play-btn'),
      CloseBtn: document.getElementById('player-close-btn'),
      CurrentTimeEl: document.getElementById('player-current'),
      DurationEl: document.getElementById('player-duration'),
      TrackNameEl: document.getElementById('player-track-name'),
      TrackCurrentEl: document.getElementById('player-track-current'),
      TrackLengthEl: document.getElementById('player-track-length'),
      ProgressFill: document.getElementById('player-fill'),
      VolFill: document.getElementById('player-vol-fill'),
      ScrubberEl: document.getElementById('player-scrubber'),
      VolumeSlider: document.getElementById('player-volume'),
    };

    this.BindAudioEvents();
    this.BindControls();
    this.BindSliders();
    this.BindMediaSession();
    this.SetVolume(80);
  },

  RegisterPlayBtn(Btn, ResolvedUrl) {
    if (!PlayBtnMap.has(ResolvedUrl)) PlayBtnMap.set(ResolvedUrl, new Set());
    PlayBtnMap.get(ResolvedUrl).add(Btn);
  },

  SyncPlayButtons() {
    const Audio = this.AudioElement;
    const Current = Audio.src ? ResolveUrl(Audio.src) : '';
    const Playing = !Audio.paused;
    for (const [Href, Btns] of PlayBtnMap) {
      const Label = (Href === Current && Playing) ? 'Pause' : 'Play';
      for (const Btn of Btns) Btn.textContent = Label;
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

  PlayOrToggle(ResolvedUrl, TrackName) {
    const Audio = this.AudioElement;
    if (this.CurrentResolvedSrc() === ResolvedUrl) {
      if (Audio.paused) this.SafePlay();
      else Audio.pause();
      return;
    }
    this.Elements.TrackNameEl.textContent = TrackName;
    this.SetMediaSessionTrack(TrackName);
    Audio.pause();
    Audio.removeAttribute('src');
    Audio.load();
    Audio.src = ResolvedUrl;
    this.PlayerElement.removeAttribute('hidden');
    this.SafePlay();
  },

  Close() {
    const { AudioElement: Audio, PlayerElement: PlayerEl } = this;
    Audio.pause();
    Audio.src = '';
    Audio.load();
    PlayerEl.setAttribute('hidden', '');
    if ('mediaSession' in navigator) navigator.mediaSession.metadata = null;
    this.SetPlayState(false);
    this.SetProgress(0);
    this.SetCurrentTime('0:00');
    this.SetDuration('0:00');
    this.SyncPlayButtons();
  },

  SetVolume(Pct) {
    const C = Clamp(Pct, 0, 100);
    const { VolFill, VolumeSlider } = this.Elements;
    VolFill.style.width = `${C}%`;
    this.AudioElement.volume = C / 100;
    VolumeSlider.setAttribute('aria-valuenow', Math.round(C));
  },

  SetPlayState(Playing) {
    const { PlayIcon, PauseIcon, PlayPauseBtn } = this.Elements;
    PlayIcon.style.display = Playing ? 'none' : '';
    PauseIcon.style.display = Playing ? '' : 'none';
    PlayPauseBtn.setAttribute('aria-label', Playing ? 'Pause' : 'Play');
  },

  SetProgress(Pct) {
    const C = Clamp(Pct, 0, 100);
    const { ProgressFill, ScrubberEl } = this.Elements;
    ProgressFill.style.width = `${C}%`;
    ScrubberEl.setAttribute('aria-valuenow', Math.round(C));
  },

  SetCurrentTime(T) {
    this.Elements.CurrentTimeEl.textContent = this.Elements.TrackCurrentEl.textContent = T;
  },

  SetDuration(T) {
    this.Elements.DurationEl.textContent = this.Elements.TrackLengthEl.textContent = T;
  },

  BindAudioEvents() {
    const { AudioElement: Audio, Elements: Els } = this;

    Audio.addEventListener('play', () => { this.SetPlayState(true); this.SyncPlayButtons(); });
    Audio.addEventListener('pause', () => { this.SetPlayState(false); this.SyncPlayButtons(); });
    Audio.addEventListener('ended', () => {
      this.SetPlayState(false);
      this.SetProgress(0);
      this.SetCurrentTime('0:00');
      this.SyncPlayButtons();
    });
    Audio.addEventListener('loadedmetadata', () => this.SetDuration(FormatTime(Audio.duration)));
    Audio.addEventListener('error', () => {
      this.SetPlayState(false);
      Els.TrackNameEl.textContent = 'Playback error, format not supported or unavailable';
    });
    Audio.addEventListener('timeupdate', () => {
      if (!Audio.duration) return;
      this.SetProgress((Audio.currentTime / Audio.duration) * 100);
      this.SetCurrentTime(FormatTime(Audio.currentTime));
      if ('mediaSession' in navigator && navigator.mediaSession.setPositionState) {
        navigator.mediaSession.setPositionState({
          duration: Audio.duration,
          playbackRate: Audio.playbackRate,
          position: Audio.currentTime,
        });
      }
    });
  },

  BindControls() {
    const { AudioElement: Audio, Elements: Els } = this;

    Els.PlayPauseBtn.addEventListener('click', () => {
      if (Audio.paused) this.SafePlay();
      else Audio.pause();
    });

    Els.CloseBtn.addEventListener('click', () => this.Close());
  },

  BindSliders() {
    const { AudioElement: Audio, Elements: Els } = this;
    const { ScrubberEl, VolumeSlider } = Els;

    const PctFromPointer = (Ev, El) => {
      const Rect = El.getBoundingClientRect();
      return Rect.width ? Clamp((Ev.clientX - Rect.left) / Rect.width, 0, 1) : 0;
    };
    const BindTouchSlider = (El, Handler) => {
      El.addEventListener('touchstart', Ev => Handler(Ev.touches[0]), { passive: true });
      El.addEventListener('touchmove', Ev => Handler(Ev.touches[0]), { passive: true });
    };

    let DraggingProgress = false;
    let DraggingVolume = false;

    ScrubberEl.addEventListener('mousedown', Ev => {
      DraggingProgress = true;
      if (Audio.duration) Audio.currentTime = PctFromPointer(Ev, ScrubberEl) * Audio.duration;
    });
    VolumeSlider.addEventListener('mousedown', Ev => {
      DraggingVolume = true;
      this.SetVolume(PctFromPointer(Ev, VolumeSlider) * 100);
    });
    window.addEventListener('mousemove', Ev => {
      if (DraggingProgress && Audio.duration) Audio.currentTime = PctFromPointer(Ev, ScrubberEl) * Audio.duration;
      if (DraggingVolume) this.SetVolume(PctFromPointer(Ev, VolumeSlider) * 100);
    });
    window.addEventListener('mouseup', () => { DraggingProgress = false; DraggingVolume = false; });

    BindTouchSlider(ScrubberEl, T => { if (Audio.duration) Audio.currentTime = PctFromPointer(T, ScrubberEl) * Audio.duration; });
    BindTouchSlider(VolumeSlider, T => this.SetVolume(PctFromPointer(T, VolumeSlider) * 100));

    ScrubberEl.addEventListener('keydown', Ev => {
      if (!Audio.duration) return;
      const Step = Audio.duration * 0.02;
      if (Ev.key === 'ArrowRight') { Ev.preventDefault(); Audio.currentTime = Math.min(Audio.duration, Audio.currentTime + Step); }
      if (Ev.key === 'ArrowLeft') { Ev.preventDefault(); Audio.currentTime = Math.max(0, Audio.currentTime - Step); }
    });
  },

  SetMediaSessionTrack(TrackName) {
    if (!('mediaSession' in navigator)) return;
    navigator.mediaSession.metadata = new MediaMetadata({
      title: TrackName,
      artist: 'Mistape',
    });
  },

  BindMediaSession() {
    if (!('mediaSession' in navigator)) return;
    const { AudioElement: Audio } = this;
    const Ms = navigator.mediaSession;
    Ms.setActionHandler('play', () => this.SafePlay());
    Ms.setActionHandler('pause', () => Audio.pause());
    Ms.setActionHandler('stop', () => { Audio.pause(); Audio.currentTime = 0; });
    Ms.setActionHandler('seekto', D => { if (D.seekTime !== undefined && Audio.duration) Audio.currentTime = D.seekTime; });
    Ms.setActionHandler('seekbackward', D => { Audio.currentTime = Math.max(0, Audio.currentTime - (D.seekOffset || 10)); });
    Ms.setActionHandler('seekforward', D => { Audio.currentTime = Math.min(Audio.duration || 0, Audio.currentTime + (D.seekOffset || 10)); });
  },
};

function CloseAllLinkDropdowns() {
  if (!State.HasOpenDropdown) return;
  document.querySelectorAll('.song-dropdown-menu.open').forEach(Menu => {
    Menu.classList.remove('open');
    Menu.style.position = '';
    Menu.style.top = '';
    Menu.style.left = '';
    const Btn = Menu.previousElementSibling;
    if (Btn) Btn.setAttribute('aria-expanded', 'false');
  });
  State.HasOpenDropdown = false;
}

function PositionDropdown(Menu, Btn) {
  if (!Menu || !Btn) return;

  const BtnRect = Btn.getBoundingClientRect();
  const Gap = 4;

  const PrevVis = Menu.style.visibility;
  Menu.style.visibility = 'hidden';
  Menu.style.position = 'fixed';
  Menu.style.top = '0';
  Menu.style.left = '0';
  Menu.style.right = 'auto';
  Menu.style.margin = '0';

  const MenuH = Menu.offsetHeight || 160;
  Menu.style.visibility = PrevVis;

  let Top = BtnRect.bottom + Gap;
  let Left = BtnRect.right - Menu.offsetWidth;
  if (Left < 4) Left = 4;
  if (Top + MenuH > window.innerHeight - 8) Top = BtnRect.top - MenuH - Gap;

  Menu.style.top = Top + 'px';
  Menu.style.left = Left + 'px';
}

function ToggleDropdown(Btn, Menu) {
  const IsOpen = Menu.classList.toggle('open');
  Btn.setAttribute('aria-expanded', String(IsOpen));
  if (IsOpen) {
    PositionDropdown(Menu, Btn);
  }
}

function CloseDropdown(Btn, Menu) {
  Menu.classList.remove('open');
  Btn.setAttribute('aria-expanded', 'false');
}

function CollapsePanel(Panel) {
  if (!OpenPanels.has(Panel)) return;
  Panel.classList.remove('open');
  OpenPanels.delete(Panel);
  const EraRow = Panel.previousElementSibling;
  if (EraRow) {
    EraRow.classList.remove('active');
    EraRow.setAttribute('aria-expanded', 'false');
  }
}

function CollapseAllEraPanels() {
  for (const Panel of OpenPanels) CollapsePanel(Panel);
}

function OpenPanel(Panel, EraRow) {
  Panel.classList.add('open');
  OpenPanels.add(Panel);
  EraRow.classList.add('active');
  EraRow.setAttribute('aria-expanded', 'true');
}

function BuildSongElement({ SongName, Quality, LinkString, Notes, TrackNumber, AvailLen, RecentEra, LeakDate }) {
  const SafeNotes = (Notes || '').trim();
  const HasNotes = SafeNotes !== '';

  const Links = LinkString
    ? LinkString.split(/[\s,]+/).map(U => U.trim()).filter(U => UrlPattern.test(U))
    : [];

  const AvailLower = (AvailLen || '').toLowerCase();
  const IsRumoredOrConf = AvailLower.includes('rumored') || AvailLower.includes('confirmed');
  const DisplayQuality = (Links.length > 0 || IsRumoredOrConf) ? Quality : 'Unavailable';
  const DisplayQualLow = (DisplayQuality || '').toLowerCase();
  const IsUnavailable = !DisplayQuality ||
    DisplayQualLow.includes('unavail') ||
    DisplayQualLow.includes('not avail');

  let PlayBtnHtml = '';
  let ResolvedDownload = '';
  let LinksHtml = '';

  const PillowsLink = Links.find(U => U.includes(PillowsHost));
  if (PillowsLink && !IsUnavailable) {
    const PathStart = PillowsLink.indexOf(PillowsHost) + PillowsHost.length;
    const FilePath = PillowsLink.slice(PathStart);
    ResolvedDownload = PillowsApi + FilePath;
    PlayBtnHtml = `<button type="button" class="song-play-btn" data-name="${EscapeHtml(SongName)}">Play</button>`;
  }

  if (Links.length > 1) {
    const Items = Links.map((Url, I) =>
      `<a class="song-dropdown-item" href="${EscapeHtml(Url)}" target="_blank" rel="noopener noreferrer">Link ${I + 1}</a>`
    ).join('');
    LinksHtml = `
      <div class="song-dropdown">
        <button type="button" class="song-dropdown-btn" aria-haspopup="true" aria-expanded="false">
          <span>Links</span>
          <svg class="dropdown-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true"><polyline points="6,9 12,15 18,9"/></svg>
        </button>
        <div class="song-dropdown-menu" role="menu">${Items}</div>
      </div>`;
  } else if (Links.length === 1) {
    LinksHtml = `<a class="song-link-btn" href="${EscapeHtml(Links[0])}" target="_blank" rel="noopener noreferrer">View</a>`;
  }

  const NoteToggleHtml = HasNotes
    ? `<div class="note-toggle" role="button" tabindex="0" aria-label="Show note"></div>`
    : '';

  const VersionMatch = VersionPattern.exec(SongName);
  const VersionPillHtml = VersionMatch
    ? `<div class="song-version-pill">${EscapeHtml(VersionMatch[1])}</div>`
    : '';
  const DisplayName = VersionMatch
    ? SongName.replace(VersionMatch[0], '').replace(/\s{2,}/g, ' ').trim()
    : SongName;

  let DatePillHtml = '';
  if (LeakDate) {
    const Parsed = new Date(LeakDate);
    if (isNaN(Parsed)) {
      DatePillHtml = `<div class="song-date-pill">${EscapeHtml(LeakDate)}</div>`;
    } else {
      const Dd = String(Parsed.getUTCDate()).padStart(2, '0');
      const Mm = String(Parsed.getUTCMonth() + 1).padStart(2, '0');
      const Yyyy = Parsed.getUTCFullYear();
      DatePillHtml = `<div class="song-date-pill">${Dd}/${Mm}/${Yyyy}</div>`;
    }
  }

  let TopRowHtml = '';
  if (RecentEra) {
    TopRowHtml = `<div class="song-top-row"><div class="song-era-pill">${EscapeHtml(RecentEra)}</div>${DatePillHtml}</div>`;
  }

  const PillsHtml =
    VersionPillHtml +
    (DisplayQuality ? `<div class="song-quality ${GetQualityClass(DisplayQuality)}">${EscapeHtml(DisplayQuality)}</div>` : '') +
    (AvailLen ? `<div class="song-type ${GetAvailableLengthClass(AvailLen)}">${EscapeHtml(AvailLen)}</div>` : '');

  const SongEl = document.createElement('div');
  SongEl.className = 'song-item';
  SongEl.setAttribute('role', 'listitem');
  SongEl.innerHTML = `
    <div class="song-num">${TrackNumber}</div>
    <div class="song-body">
      ${TopRowHtml}
      <div class="song-name" title="${EscapeHtml(SongName)}">${EscapeHtml(DisplayName)}</div>
      <div class="song-pills">${PillsHtml}</div>
    </div>
    <div class="song-btns">${PlayBtnHtml}${LinksHtml}${NoteToggleHtml}</div>
  `;

  if (Links.length > 1) {
    const DropBtn = SongEl.querySelector('.song-dropdown-btn');
    const DropMenu = SongEl.querySelector('.song-dropdown-menu');
    DropBtn.addEventListener('click', Ev => {
      Ev.stopPropagation();
      const WasOpen = DropMenu.classList.contains('open');
      CloseAllLinkDropdowns();
      if (!WasOpen) {
        DropMenu.classList.add('open');
        DropBtn.setAttribute('aria-expanded', 'true');
        State.HasOpenDropdown = true;
        PositionDropdown(DropMenu, DropBtn);
      }
    });
  }

  const PlayBtn = SongEl.querySelector('.song-play-btn');
  if (PlayBtn && ResolvedDownload) {
    AudioPlayer.RegisterPlayBtn(PlayBtn, ResolvedDownload);
    PlayBtn.addEventListener('click', Ev => {
      Ev.stopPropagation();
      CloseAllLinkDropdowns();
      AudioPlayer.PlayOrToggle(ResolvedDownload, PlayBtn.dataset.name);
    });
  }

  if (HasNotes) {
    const NoteEl = document.createElement('div');
    NoteEl.className = 'song-note';
    NoteEl.textContent = SafeNotes;
    const NoteToggle = SongEl.querySelector('.note-toggle');
    const ToggleNote = () => {
      const Expanded = SongEl.classList.toggle('expanded');
      NoteToggle.setAttribute('aria-label', Expanded ? 'Hide note' : 'Show note');
    };
    NoteToggle.addEventListener('click', Ev => { Ev.stopPropagation(); ToggleNote(); });
    NoteToggle.addEventListener('keydown', Ev => {
      if (Ev.key === 'Enter' || Ev.key === ' ') { Ev.preventDefault(); ToggleNote(); }
    });
    return [SongEl, NoteEl];
  }

  return [SongEl];
}

function RenderSongs(Songs, Container) {
  const Frag = document.createDocumentFragment();
  Songs.forEach(([Name, Quality, Link, Notes, LeakDate, AvailLen, RecentEra], Idx) => {
    BuildSongElement({
      SongName: Name,
      Quality,
      LinkString: Link,
      Notes,
      TrackNumber: Idx + 1,
      AvailLen: AvailLen || '',
      RecentEra: RecentEra || '',
      LeakDate: LeakDate || '',
    }).forEach(Node => Frag.appendChild(Node));
  });
  Container.appendChild(Frag);
  AudioPlayer.SyncPlayButtons();
}

function BuildEraElement(Era, Songs) {
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

  const EraDesc = State.EraDescriptions[NormaliseKey(Era)] || '';
  if (EraDesc) {
    const DescBlock = document.createElement('div');
    DescBlock.className = 'era-desc-block';
    DescBlock.textContent = EraDesc;
    SongsPanel.appendChild(DescBlock);
  }

  const SongsInner = document.createElement('div');
  SongsInner.className = 'songs-inner';
  SongsInner.setAttribute('role', 'list');
  SongsInner.setAttribute('aria-label', `${Era} songs`);
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
        RenderSongs(Songs, SongsInner);
      }
    }
  };

  EraRow.addEventListener('click', Toggle);
  EraRow.addEventListener('keydown', Ev => {
    if (Ev.key === 'Enter' || Ev.key === ' ') { Ev.preventDefault(); Toggle(); }
  });

  EraWrap.appendChild(EraRow);
  EraWrap.appendChild(SongsPanel);
  return EraWrap;
}

function BuildRecentEras(FilterLower) {
  const Flat = [];
  for (const [Era, Songs] of Object.entries(State.VaultData)) {
    const EraLow = Era.toLowerCase();
    for (const S of Songs) {
      const [, Q] = S;
      if (!IsQualityVisible(Q)) continue;
      if (State.ShowPlayableOnly && !IsPlayable(S[2], Q)) continue;
      Flat.push({ Era, EraLow, NameLow: S[0].toLowerCase(), Name: S[0], Quality: Q, Link: S[2], Notes: S[3], LeakDate: S[4] || '', AvailLen: S[5] || '' });
    }
  }
  Flat.sort((A, B) => ParseDateToTimestamp(B.LeakDate) - ParseDateToTimestamp(A.LeakDate));

  const Limit = 100;
  const Pool = Flat.slice(0, Limit);
  const Filtered = FilterLower
    ? Pool.filter(S => S.NameLow.includes(FilterLower))
    : Pool;

  if (!Filtered.length) return {};
  return {
    'Recent Leaks': Filtered.map(S => [S.Name, S.Quality, S.Link, S.Notes, S.LeakDate, S.AvailLen, S.Era]),
  };
}

function BuildVisibleEras(FilterLower) {
  if (State.CurrentTab === 'recent') return BuildRecentEras(FilterLower);

  const Markers = TabMarkers[State.CurrentTab] || null;
  const Result = {};
  for (const [Era, Songs] of Object.entries(State.VaultData)) {
    const EraLow = FilterLower ? Era.toLowerCase() : '';
    let Matched = Songs.filter(([, Q]) => IsQualityVisible(Q));
    if (State.ShowPlayableOnly) Matched = Matched.filter(([, Q, Link]) => IsPlayable(Link, Q));
    if (Markers) Matched = Matched.filter(([N]) => Markers.some(M => N.includes(M)));
    if (FilterLower) Matched = Matched.filter(([N]) => N.toLowerCase().includes(FilterLower));
    if (Matched.length) Result[Era] = Matched;
  }
  return Result;
}

function UpdateNavStats(Total) {
  document.getElementById('nav-songs').textContent = Total.toLocaleString();
}

function RenderEras(SearchFilter) {
  const EraListEl = document.getElementById('era-list');
  if (!EraListEl || !State.VaultData) return;

  const FilterLower = (SearchFilter || '').trim().toLowerCase();
  const Visible = BuildVisibleEras(FilterLower);
  const Keys = Object.keys(Visible);
  const Total = Keys.reduce((Sum, K) => Sum + Visible[K].length, 0);

  CollapseAllEraPanels();
  CloseAllLinkDropdowns();
  AudioPlayer.ClearPlayButtons();
  UpdateNavStats(Total);

  const Frag = document.createDocumentFragment();
  if (!Keys.length) {
    const Empty = document.createElement('div');
    Empty.className = 'no-results';
    Empty.textContent = 'No results found.';
    Frag.appendChild(Empty);
  } else if (State.CurrentTab === 'recent') {
    for (const Era of Keys) {
      const Wrap = document.createElement('div');
      Wrap.className = 'songs-flat';
      Wrap.setAttribute('role', 'list');
      Wrap.setAttribute('aria-label', 'Recent songs');
      RenderSongs(Visible[Era], Wrap);
      Frag.appendChild(Wrap);
    }
  } else {
    for (const Era of Keys) {
      Frag.appendChild(BuildEraElement(Era, Visible[Era]));
    }
  }
  EraListEl.replaceChildren(Frag);
  OpenPanels.clear();
}

const VaultLoader = {
  Worker: new Worker('vault_worker.js'),
  LoadId: 0,

  Load(StatusEl = null) {
    const LoadId = ++this.LoadId;
    State.IsLoading = true;

    const ShowError = Text => {
      let Target = StatusEl;
      if (!Target) {
        Target = document.createElement('div');
        document.getElementById('era-list').replaceChildren(Target);
      }
      Target.className = 'error-msg';
      Target.textContent = Text;
    };

    this.Worker.postMessage({ type: 'ABORT' });
    this.Worker.postMessage({ type: 'LOAD', sheetId: State.PrimarySheetId });

    this.Worker.onmessage = ({ data }) => {
      if (LoadId !== this.LoadId) return;

      if (data.type === 'SUCCESS') {
        State.IsLoading = false;
        State.VaultData = data.EraMap;
        State.EraDescriptions = data.EraDescs;
        RenderEras('');
        return;
      }

      if (data.type === 'ERROR') {
        State.IsLoading = false;
        const ErrText =
          data.reason === 'timeout' ? 'Request timed out, check your connection and try reloading.'
          : data.reason === 'http' ? `Failed to load sheet (${data.message}), make sure it is publicly shared.`
          : 'Failed to load data, check your connection or sheet permissions.';
        ShowError(ErrText);
      }
    };

    this.Worker.onerror = () => {
      if (LoadId !== this.LoadId) return;
      State.IsLoading = false;
      ShowError('An unexpected error occurred while loading data.');
    };
  },

  Abort() {
    this.Worker.postMessage({ type: 'ABORT' });
  },
};

document.addEventListener('DOMContentLoaded', () => {
  const SearchBox = document.getElementById('search-box');
  const FilterBtn = document.getElementById('quality-filter-btn');
  const FilterMenu = document.getElementById('quality-filter-menu');
  const NavTabBtn = document.getElementById('nav-tab-btn');
  const NavTabMenu = document.getElementById('nav-tab-menu');
  const NavBtnLabel = document.getElementById('nav-btn-text');

  AudioPlayer.Init();

  NavTabBtn.addEventListener('click', Ev => {
    Ev.stopPropagation();
    ToggleDropdown(NavTabBtn, NavTabMenu);
  });
  document.querySelectorAll('.nav-dropdown-item').forEach(Item => {
    Item.addEventListener('click', () => {
      CloseDropdown(NavTabBtn, NavTabMenu);
      if (Item.dataset.tab === State.CurrentTab) return;
      State.CurrentTab = Item.dataset.tab;
      NavBtnLabel.textContent = Item.textContent.trim();
      document.querySelectorAll('.nav-dropdown-item').forEach(N => N.classList.toggle('active', N === Item));
      if (State.VaultData) RenderEras(SearchBox.value);
    });
  });

  FilterBtn.addEventListener('click', Ev => {
    Ev.stopPropagation();
    ToggleDropdown(FilterBtn, FilterMenu);
  });
  FilterMenu.addEventListener('click', Ev => {
    const Item = Ev.target.closest('.filter-item');
    if (!Item) return;
    const Key = Item.dataset.quality;
    if (State.ActiveQualities.has(Key)) {
      if (State.ActiveQualities.size === 1) return;
      State.ActiveQualities.delete(Key);
      Item.classList.remove('active');
      Item.setAttribute('aria-checked', 'false');
    } else {
      State.ActiveQualities.add(Key);
      Item.classList.add('active');
      Item.setAttribute('aria-checked', 'true');
    }
    if (State.VaultData) RenderEras(SearchBox.value);
  });

  SearchBox.addEventListener('input', Ev => {
    clearTimeout(State.SearchDebounceId);
    State.SearchDebounceId = setTimeout(() => {
      if (State.VaultData) RenderEras(Ev.target.value);
    }, 200);
  });

  document.addEventListener('keydown', Ev => {
    if (Ev.key === '/' && document.activeElement !== SearchBox) {
      Ev.preventDefault();
      SearchBox.focus();
    }
    if (Ev.key === 'Escape') {
      SearchBox.blur();
      CloseDropdown(FilterBtn, FilterMenu);
      CloseDropdown(NavTabBtn, NavTabMenu);
      CloseAllLinkDropdowns();
    }
  });

  document.addEventListener('click', Ev => {
    if (!FilterMenu.contains(Ev.target) && Ev.target !== FilterBtn) CloseDropdown(FilterBtn, FilterMenu);
    if (!NavTabMenu.contains(Ev.target) && !NavTabBtn.contains(Ev.target)) CloseDropdown(NavTabBtn, NavTabMenu);
    if (!Ev.target.closest('.song-dropdown')) CloseAllLinkDropdowns();
  });

  window.addEventListener('scroll', CloseAllLinkDropdowns, { passive: true });
  window.addEventListener('resize', CloseAllLinkDropdowns);

  const SettingsBtn = document.getElementById('settings-btn');
  const Modal = document.getElementById('settings-modal');
  const CloseBtn = document.getElementById('settings-close-btn');
  const PlayableToggle = document.getElementById('playable-only-toggle');

  const SyncToggleUi = () => {
    PlayableToggle?.setAttribute('aria-checked', String(State.ShowPlayableOnly));
  };

  PlayableToggle?.addEventListener('click', () => {
    State.ShowPlayableOnly = PlayableToggle.getAttribute('aria-checked') !== 'true';
    SyncToggleUi();
    if (State.VaultData) {
      RenderEras(SearchBox.value);
    }
  });

  const OpenModal = () => {
    SyncToggleUi();
    Modal.removeAttribute('hidden');
  };
  const CloseModal = () => { Modal.setAttribute('hidden', ''); };

  SettingsBtn.addEventListener('click', Ev => { Ev.stopPropagation(); OpenModal(); });
  CloseBtn.addEventListener('click', CloseModal);
  Modal.addEventListener('click', Ev => { if (Ev.target === Modal) CloseModal(); });
  document.addEventListener('keydown', Ev => {
    if (Ev.key === 'Escape' && !Modal.hasAttribute('hidden')) CloseModal();
  });

  VaultLoader.Load();
});