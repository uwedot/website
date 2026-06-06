const SheetId = '1cC-caBQ4j-OWreS37ackw7Gkkq83Hvi6x-mIRHBLxJo';
const FallbackSheetId = '12nGHPPh5dVTfLuBLVQYzC3QgPxKfvp-jgCoNccvEasM';

let AllData = null;
let CurrentTab = 'all';
let ActiveQualities = new Set(['high', 'low', 'rec', 'cd', 'lossless']);

const QualityKeys = {
  high:    L => L.includes('high'),
  low:     L => L.includes('low') && !L.includes('high'),
  rec:     L => L.includes('record'),
  cd:      L => L.includes('cd'),
  lossless:L => L.includes('lossless'),
};

function QClass(Q) {
  if (!Q) return 'q-other';
  const L = Q.toLowerCase();
  if (L.includes('high'))     return 'q-high';
  if (L.includes('cd'))       return 'q-cd';
  if (L.includes('low'))      return 'q-low';
  if (L.includes('record'))   return 'q-rec';
  if (L.includes('lossless')) return 'q-lossless';
  return 'q-other';
}

function QualityAllowed(Quality) {
  if (!Quality) return false;
  const L = Quality.toLowerCase();
  if (L.includes('not avail') || L.includes('unavail')) return false;
  for (const Key of ActiveQualities) {
    if (QualityKeys[Key](L)) return true;
  }
  return false;
}

function UpdatePlayButtonsState() {
  const Audio = document.getElementById('main-audio');
  if (!Audio) return;
  document.querySelectorAll('.play-btn').forEach(Btn => {
    try {
      const IsCurrent = Audio.src && (new URL(Audio.src).href === new URL(Btn.dataset.url, window.location.href).href);
      Btn.textContent = (IsCurrent && !Audio.paused) ? 'Pause' : 'Play';
    } catch {
      Btn.textContent = 'Play';
    }
  });
}

function CloseAllSongDropdowns() {
  document.querySelectorAll('.song-dropdown-menu.open').forEach(M => M.classList.remove('open'));
}

function ParseCsv(Text) {
  const Rows = [];
  let Field = '', Row = [], InQuote = false;
  for (let I = 0; I < Text.length; I++) {
    const Ch = Text[I];
    if (InQuote) {
      if (Ch === '"' && Text[I + 1] === '"') { Field += '"'; I++; }
      else if (Ch === '"') InQuote = false;
      else Field += Ch;
    } else {
      if (Ch === '"') InQuote = true;
      else if (Ch === ',') { Row.push(Field); Field = ''; }
      else if (Ch === '\n') { Row.push(Field); Rows.push(Row); Row = []; Field = ''; }
      else if (Ch !== '\r') Field += Ch;
    }
  }
  if (Field || Row.length) { Row.push(Field); Rows.push(Row); }
  return Rows;
}

function BuildData(Rows) {
  const EraMap = {};
  if (Rows.length < 2) return EraMap;

  const Header = Rows[0].map(H => H.trim().toLowerCase());

  let LeakDateIdx = Header.indexOf('leak date');
  if (LeakDateIdx === -1) LeakDateIdx = Header.findIndex(H => H.includes('date'));

  let UrlIdx = Header.indexOf('link(s)');
  if (UrlIdx === -1) UrlIdx = Header.findIndex(H => h => h.includes('link'));

  const Col = {
    era:      Header.indexOf('era'),
    name:     Header.indexOf('name'),
    quality:  Header.indexOf('quality'),
    url:      UrlIdx,
    notes:    Header.indexOf('notes'),
    leakDate: LeakDateIdx,
    type:     Header.findIndex(H => H.includes('available length')),
  };

  const SummaryPattern = /^\d+\s+(og file|full|tagged|partial|snippet|stem bounce|unavailable)/i;

  for (let I = 1; I < Rows.length; I++) {
    const R = Rows[I];
    if (!R || R.every(C => !C.trim())) continue;
    const Era = (R[Col.era] || '').trim();
    if (!Era) continue;
    const Name = (R[Col.name] || '').trim();
    if (!Name) continue;
    if (SummaryPattern.test(Name) || SummaryPattern.test(Era)) continue;

    if (!EraMap[Era]) EraMap[Era] = [];
    EraMap[Era].push([
      Name,
      (R[Col.quality]  || '').trim(),
      Col.url      !== -1 ? (R[Col.url]      || '').trim() : '',
      (R[Col.notes]    || '').trim(),
      Col.leakDate !== -1 ? (R[Col.leakDate] || '').trim() : '',
      Col.type     !== -1 ? (R[Col.type]     || '').trim() : '',
    ]);
  }

  return EraMap;
}

