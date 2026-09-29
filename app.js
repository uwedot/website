'use strict';

const DefaultSheetId = '1wQ0WC0U9q10fLWpy9CO8YR128eE8msGXqtZI8_cNyTA';
const CacheKey = 'mistape:vault:v1';
const RecentLimit = 100;
const PillowsHost = 'pillows.su/f/';
const PillowsApi = 'https://api.pillows.su/api/get/';
const UrlPattern = /^https?:/i;
const VersionPattern = /[[(](v(?:ersion)?\s*\d+)[\])]/i;
const UnavailRe = /unavail|not avail/i;
const ButtonLike = '.nav-dropdown-item, .filter-item, .era-row, .note-toggle';
const ArrowDir = { ArrowRight: 1, ArrowUp: 1, ArrowLeft: -1, ArrowDown: -1 };
const LoadingHtml = '<div class="loading-msg">Loading songs…</div>';
const LinksBtnHtml = '<button type="button" class="song-dropdown-btn" aria-haspopup="true" aria-expanded="false"><span>Links</span><svg class="dropdown-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true"><polyline points="6,9 12,15 18,9"/></svg></button>';

const TabMarkers = {
  grails: ['⭐', '✨'],
};

const QualityMap = [
  { Key: 'lossless', Cls: 'q-lossless', Re: /lossless/i },
  { Key: 'high', Cls: 'q-high', Re: /high/i },
  { Key: 'cd', Cls: 'q-cd', Re: /cd/i },
  { Key: 'rec', Cls: 'q-rec', Re: /record/i },
  { Key: 'low', Cls: 'q-low', Re: /low/i },
  { Key: 'unavail', Cls: null, Re: UnavailRe },
];

const AvailLenClasses = [
  [/\bog\b/i, 'tl-og'],
  [/lossless/i, 'tl-other'],
  [/stem/i, 'tl-stem'],
  [/full/i, 'tl-full'],
  [/tagged/i, 'tl-tagged'],
  [/partial/i, 'tl-partial'],
  [/snippet/i, 'tl-snippet'],
  [/unavail/i, 'tl-unavail'],
  [/confirmed/i, 'tl-confirmed'],
  [/rumored/i, 'tl-rumored'],
  [/vox/i, 'tl-vox'],
];

const ById = Id => document.getElementById(Id);
const EraList = ById('era-list');
const NavSongs = ById('nav-songs');
const SearchBox = ById('search-box');
const NavTabBtn = ById('nav-tab-btn');
const NavTabMenu = ById('nav-tab-menu');
const FilterBtn = ById('quality-filter-btn');
const FilterMenu = ById('quality-filter-menu');
const Menus = [[NavTabBtn, NavTabMenu], [FilterBtn, FilterMenu]];

const Ms = navigator.mediaSession;
const ReducedMotion = matchMedia('(prefers-reduced-motion: reduce)');

const State = {
  VaultData: null,
  EraDescriptions: {},
  CurrentTab: 'all',
  ActiveQualities: new Set(QualityMap.map(Q => Q.Key)),
  IsLoading: false,
};

let ShownEras = {};
let OpenEra = null;
let OpenLinkMenu = null;

