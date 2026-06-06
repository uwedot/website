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
  if (!Quality) return true;
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
      if (IsCurrent && !Audio.paused) {
        Btn.textContent = 'Stop';
      } else {
        Btn.textContent = 'Play';
      }
    } catch (e) {
      Btn.textContent = 'Play';
    }
  });
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
  if (LeakDateIdx === -1) {
    LeakDateIdx = Header.findIndex(H => H.includes('date'));
  }

  const Col = {
    era:    Header.indexOf('era'),
    name:   Header.indexOf('name'),
    quality:Header.indexOf('quality'),
    url:    Header.indexOf('link(s)'),
    notes:  Header.indexOf('notes'),
    leakDate: LeakDateIdx,
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
      (R[Col.quality] || '').trim(),
      (R[Col.url]     || '').trim(),
      (R[Col.notes]   || '').trim(),
      Col.leakDate !== -1 ? (R[Col.leakDate] || '').trim() : '',
    ]);
  }

  return EraMap;
}

function EscapeHtml(Str) {
  return Str.replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;');
}

function MakeSongEl(Name, Quality, Url, Notes, Num) {
  const HasNote = Notes.trim() !== '';
  
  const UrlList = Url ? Url.split(/[\s,\n\r]+/).map(u => u.trim()).filter(u => /^https?:/i.test(u)) : [];
  const HasUrl = UrlList.length > 0;

  let DisplayQuality = Quality;
  if (!HasUrl) {
    DisplayQuality = 'Unavailable';
  }

  const PillowsUrl = UrlList.find(u => u.includes('pillows.su/f/'));
  let PlayBtnHtml = '';
  if (PillowsUrl) {
    const DownloadUrl = PillowsUrl.replace('pillows.su/f/', 'api.pillows.su/api/download/');
    const Audio = document.getElementById('main-audio');
    let BtnText = 'Play';
    if (Audio && Audio.src) {
      try {
        const IsCurrent = new URL(Audio.src).href === new URL(DownloadUrl, window.location.href).href;
        if (IsCurrent && !Audio.paused) {
          BtnText = 'Stop';
        }
      } catch (e) {}
    }
    PlayBtnHtml = `<button type="button" class="song-play-btn play-btn" data-url="${EscapeHtml(DownloadUrl)}" data-name="${EscapeHtml(Name)}">${BtnText}</button>`;
  }

  let LinksHtml = '';
  if (UrlList.length > 1) {
    let ItemsHtml = '';
    UrlList.forEach((u, index) => {
      ItemsHtml += `<a class="song-dropdown-item" href="${EscapeHtml(u)}" target="_blank" rel="noopener noreferrer">View ${index + 1}</a>`;
    });

    LinksHtml = 
      `<div class="song-dropdown">` +
        `<button type="button" class="song-dropdown-btn">` +
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

  let ActionsRightHtml = PlayBtnHtml + LinksHtml;
  ActionsRightHtml += HasNote ? `<div class="note-toggle" aria-label="Show note">＋</div>` : `<div class="note-toggle-placeholder"></div>`;

  const El = document.createElement('div');
  El.className = 'song-item';

  El.innerHTML =
    `<div class="song-num">${Num}</div>` +
    `<div class="song-name" title="${EscapeHtml(Name)}">${EscapeHtml(Name)}</div>` +
    `<div class="song-actions">` +
      `<div class="song-actions-left">` +
        (DisplayQuality ? `<div class="song-quality ${QClass(DisplayQuality)}">${EscapeHtml(DisplayQuality)}</div>` : `<div class="song-quality-placeholder"></div>`) +
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
      document.querySelectorAll('.song-dropdown-menu.open').forEach(M => {
        if (M !== DropMenu) M.classList.remove('open');
      });
      DropMenu.classList.toggle('open', !IsOpen);
    });
  }

  const PlayBtn = El.querySelector('.play-btn');
  if (PlayBtn) {
    PlayBtn.addEventListener('click', Ev => {
      Ev.stopPropagation();
      try {
        const TrackUrl = new URL(PlayBtn.dataset.url, window.location.href).href;
        const TrackName = PlayBtn.dataset.name;
        
        const Player = document.getElementById('global-player');
        const Audio = document.getElementById('main-audio');
        const NameEl = document.getElementById('player-track-name');
        
        const IsCurrent = Audio.src && (new URL(Audio.src).href === TrackUrl);
        
        if (IsCurrent) {
          if (Audio.paused) {
            Audio.play();
          } else {
            Audio.pause();
          }
        } else {
          NameEl.textContent = TrackName;
          Audio.src = TrackUrl;
          Player.classList.add('active');
          Audio.play();
        }
      } catch (err) {}

      document.querySelectorAll('.song-dropdown-menu.open').forEach(M => M.classList.remove('open'));
    });
  }

  if (HasNote) {
    const NoteEl = document.createElement('div');
    NoteEl.className = 'song-note';
    NoteEl.textContent = Notes;
    El.querySelector('.note-toggle').addEventListener('click', Ev => {
      Ev.stopPropagation();
      const IsExp = El.classList.toggle('expanded');
      Ev.currentTarget.textContent = IsExp ? '－' : '＋';
      Ev.currentTarget.setAttribute('aria-label', IsExp ? 'Hide note' : 'Show note');
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

function RenderEras(Filter = '') {
  const List = document.getElementById('era-list');
  const F = Filter.trim().toLowerCase();

  if (!AllData) return;

  const TabEmoji = CurrentTab === 'best' ? '⭐' : CurrentTab === 'special' ? '✨' : null;

  const Filtered = {};

  if (CurrentTab === 'recent') {
    const AllSongs = [];
    for (const [Era, Songs] of Object.entries(AllData)) {
      let Matched = Songs.filter(([, Quality]) => QualityAllowed(Quality));
      if (F) {
        Matched = Matched.filter(([Name]) =>
          Name.toLowerCase().includes(F) || Era.toLowerCase().includes(F)
        );
      }
      Matched.forEach(Song => {
        AllSongs.push({
          era: Era,
          name: Song[0],
          quality: Song[1],
          url: Song[2],
          notes: Song[3],
          dateStr: Song[4] || ''
        });
      });
    }

    AllSongs.sort((A, B) => GetDateValue(B.dateStr) - GetDateValue(A.dateStr));

    const RecentSongs = AllSongs.slice(0, 200);

    if (RecentSongs.length > 0) {
      Filtered['Recent Leaks'] = RecentSongs.map(S => {
        const DateTag = S.dateStr ? ` (${S.dateStr})` : '';
        return [
          `[${S.era}] ${S.name}${DateTag}`,
          S.quality,
          S.url,
          S.notes
        ];
      });
    }
  } else {
    for (const [Era, Songs] of Object.entries(AllData)) {
      let Matched = Songs.filter(([, Quality]) => QualityAllowed(Quality));
      if (TabEmoji) Matched = Matched.filter(([Name]) => Name.includes(TabEmoji));
      if (F) Matched = Matched.filter(([Name]) =>
        Name.toLowerCase().includes(F) || Era.toLowerCase().includes(F)
      );
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
    El.textContent = 'no results found';
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

    let CloseTimer = null;

    function Toggle() {
      const IsOpen = Panel.classList.contains('open');
      if (IsOpen) {
        Panel.classList.remove('open');
        Row.classList.remove('active');
        Row.setAttribute('aria-expanded', 'false');
        CloseTimer = setTimeout(() => { Panel.style.display = 'none'; CloseTimer = null; }, 200);
      } else {
        if (CloseTimer) { clearTimeout(CloseTimer); CloseTimer = null; }
        Panel.style.display = 'block';
        requestAnimationFrame(() => requestAnimationFrame(() => Panel.classList.add('open')));
        Row.classList.add('active');
        Row.setAttribute('aria-expanded', 'true');
        if (!Inner.dataset.loaded) {
          Inner.dataset.loaded = '1';
          const SongFrag = document.createDocumentFragment();
          Songs.forEach(([Name, Quality, Url, Notes], I) => {
            MakeSongEl(Name, Quality, Url, Notes, I + 1).forEach(Node => SongFrag.appendChild(Node));
          });
          Inner.appendChild(SongFrag);
          UpdatePlayButtonsState();
          requestAnimationFrame(() => Row.scrollIntoView({ behavior: 'smooth', block: 'nearest' }));
        }
      }
    }

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
  SearchTimer = setTimeout(() => { if (AllData) RenderEras(Val); }, 150);
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
    MainAudio.addEventListener('play', UpdatePlayButtonsState);
    MainAudio.addEventListener('pause', UpdatePlayButtonsState);
    MainAudio.addEventListener('ended', UpdatePlayButtonsState);
  }

  NavBtn.addEventListener('click', E => {
    E.stopPropagation();
    NavMenu.classList.toggle('open');
  });

  document.querySelectorAll('.nav-dropdown-item').forEach(Item => {
    Item.addEventListener('click', () => {
      if (Item.dataset.tab === CurrentTab) {
        NavMenu.classList.remove('open');
        return;
      }
      CurrentTab = Item.dataset.tab;
      NavText.textContent = Item.textContent;
      document.querySelectorAll('.nav-dropdown-item').forEach(I => I.classList.toggle('active', I === Item));
      NavMenu.classList.remove('open');
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
      document.querySelectorAll('.song-dropdown-menu.open').forEach(M => M.classList.remove('open'));
    }
  });

  window.addEventListener('scroll', () => {
    ScrollBtn.classList.toggle('visible', window.scrollY > 400);
  }, { passive: true });

  ScrollBtn.addEventListener('click', () => window.scrollTo({ top: 0, behavior: 'smooth' }));

  FilterBtn.addEventListener('click', E => {
    E.stopPropagation();
    FilterMenu.classList.toggle('open');
  });

  document.addEventListener('click', E => {
    if (!FilterMenu.contains(E.target) && E.target !== FilterBtn) {
      FilterMenu.classList.remove('open');
    }
    if (!NavMenu.contains(E.target) && !NavBtn.contains(E.target)) {
      NavMenu.classList.remove('open');
    }
    if (!E.target.closest('.song-dropdown')) {
      document.querySelectorAll('.song-dropdown-menu.open').forEach(M => M.classList.remove('open'));
    }
  });

  FilterMenu.addEventListener('click', E => {
    const Item = E.target.closest('.filter-item');
    if (!Item) return;
    
    const Key = Item.dataset.quality;

    if (ActiveQualities.has(Key)) {
      if (ActiveQualities.size === 1) return;
      ActiveQualities.delete(Key);
      Item.classList.remove('active');
    } else {
      ActiveQualities.add(Key);
      Item.classList.add('active');
    }
    if (AllData) RenderEras(SearchBox.value);
  });

  (async () => {
    async function FetchSheet(Id) {
      const Url = `https://docs.google.com/spreadsheets/d/${Id}/export?format=csv`;
      const Res = await fetch(Url);
      if (!Res.ok) throw new Error(`HTTP ${Res.status}`);
      return Res.text();
    }

    try {
      let MainCsv;
      try {
        MainCsv = await FetchSheet(SheetId);
      } catch {
        MainCsv = await FetchSheet(FallbackSheetId);
      }
      AllData = BuildData(ParseCsv(MainCsv));
      RenderEras();
    } catch (Err) {
      const El = document.createElement('div');
      El.className = 'no-results';
      El.style.color = '#c0392b';
      El.textContent = 'failed to load data, check sheet permissions';
      document.getElementById('era-list').replaceChildren(El);
    }
  })();
});