function EscapeHtml(Str) {
  return Str.replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;');
}

function TClass(T) {
  if (!T) return 'tl-other';
  const L = T.toLowerCase();
  if (L.includes('og'))      return 'tl-og';
  if (L.includes('stem'))    return 'tl-stem';
  if (L.includes('full'))    return 'tl-full';
  if (L.includes('tagged'))  return 'tl-tagged';
  if (L.includes('partial')) return 'tl-partial';
  if (L.includes('snippet')) return 'tl-snippet';
  if (L.includes('unavail')) return 'tl-unavail';
  return 'tl-other';
}

function PositionDropdown(Btn, Menu) {
  Menu.style.visibility = 'hidden';
  Menu.style.display = 'flex';
  const MenuH = Menu.offsetHeight;
  const MenuW = Menu.offsetWidth;
  Menu.style.display = '';
  Menu.style.visibility = '';

  const Rect = Btn.getBoundingClientRect();
  const SpaceBelow = window.innerHeight - Rect.bottom;

  const Left = Math.max(4, Math.min(Rect.right - MenuW, window.innerWidth - MenuW - 4));

  if (SpaceBelow < MenuH + 8) {
    Menu.style.top = (Rect.top - MenuH - 4) + 'px';
  } else {
    Menu.style.top = (Rect.bottom + 4) + 'px';
  }
  Menu.style.left = Left + 'px';
  Menu.style.right = '';
}