const HtmlEscapes = { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;' };
const EscapeHtml = Str => String(Str).replace(/[&<>"]/g, C => HtmlEscapes[C]);
const Div = (Cls, Text) => `<div class="${Cls}">${EscapeHtml(Text)}</div>`;
const Anchor = (Cls, Url, Text) =>
  `<a class="${Cls}" href="${EscapeHtml(Url)}" target="_blank" rel="noopener noreferrer">${Text}</a>`;

const Clamp = (V, Lo, Hi) => Math.max(Lo, Math.min(Hi, V));
const NormaliseKey = S => S.toLowerCase().replace(/\s+/g, ' ').trim();

function FormatTime(Seconds) {
  if (!isFinite(Seconds) || Seconds < 0) return '0:00';
  const S = Math.floor(Seconds);
  return `${Math.floor(S / 60)}:${String(S % 60).padStart(2, '0')}`;
}

const TimestampCache = new Map();
function LeakTimestamp(DateStr) {
  let Ts = TimestampCache.get(DateStr);
  if (Ts === undefined) {
    Ts = Date.parse(DateStr);
    if (isNaN(Ts)) {
      const Year = DateStr.match(/\b(?:19|20)\d{2}\b/);
      Ts = Year ? new Date(Year[0], 0, 1).getTime() : 0;
    }
    TimestampCache.set(DateStr, Ts);
  }
  return Ts;
}

function FormatLeakDate(Str) {
  const D = new Date(Str);
  if (isNaN(D)) return Str;
  // Date-only ISO strings parse as UTC, everything else as local time.
  const Utc = /^\d{4}-\d{2}-\d{2}$/.test(Str.trim());
  const [Day, Month, Year] = Utc
    ? [D.getUTCDate(), D.getUTCMonth(), D.getUTCFullYear()]
    : [D.getDate(), D.getMonth(), D.getFullYear()];
  return `${String(Day).padStart(2, '0')}/${String(Month + 1).padStart(2, '0')}/${Year}`;
}

const GetQualityClass = Quality =>
  QualityMap.find(({ Cls, Re }) => Cls && Re.test(Quality))?.Cls ?? 'q-other';

const GetAvailableLengthClass = AvailLen =>
  AvailLenClasses.find(([Re]) => Re.test(AvailLen))?.[1] ?? 'tl-other';

const QualityVisCache = new Map();
function IsQualityVisible(Quality) {
  let Vis = QualityVisCache.get(Quality);
  if (Vis === undefined) {
    const Hits = QualityMap.filter(({ Re }) => Re.test(Quality));
    Vis = Hits.length
      ? Hits.some(({ Key }) => State.ActiveQualities.has(Key))
      : State.ActiveQualities.has('unavail');
    QualityVisCache.set(Quality, Vis);
  }
  return Vis;
}

const AudioPlayer = {
  HasError: false,

  Init() {
    const Audio = (this.Audio = ById('main-audio'));
    this.Player = ById('global-player');
    const El = (this.El = {
      PlayIcon: ById('player-play-icon'),
      PauseIcon: ById('player-pause-icon'),
      PlayPauseBtn: ById('player-play-btn'),
      CurrentTime: ById('player-current'),
      Duration: ById('player-duration'),
      TrackName: ById('player-track-name'),
      TrackCurrent: ById('player-track-current'),
      TrackLength: ById('player-track-length'),
      ProgressFill: ById('player-fill'),
      VolFill: ById('player-vol-fill'),
      Scrubber: ById('player-scrubber'),
      Volume: ById('player-volume'),
    });

    for (const Type of ['play', 'pause']) Audio.addEventListener(Type, () => this.Sync());
    Audio.addEventListener('ended', () => {
      this.SetProgress(0);
      this.SetCurrentTime('0:00');
      this.Sync();
    });
    Audio.addEventListener('loadedmetadata', () => this.SetDuration(FormatTime(Audio.duration)));
    Audio.addEventListener('error', () => {
      if (!Audio.getAttribute('src')) return;
      this.HasError = true;
      this.Sync();
      El.TrackName.textContent = 'Can\'t play this file. The format may be unsupported or the link is dead.';
    });
    Audio.addEventListener('timeupdate', () => {
      const { currentTime, duration, playbackRate } = Audio;
      if (!Number.isFinite(duration) || !duration) return;
      this.SetProgress((currentTime / duration) * 100);
      this.SetCurrentTime(FormatTime(currentTime));
      try {
        Ms?.setPositionState({ duration, playbackRate: playbackRate || 1, position: Math.min(currentTime, duration) });
      } catch {}
    });

    El.PlayPauseBtn.addEventListener('click', () => this.Toggle());
    ById('player-close-btn').addEventListener('click', () => this.Close());
    this.BindSliders();
    this.BindMediaSession();
    this.SetVolume(80);
  },

  Play() {
    this.Audio.play().catch(() => {});
  },

  Toggle() {
    if (this.Audio.paused) this.Play();
    else this.Audio.pause();
  },

  Unload() {
    const { Audio } = this;
    Audio.pause();
    Audio.removeAttribute('src');
    Audio.load();
    this.HasError = false;
  },

  PlayOrToggle(Url, Name) {
    if (this.Audio.src === Url && !this.HasError) {
      this.Toggle();
      return;
    }
    this.Unload();
    this.El.TrackName.textContent = Name;
    if (Ms) Ms.metadata = new MediaMetadata({ title: Name, artist: 'Mistape' });
    this.Audio.src = Url;
    this.Player.hidden = false;
    this.Play();
  },

  Close() {
    this.Unload();
    this.Player.hidden = true;
    if (Ms) Ms.metadata = null;
    this.SetProgress(0);
    this.SetCurrentTime('0:00');
    this.SetDuration('0:00');
    this.Sync();
  },

  // Syncs the player icon and every rendered song Play/Pause button with the audio element.
  Sync() {
    const { src, paused } = this.Audio;
    const Playing = !paused && !this.HasError;
    const { PlayIcon, PauseIcon, PlayPauseBtn } = this.El;
    PlayIcon.style.display = Playing ? 'none' : '';
    PauseIcon.style.display = Playing ? '' : 'none';
    PlayPauseBtn.setAttribute('aria-label', Playing ? 'Pause' : 'Play');
    for (const Btn of EraList.querySelectorAll('.song-play-btn')) {
      Btn.textContent = Playing && Btn.dataset.src === src ? 'Pause' : 'Play';
    }
  },

  SetVolume(Pct) {
    const C = Clamp(Pct, 0, 100);
    this.El.VolFill.style.width = `${C}%`;
    this.Audio.volume = C / 100;
    this.El.Volume.setAttribute('aria-valuenow', Math.round(C));
  },

  SetProgress(Pct) {
    const C = Clamp(Pct, 0, 100);
    this.El.ProgressFill.style.width = `${C}%`;
    this.El.Scrubber.setAttribute('aria-valuenow', Math.round(C));
  },

  SetCurrentTime(T) {
    this.El.CurrentTime.textContent = this.El.TrackCurrent.textContent = T;
  },

  SetDuration(T) {
    this.El.Duration.textContent = this.El.TrackLength.textContent = T;
  },

  BindSliders() {
    const { Audio, El } = this;
    const Dur = () => (Number.isFinite(Audio.duration) ? Audio.duration : 0);
    const Slider = (Target, Seek, Step) => {
      const Frac = Ev => {
        const R = Target.getBoundingClientRect();
        return R.width ? Clamp((Ev.clientX - R.left) / R.width, 0, 1) : 0;
      };
      Target.addEventListener('pointerdown', Ev => {
        if (Ev.button > 0) return;
        Target.setPointerCapture(Ev.pointerId);
        Seek(Frac(Ev));
      });
      Target.addEventListener('pointermove', Ev => {
        if (Target.hasPointerCapture(Ev.pointerId)) Seek(Frac(Ev));
      });
      Target.addEventListener('keydown', Ev => {
        const Dir = ArrowDir[Ev.key];
        if (!Dir) return;
        Ev.preventDefault();
        Step(Dir);
      });
    };

    Slider(
      El.Scrubber,
      F => { if (Dur()) Audio.currentTime = F * Dur(); },
      D => { if (Dur()) Audio.currentTime = Clamp(Audio.currentTime + D * Dur() * 0.02, 0, Dur()); },
    );
    Slider(El.Volume, F => this.SetVolume(F * 100), D => this.SetVolume(Audio.volume * 100 + D * 5));
  },

  BindMediaSession() {
    if (!Ms) return;
    const { Audio } = this;
    const Handlers = {
      play: () => this.Play(),
      pause: () => Audio.pause(),
      stop: () => { Audio.pause(); Audio.currentTime = 0; },
      seekto: D => { if (D.seekTime !== undefined && Audio.duration) Audio.currentTime = D.seekTime; },
      seekbackward: D => { Audio.currentTime = Math.max(0, Audio.currentTime - (D.seekOffset || 10)); },
      seekforward: D => { Audio.currentTime = Math.min(Audio.duration || 0, Audio.currentTime + (D.seekOffset || 10)); },
    };
    for (const [Action, Handler] of Object.entries(Handlers)) {
      try { Ms.setActionHandler(Action, Handler); } catch {}
    }
  },
};

function SetDropdown(Btn, Menu, Open) {
  Menu.classList.toggle('open', Open);
  Btn.setAttribute('aria-expanded', String(Open));
}

function CloseLinkMenu() {
  if (!OpenLinkMenu) return;
  const Menu = OpenLinkMenu;
  OpenLinkMenu = null;
  SetDropdown(Menu.previousElementSibling, Menu, false);
  Menu.removeAttribute('style');
}

function PositionDropdown(Menu, Btn) {
  const Rect = Btn.getBoundingClientRect();
  const Gap = 4;
  Object.assign(Menu.style, { position: 'fixed', top: '0', left: '0', right: 'auto', margin: '0', visibility: 'hidden' });
  const { offsetWidth: W, offsetHeight: H } = Menu;
  const Top = Rect.bottom + Gap + H > innerHeight - 8 ? Rect.top - H - Gap : Rect.bottom + Gap;
  Menu.style.top = `${Math.max(4, Top)}px`;
  Menu.style.left = `${Clamp(Rect.right - W, 4, Math.max(4, innerWidth - W - 4))}px`;
  Menu.style.visibility = '';
}

function ToggleLinkMenu(Btn) {
  const Menu = Btn.nextElementSibling;
  const WasOpen = Menu === OpenLinkMenu;
  CloseLinkMenu();
  if (WasOpen) return;
  OpenLinkMenu = Menu;
  SetDropdown(Btn, Menu, true);
  PositionDropdown(Menu, Btn);
}

function ToggleNote(Toggle) {
  const Expanded = Toggle.closest('.song-item').classList.toggle('expanded');
  Toggle.setAttribute('aria-label', Expanded ? 'Hide note' : 'Show note');
}

function SetEra(Row, Open) {
  Row.classList.toggle('active', Open);
  Row.setAttribute('aria-expanded', String(Open));
  Row.nextElementSibling.classList.toggle('open', Open);
}

function ToggleEra(Row) {
  const Opening = Row !== OpenEra;
  if (OpenEra) SetEra(OpenEra, false);
  OpenEra = Opening ? Row : null;
  if (!Opening) return;

  SetEra(Row, true);
  const Inner = Row.nextElementSibling.querySelector('.songs-inner');
  if (!Inner.firstElementChild) {
    Inner.innerHTML = SongsHtml(ShownEras[Row.dataset.era]);
    AudioPlayer.Sync();
  }
  Row.scrollIntoView({ behavior: ReducedMotion.matches ? 'auto' : 'smooth', block: 'nearest' });
}

function SongHtml([Name, Quality, LinkString, Notes, LeakDate, AvailLen, RecentEra], Num) {
  const Links = LinkString.split(/[\s,]+/).filter(U => UrlPattern.test(U));
  const DisplayQuality = (Links.length || /rumored|confirmed/i.test(AvailLen)) ? Quality : 'Unavailable';

  const PillowsLink = Links.find(U => U.includes(PillowsHost));
  const PlayUrl = PillowsLink && Quality && !UnavailRe.test(Quality)
    ? new URL(PillowsApi + PillowsLink.slice(PillowsLink.indexOf(PillowsHost) + PillowsHost.length)).href
    : '';
  const PlayBtn = PlayUrl
    ? `<button type="button" class="song-play-btn" data-name="${EscapeHtml(Name)}" data-src="${EscapeHtml(PlayUrl)}">Play</button>`
    : '';

  let LinksHtml = '';
  if (Links.length === 1) {
    LinksHtml = Anchor('song-link-btn', Links[0], 'View');
  } else if (Links.length > 1) {
    const Items = Links.map((Url, I) => Anchor('song-dropdown-item', Url, `Link ${I + 1}`)).join('');
    LinksHtml = `<div class="song-dropdown">${LinksBtnHtml}<div class="song-dropdown-menu" role="menu">${Items}</div></div>`;
  }

  const Version = VersionPattern.exec(Name);
  const DisplayName = Version ? Name.replace(Version[0], '').replace(/\s{2,}/g, ' ').trim() : Name;

  const TopRow = RecentEra
    ? `<div class="song-top-row">${Div('song-era-pill', RecentEra)}${LeakDate ? Div('song-date-pill', FormatLeakDate(LeakDate)) : ''}</div>`
    : '';
  const Pills =
    (Version ? Div('song-version-pill', Version[1]) : '') +
    (DisplayQuality ? Div(`song-quality ${GetQualityClass(DisplayQuality)}`, DisplayQuality) : '') +
    (AvailLen ? Div(`song-type ${GetAvailableLengthClass(AvailLen)}`, AvailLen) : '');
  const NoteToggle = Notes ? '<div class="note-toggle" role="button" tabindex="0" aria-label="Show note"></div>' : '';

  return `<div class="song-item" role="listitem">${Div('song-num', Num)}<div class="song-body">${TopRow}<div class="song-name" title="${EscapeHtml(Name)}">${EscapeHtml(DisplayName)}</div><div class="song-pills">${Pills}</div></div><div class="song-btns">${PlayBtn}${LinksHtml}${NoteToggle}</div></div>${Notes ? Div('song-note', Notes) : ''}`;
}

const SongsHtml = Songs => Songs.map((Song, I) => SongHtml(Song, I + 1)).join('');

function EraHtml(Era, Songs) {
  const Desc = State.EraDescriptions[NormaliseKey(Era)];
  return `<div class="era-wrap" role="listitem"><div class="era-row" role="button" tabindex="0" aria-expanded="false" data-era="${EscapeHtml(Era)}">${Div('era-row-name', Era)}<div class="era-row-right">${Div('era-pill', Songs.length)}<svg class="era-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true"><polyline points="6,9 12,15 18,9"/></svg></div></div><div class="songs-panel">${Desc ? Div('era-desc-block', Desc) : ''}<div class="songs-inner" role="list" aria-label="${EscapeHtml(Era)} songs"></div></div></div>`;
}

function BuildVisibleEras(Filter) {
  const Listed = ([, Quality]) => IsQualityVisible(Quality);
  const Named = ([Name]) => !Filter || Name.toLowerCase().includes(Filter);
  const Entries = Object.entries(State.VaultData);

  if (State.CurrentTab === 'recent') {
    // The newest RecentLimit songs are picked first; the search then narrows that list.
    const Recent = Entries
      .flatMap(([Era, Songs]) => Songs.filter(Listed).map(Song => ({ Era, Song, Ts: LeakTimestamp(Song[4]) })))
      .sort((A, B) => B.Ts - A.Ts)
      .slice(0, RecentLimit)
      .map(({ Era, Song }) => [...Song.slice(0, 6), Era])
      .filter(Named);
    return Recent.length ? { 'Recent Leaks': Recent } : {};
  }

  const Markers = TabMarkers[State.CurrentTab];
  const Result = {};
  for (const [Era, Songs] of Entries) {
    const Matched = Songs.filter(S => Listed(S) && Named(S) && (!Markers || Markers.some(M => S[0].includes(M))));
    if (Matched.length) Result[Era] = Matched;
  }
  return Result;
}

function RenderEras() {
  if (!State.VaultData) return;
  ShownEras = BuildVisibleEras(SearchBox.value.trim().toLowerCase());
  const Eras = Object.entries(ShownEras);
  OpenEra = OpenLinkMenu = null;
  NavSongs.textContent = Eras.reduce((Sum, [, Songs]) => Sum + Songs.length, 0).toLocaleString();

  if (!Eras.length) {
    EraList.innerHTML = '<div class="no-results">No songs match your search or filters.</div>';
  } else if (State.CurrentTab === 'recent') {
    EraList.innerHTML = Eras
      .map(([, Songs]) => `<div class="songs-flat" role="list" aria-label="Recent songs">${SongsHtml(Songs)}</div>`)
      .join('');
    AudioPlayer.Sync();
  } else {
    EraList.innerHTML = Eras.map(([Era, Songs]) => EraHtml(Era, Songs)).join('');
  }
}

const LoadErrorText = ({ reason, message }) => ({
  timeout: 'Request timed out. Check your connection and try again.',
  http: `Couldn\'t load the sheet (${message}). Make sure it is publicly shared.`,
  empty: 'The sheet loaded, but it has no songs.',
}[reason] ?? 'Couldn\'t load songs. Check your connection or the sheet\'s sharing settings.');

const VaultLoader = {
  CachedJson: null,

  Apply({ EraMap, EraDescs = {} }) {
    State.VaultData = EraMap;
    State.EraDescriptions = EraDescs;
    RenderEras();
  },

  ReadCache() {
    try {
      const Json = localStorage.getItem(CacheKey);
      const Data = Json && JSON.parse(Json);
      if (!Data?.EraMap) return;
      this.Apply(Data);
      this.CachedJson = Json;
    } catch {}
  },

  Fail(Text) {
    State.IsLoading = false;
    if (State.VaultData) return;
    EraList.innerHTML = `<div class="error-msg"><span>${EscapeHtml(Text)} </span><button type="button" class="retry-btn">Retry</button></div>`;
  },

  Load() {
    if (State.IsLoading) return;
    State.IsLoading = true;
    if (!State.VaultData) EraList.innerHTML = LoadingHtml;

    let W;
    try { W = new Worker('vault_worker.js'); } catch { this.Fail('Could not start the data loader in this browser.'); return; }

    W.onmessage = ({ data }) => {
      W.terminate();
      if (data.type !== 'SUCCESS') { this.Fail(LoadErrorText(data)); return; }
      State.IsLoading = false;
      if (data.json === this.CachedJson) return;
      this.Apply(JSON.parse(data.json));
      this.CachedJson = data.json;
      try { localStorage.setItem(CacheKey, data.json); } catch {}
    };
    W.onerror = Ev => {
      Ev.preventDefault();
      W.terminate();
      this.Fail('An unexpected error occurred while loading data.');
    };
    W.postMessage(DefaultSheetId);
  },
};

AudioPlayer.Init();

for (const El of document.querySelectorAll('.nav-dropdown-item, .filter-item')) El.tabIndex = 0;

EraList.addEventListener('click', ({ target }) => {
  const El = target.closest('.era-row, .song-play-btn, .song-dropdown-btn, .note-toggle, .retry-btn');
  if (!El) return;
  if (El.classList.contains('era-row')) ToggleEra(El);
  else if (El.classList.contains('song-play-btn')) AudioPlayer.PlayOrToggle(El.dataset.src, El.dataset.name);
  else if (El.classList.contains('song-dropdown-btn')) ToggleLinkMenu(El);
  else if (El.classList.contains('note-toggle')) ToggleNote(El);
  else VaultLoader.Load();
});

for (const [Btn, Menu] of Menus) {
  Btn.addEventListener('click', () => SetDropdown(Btn, Menu, !Menu.classList.contains('open')));
}

NavTabMenu.addEventListener('click', ({ target }) => {
  const Item = target.closest('.nav-dropdown-item');
  if (!Item) return;
  SetDropdown(NavTabBtn, NavTabMenu, false);
  if (Item.dataset.tab === State.CurrentTab) return;
  State.CurrentTab = Item.dataset.tab;
  ById('nav-btn-text').textContent = Item.textContent.trim();
  for (const Other of NavTabMenu.querySelectorAll('.nav-dropdown-item')) Other.classList.toggle('active', Other === Item);
  RenderEras();
});

FilterMenu.addEventListener('click', ({ target }) => {
  const Item = target.closest('.filter-item');
  if (!Item) return;
  const Key = Item.dataset.quality;
  const Enable = !State.ActiveQualities.has(Key);
  if (!Enable && State.ActiveQualities.size === 1) return;
  if (Enable) State.ActiveQualities.add(Key);
  else State.ActiveQualities.delete(Key);
  Item.classList.toggle('active', Enable);
  Item.setAttribute('aria-checked', String(Enable));
  QualityVisCache.clear();
  RenderEras();
});

let SearchTimer;
SearchBox.addEventListener('input', () => {
  clearTimeout(SearchTimer);
  SearchTimer = setTimeout(RenderEras, 200);
});

document.addEventListener('click', ({ target }) => {
  for (const [Btn, Menu] of Menus) {
    if (!Btn.contains(target) && !Menu.contains(target)) SetDropdown(Btn, Menu, false);
  }
  if (!target.closest('.song-dropdown')) CloseLinkMenu();
});

document.addEventListener('keydown', Ev => {
  const { key, target } = Ev;
  if (key === 'Escape') {
    SearchBox.blur();
    for (const [Btn, Menu] of Menus) SetDropdown(Btn, Menu, false);
    CloseLinkMenu();
  } else if (key === '/' && !Ev.ctrlKey && !Ev.metaKey && !Ev.altKey && !target.matches('input, textarea, select')) {
    Ev.preventDefault();
    SearchBox.focus();
  } else if ((key === 'Enter' || key === ' ') && target.matches(ButtonLike)) {
    Ev.preventDefault();
    target.click();
  }
});

addEventListener('scroll', CloseLinkMenu, { passive: true });
addEventListener('resize', CloseLinkMenu);
addEventListener('online', () => { if (!State.VaultData) VaultLoader.Load(); });

VaultLoader.ReadCache();
VaultLoader.Load();