function MakeSongEl(Name, Quality, Url, Notes, Num, TrackType = '') {
  const HasNote = Notes.trim() !== '';

  const UrlList = Url ? Url.split(/[\s,\n\r]+/).map(U => U.trim()).filter(U => /^https?:/i.test(U)) : [];
  const HasUrl = UrlList.length > 0;

  const DisplayQuality = HasUrl ? Quality : 'Unavailable';

  const PillowsUrl = UrlList.find(U => U.includes('pillows.su/f/'));
  let PlayBtnHtml = '';
  if (PillowsUrl) {
    const DownloadUrl = PillowsUrl.replace('pillows.su/f/', 'api.pillows.su/api/download/');
    const Audio = document.getElementById('main-audio');
    let BtnText = 'Play';
    if (Audio && Audio.src) {
      try {
        if (new URL(Audio.src).href === new URL(DownloadUrl, window.location.href).href && !Audio.paused) {
          BtnText = 'Pause';
        }
      } catch {}
    }
    PlayBtnHtml = `<button type="button" class="song-play-btn play-btn" data-url="${EscapeHtml(DownloadUrl)}" data-name="${EscapeHtml(Name)}">${BtnText}</button>`;
  }

  let LinksHtml = '';
  if (UrlList.length > 1) {
    let ItemsHtml = '';
    UrlList.forEach((U, Idx) => {
      ItemsHtml += `<a class="song-dropdown-item" href="${EscapeHtml(U)}" target="_blank" rel="noopener noreferrer">View ${Idx + 1}</a>`;
    });
    LinksHtml =
      `<div class="song-dropdown">` +
        `<button type="button" class="song-dropdown-btn" aria-haspopup="true" aria-expanded="false">` +
          `<span>Links</span>` +
          `<svg class="dropdown-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">` +
            `<polyline points="6,9 12,15 18,9"/>` +
          `</svg>` +
        `</button>` +
        `<div class="song-dropdown-menu" role="menu">` +
          ItemsHtml +
        `</div>` +
      `</div>`;
  } else if (UrlList.length === 1) {
    LinksHtml = `<a class="song-link-btn" href="${EscapeHtml(UrlList[0])}" target="_blank" rel="noopener noreferrer">View</a>`;
  } else {
    LinksHtml = `<div class="song-link-placeholder"></div>`;
  }

  const ActionsRightHtml =
    PlayBtnHtml +
    LinksHtml +
    (HasNote ? `<div class="note-toggle" role="button" tabindex="0" aria-label="Show note">＋</div>` : `<div class="note-toggle-placeholder"></div>`);

  const El = document.createElement('div');
  El.className = 'song-item';
  El.innerHTML =
    `<div class="song-num">${Num}</div>` +
    `<div class="song-name" title="${EscapeHtml(Name)}">${EscapeHtml(Name)}</div>` +
    `<div class="song-actions">` +
      `<div class="song-actions-left">` +
        (DisplayQuality ? `<div class="song-quality ${QClass(DisplayQuality)}">${EscapeHtml(DisplayQuality)}</div>` : `<div class="song-quality-placeholder"></div>`) +
        (TrackType      ? `<div class="song-type ${TClass(TrackType)}">${EscapeHtml(TrackType)}</div>`            : `<div class="song-type-placeholder"></div>`) +
      `</div>` +
      `<div class="song-actions-right">` +
        ActionsRightHtml +
      `</div>` +
    `</div>`;

  if (UrlList.length > 1) {
    const DropBtn = El.querySelector('.song-dropdown-btn');
    const DropMenu = El.querySelector('.song-dropdown-menu');

    DropBtn.addEventListener('click', Ev => {
      Ev.stopPropagation();
      const IsOpen = DropMenu.classList.contains('open');
      CloseAllSongDropdowns();
      if (!IsOpen) {
        PositionDropdown(DropBtn, DropMenu);
        DropMenu.classList.add('open');
        DropBtn.setAttribute('aria-expanded', 'true');
      }
    });
  }

  const PlayBtn = El.querySelector('.play-btn');
  if (PlayBtn) {
    PlayBtn.addEventListener('click', Ev => {
      Ev.stopPropagation();
      CloseAllSongDropdowns();
      const TrackUrl = new URL(PlayBtn.dataset.url, window.location.href).href;
      const Player = document.getElementById('global-player');
      const Audio  = document.getElementById('main-audio');
      const NameEl = document.getElementById('player-track-name');
      const IsCurrent = Audio.src && (new URL(Audio.src).href === TrackUrl);
      if (IsCurrent) {
        Audio.paused ? Audio.play().catch(() => {}) : Audio.pause();
      } else {
        NameEl.textContent = PlayBtn.dataset.name;
        Audio.src = TrackUrl;
        Player.classList.add('active');
        Audio.play().catch(() => {});
      }
    });
  }

  if (HasNote) {
    const NoteEl = document.createElement('div');
    NoteEl.className = 'song-note';
    NoteEl.textContent = Notes;
    const NoteToggle = El.querySelector('.note-toggle');
    NoteToggle.addEventListener('click', Ev => {
      Ev.stopPropagation();
      const IsExp = El.classList.toggle('expanded');
      NoteToggle.textContent = IsExp ? '－' : '＋';
      NoteToggle.setAttribute('aria-label', IsExp ? 'Hide note' : 'Show note');
    });
    NoteToggle.addEventListener('keydown', Ev => {
      if (Ev.key === 'Enter' || Ev.key === ' ') { Ev.preventDefault(); NoteToggle.click(); }
    });
    return [El, NoteEl];
  }
  return [El];
}

function GetDateValue(Str) {
  if (!Str) return 0;
  const Num = Date.parse(Str);
  if (!isNaN(Num)) return Num;
  const YearMatch = Str.match(/\b(19|20)\d{2}\b/);
  if (YearMatch) return new Date(YearMatch[0], 0, 1).getTime();
  return 0;
}

function CollapseAllPanels() {
  document.querySelectorAll('.songs-panel.open').forEach(P => {
    P.classList.remove('open');
    const Row = P.previousElementSibling;
    if (Row) { Row.classList.remove('active'); Row.setAttribute('aria-expanded', 'false'); }
  });
}

function RenderEras(Filter = '') {
  const List = document.getElementById('era-list');
  const F = Filter.trim().toLowerCase();

  if (!AllData) return;

  CollapseAllPanels();
  CloseAllSongDropdowns();

  const TabEmoji = CurrentTab === 'best' ? '⭐' : CurrentTab === 'special' ? '✨' : null;
  const Filtered = {};

  if (CurrentTab === 'recent') {
    const AllSongs = [];
    for (const [Era, Songs] of Object.entries(AllData)) {
      Songs.filter(([, Quality]) => QualityAllowed(Quality)).forEach(Song => {
        if (!F || Song[0].toLowerCase().includes(F) || Era.toLowerCase().includes(F)) {
          AllSongs.push({ era: Era, name: Song[0], quality: Song[1], url: Song[2], notes: Song[3], dateStr: Song[4] || '', trackType: Song[5] || '' });
        }
      });
    }
    AllSongs.sort((A, B) => GetDateValue(B.dateStr) - GetDateValue(A.dateStr));
    const RecentSongs = AllSongs.slice(0, 200);
    if (RecentSongs.length > 0) {
      Filtered['Recent Leaks'] = RecentSongs.map(S => [
        `[${S.era}] ${S.name}${S.dateStr ? ` (${S.dateStr})` : ''}`,
        S.quality, S.url, S.notes, S.dateStr, S.trackType,
      ]);
    }
  } else {
    for (const [Era, Songs] of Object.entries(AllData)) {
      let Matched = Songs.filter(([, Quality]) => QualityAllowed(Quality));
      if (TabEmoji) Matched = Matched.filter(([Name]) => Name.includes(TabEmoji));
      if (F) Matched = Matched.filter(([Name]) => Name.toLowerCase().includes(F) || Era.toLowerCase().includes(F));
      if (Matched.length) Filtered[Era] = Matched;
    }
  }

  const EraKeys = Object.keys(Filtered);
  const TotalSongs = EraKeys.reduce((S, K) => S + Filtered[K].length, 0);
  document.getElementById('nav-eras').textContent = EraKeys.length;
  document.getElementById('nav-songs').textContent = TotalSongs.toLocaleString();

  const Frag = document.createDocumentFragment();

  if (EraKeys.length === 0) {
    const El = document.createElement('div');
    El.className = 'no-results';
    El.textContent = 'No results found.';
    Frag.appendChild(El);
    List.replaceChildren(Frag);
    return;
  }

  for (const Era of EraKeys) {
    const Songs = Filtered[Era];

    const Wrap = document.createElement('div');
    Wrap.className = 'era-wrap';

    const Row = document.createElement('div');
    Row.className = 'era-row';
    Row.setAttribute('role', 'button');
    Row.setAttribute('tabindex', '0');
    Row.setAttribute('aria-expanded', 'false');
    Row.innerHTML =
      `<div class="era-row-name">${EscapeHtml(Era)}</div>` +
      `<div class="era-row-right">` +
        `<div class="era-pill">${Songs.length} Songs</div>` +
        `<svg class="era-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true"><polyline points="6,9 12,15 18,9"/></svg>` +
      `</div>`;

    const Panel = document.createElement('div');
    Panel.className = 'songs-panel';
    const Inner = document.createElement('div');
    Inner.className = 'songs-inner';
    Panel.appendChild(Inner);

    const Toggle = () => {
      const IsOpen = Panel.classList.contains('open');
      CloseAllSongDropdowns();
      if (IsOpen) {
        Panel.classList.remove('open');
        Row.classList.remove('active');
        Row.setAttribute('aria-expanded', 'false');
      } else {
        Panel.classList.add('open');
        Row.classList.add('active');
        Row.setAttribute('aria-expanded', 'true');
        if (!Inner.dataset.loaded) {
          Inner.dataset.loaded = '1';
          const SongFrag = document.createDocumentFragment();
          Songs.forEach(([Name, Quality, Url, Notes, , TrackType], I) => {
            MakeSongEl(Name, Quality, Url, Notes, I + 1, TrackType || '').forEach(Node => SongFrag.appendChild(Node));
          });
          Inner.appendChild(SongFrag);
          UpdatePlayButtonsState();
        }
        requestAnimationFrame(() => Row.scrollIntoView({ behavior: 'smooth', block: 'nearest' }));
      }
    };

    Row.addEventListener('click', Toggle);
    Row.addEventListener('keydown', E => { if (E.key === 'Enter' || E.key === ' ') { E.preventDefault(); Toggle(); } });

    Wrap.appendChild(Row);
    Wrap.appendChild(Panel);
    Frag.appendChild(Wrap);
  }

  List.replaceChildren(Frag);
}

let SearchTimer;
function OnSearch(Val) {
  clearTimeout(SearchTimer);
  SearchTimer = setTimeout(() => { if (AllData) RenderEras(Val); }, 180);
}

document.addEventListener('DOMContentLoaded', () => {
  const SearchBox  = document.getElementById('search-box');
  const FilterBtn  = document.getElementById('filter-btn');
  const FilterMenu = document.getElementById('filter-menu');
  const ScrollBtn  = document.getElementById('scroll-top');
  const NavBtn     = document.getElementById('nav-tab-btn');
  const NavMenu    = document.getElementById('nav-tab-menu');
  const NavText    = document.getElementById('nav-btn-text');
  const MainAudio  = document.getElementById('main-audio');

  SearchBox.addEventListener('input', E => OnSearch(E.target.value));

  if (MainAudio) {
    MainAudio.addEventListener('play',  UpdatePlayButtonsState);
    MainAudio.addEventListener('pause', UpdatePlayButtonsState);
    MainAudio.addEventListener('ended', UpdatePlayButtonsState);
  }

  NavBtn.addEventListener('click', E => {
    E.stopPropagation();
    const IsOpen = NavMenu.classList.toggle('open');
    NavBtn.setAttribute('aria-expanded', String(IsOpen));
  });

  document.querySelectorAll('.nav-dropdown-item').forEach(Item => {
    Item.addEventListener('click', () => {
      NavMenu.classList.remove('open');
      NavBtn.setAttribute('aria-expanded', 'false');
      if (Item.dataset.tab === CurrentTab) return;
      CurrentTab = Item.dataset.tab;
      NavText.textContent = Item.textContent.trim();
      document.querySelectorAll('.nav-dropdown-item').forEach(I => I.classList.toggle('active', I === Item));
      if (AllData) RenderEras(SearchBox.value);
    });
  });

  document.addEventListener('keydown', E => {
    if (E.key === '/' && document.activeElement !== SearchBox) {
      E.preventDefault();
      SearchBox.focus();
    }
    if (E.key === 'Escape') {
      SearchBox.blur();
      FilterMenu.classList.remove('open');
      NavMenu.classList.remove('open');
      NavBtn.setAttribute('aria-expanded', 'false');
      CloseAllSongDropdowns();
    }
  });

  window.addEventListener('scroll', () => {
    ScrollBtn.classList.toggle('visible', window.scrollY > 400);
    CloseAllSongDropdowns();
  }, { passive: true });

  ScrollBtn.addEventListener('click', () => window.scrollTo({ top: 0, behavior: 'smooth' }));

  FilterBtn.addEventListener('click', E => {
    E.stopPropagation();
    FilterMenu.classList.toggle('open');
  });

  document.addEventListener('click', E => {
    if (!FilterMenu.contains(E.target) && E.target !== FilterBtn) FilterMenu.classList.remove('open');
    if (!NavMenu.contains(E.target) && !NavBtn.contains(E.target)) {
      NavMenu.classList.remove('open');
      NavBtn.setAttribute('aria-expanded', 'false');
    }
    if (!E.target.closest('.song-dropdown')) CloseAllSongDropdowns();
  });

  FilterMenu.addEventListener('click', E => {
    const Item = E.target.closest('.filter-item');
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
    if (AllData) RenderEras(SearchBox.value);
  });

  (async () => {
    async function FetchSheet(Id) {
      const Res = await fetch(`https://docs.google.com/spreadsheets/d/${Id}/export?format=csv`);
      if (!Res.ok) throw new Error(`HTTP ${Res.status}`);
      return Res.text();
    }

    try {
      let Csv;
      try { Csv = await FetchSheet(SheetId); }
      catch { Csv = await FetchSheet(FallbackSheetId); }
      AllData = BuildData(ParseCsv(Csv));
      RenderEras();
    } catch {
      const El = document.createElement('div');
      El.className = 'no-results';
      El.style.color = 'var(--red)';
      El.textContent = 'Failed to load data. Check sheet permissions.';
      document.getElementById('era-list').replaceChildren(El);
    }
  })();
});
