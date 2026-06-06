const SheetId = '1cC-caBQ4j-OWreS37ackw7Gkkq83Hvi6x-mIRHBLxJo';

let AllData = null;
let CurrentTab = 'all';
let ActiveQualities = new Set(['high', 'low', 'rec', 'cd', 'lossless']);

const QualityKeys = {
  high:     L => L.includes('high'),
  low:      L => L.includes('low') && !L.includes('high'),
  rec:      L => L.includes('record'),
  cd:       L => L.includes('cd'),
  lossless: L => L.includes('lossless'),
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
  const Col = {
    era:     Header.indexOf('era'),
    name:    Header.indexOf('name'),
    quality: Header.indexOf('quality'),
    length:  Header.indexOf('track length'),
    url:     Header.indexOf('link(s)'),
    notes:   Header.indexOf('notes'),
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
      (R[Col.length]  || '').trim(),
      (R[Col.url]     || '').trim(),
      (R[Col.notes]   || '').trim(),
    ]);
  }

  return EraMap;
}

function EscapeHtml(Str) {
  return Str
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;');
}

function ParseSongName(Name) {
  const All = [];
  const Base = Name
    .replace(/\(([^)]+)\)/g, (_, Inner) => { All.push('(' + Inner + ')'); return ' '; })
    .replace(/\s{2,}/g, ' ')
    .trim();
  const Credits = All.filter(P => /feat\.|ft\.|prod\./i.test(P));
  const Rest    = All.filter(P => !/feat\.|ft\.|prod\./i.test(P));
  const Subs = [];
  if (Credits.length) Subs.push(Credits.join(' '));
  Subs.push(...Rest);
  return { Base, Subs };
}

function MakeSongEl(Name, Quality, Length, Url, Notes, Num) {
  const HasNote = Notes.trim() !== '';
  const HasUrl  = !!(Url && /^https?:/i.test(Url.trim()));
  const { Base, Subs } = ParseSongName(Name);

  const El = document.createElement('div');
  El.className = 'song-item' + (HasNote ? ' has-note' : '');

  const SubHtml = Subs
    .map(S => `<div class="song-sub-line">${EscapeHtml(S)}</div>`)
    .join('');

  El.innerHTML =
    `<div class="song-num">${Num}</div>` +
    `<div class="song-main">` +
      `<div class="song-name" title="${EscapeHtml(Name)}">${EscapeHtml(Base)}</div>` +
      (Subs.length ? `<div class="song-subs">${SubHtml}</div>` : '') +
    `</div>` +
    (Quality ? `<div class="song-quality ${QClass(Quality)}">${EscapeHtml(Quality)}</div>` : '') +
    (Length  ? `<div class="song-len">${EscapeHtml(Length)}</div>` : '') +
    (HasUrl  ? `<a class="song-link-btn" href="${EscapeHtml(Url)}" target="_blank" rel="noopener noreferrer" aria-label="Open link for ${EscapeHtml(Base)}">open</a>` : '') +
    (HasNote ? `<button type="button" class="note-toggle" aria-label="Show note for ${EscapeHtml(Base)}" aria-expanded="false">+</button>` : '');

  if (HasNote) {
    const NoteEl = document.createElement('div');
    NoteEl.className = 'song-note';
    NoteEl.setAttribute('role', 'note');
    NoteEl.textContent = Notes;
    El.querySelector('.note-toggle').addEventListener('click', Ev => {
      Ev.stopPropagation();
      const IsExp = El.classList.toggle('expanded');
      Ev.currentTarget.textContent = IsExp ? '\u2212' : '+';
      Ev.currentTarget.setAttribute('aria-expanded', String(IsExp));
      Ev.currentTarget.setAttribute('aria-label', (IsExp ? 'Hide' : 'Show') + ` note for ${Base}`);
    });
    return [El, NoteEl];
  }
  return [El];
}

function ShowError(Msg) {
  const El = document.createElement('div');
  El.className = 'no-results load-error';
  El.setAttribute('role', 'alert');
  El.innerHTML =
    `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" aria-hidden="true"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>` +
    `<span>${EscapeHtml(Msg)}</span>`;
  document.getElementById('era-list').replaceChildren(El);
}

function RenderEras(EraObj, Filter = '') {
  const List = document.getElementById('era-list');
  const F = Filter.trim().toLowerCase();

  const TabEmoji = CurrentTab === 'best' ? '\u2b50' : CurrentTab === 'special' ? '\u2728' : null;

  const Filtered = {};
  for (const [Era, Songs] of Object.entries(EraObj)) {
    let Matched = Songs.filter(([, Quality]) => QualityAllowed(Quality));
    if (TabEmoji) Matched = Matched.filter(([Name]) => Name.includes(TabEmoji));
    if (F) Matched = Matched.filter(([Name]) =>
      Name.toLowerCase().includes(F) || Era.toLowerCase().includes(F)
    );
    if (Matched.length) Filtered[Era] = Matched;
  }

  const EraKeys = Object.keys(Filtered);
  const TotalSongs = EraKeys.reduce((S, K) => S + Filtered[K].length, 0);
  document.getElementById('nav-eras').textContent = EraKeys.length;
  document.getElementById('nav-songs').textContent = TotalSongs.toLocaleString();

  const Frag = document.createDocumentFragment();

  if (EraKeys.length === 0) {
    const El = document.createElement('div');
    El.className = 'no-results';
    El.setAttribute('role', 'status');
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
    Row.setAttribute('aria-label', `${Era}, ${Songs.length} songs`);
    Row.innerHTML =
      `<div class="era-row-name">${EscapeHtml(Era)}</div>` +
      `<div class="era-row-right">` +
        `<div class="era-pill" aria-hidden="true">${Songs.length} Songs</div>` +
        `<svg class="era-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true"><polyline points="6,9 12,15 18,9"/></svg>` +
      `</div>`;

    const Panel = document.createElement('div');
    Panel.className = 'songs-panel';
    Panel.setAttribute('role', 'region');
    Panel.setAttribute('aria-label', `${Era} songs`);
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
          Songs.forEach(([Name, Quality, Length, Url, Notes], I) => {
            MakeSongEl(Name, Quality, Length, Url, Notes, I + 1).forEach(Node => SongFrag.appendChild(Node));
          });
          Inner.appendChild(SongFrag);
          requestAnimationFrame(() => Row.scrollIntoView({ behavior: 'smooth', block: 'nearest' }));
        }
      }
    }

    Row.addEventListener('click', Toggle);
    Row.addEventListener('keydown', E => {
      if (E.key === 'Enter' || E.key === ' ') { E.preventDefault(); Toggle(); }
    });

    Wrap.appendChild(Row);
    Wrap.appendChild(Panel);
    Frag.appendChild(Wrap);
  }

  List.replaceChildren(Frag);
}

let SearchTimer;
function OnSearch(Val) {
  clearTimeout(SearchTimer);
  SearchTimer = setTimeout(() => { if (AllData) RenderEras(AllData, Val); }, 150);
}

document.addEventListener('DOMContentLoaded', () => {
  const SearchBox  = document.getElementById('search-box');
  const FilterWrap = document.getElementById('filter-wrap');
  const ScrollBtn  = document.getElementById('scroll-top');

  SearchBox.addEventListener('input', E => OnSearch(E.target.value));

  document.querySelectorAll('.nav-tab').forEach(Tab => {
    Tab.addEventListener('click', () => {
      if (Tab.dataset.tab === CurrentTab) return;
      CurrentTab = Tab.dataset.tab;
      document.querySelectorAll('.nav-tab').forEach(T => T.classList.toggle('active', T === Tab));
      if (AllData) RenderEras(AllData, SearchBox.value);
    });
  });

  document.addEventListener('keydown', E => {
    if (E.key === '/' && document.activeElement !== SearchBox) {
      E.preventDefault();
      SearchBox.focus();
    }
    if (E.key === 'Escape') SearchBox.blur();
  });

  window.addEventListener('scroll', () => {
    ScrollBtn.classList.toggle('visible', window.scrollY > 400);
  }, { passive: true });

  ScrollBtn.addEventListener('click', () => window.scrollTo({ top: 0, behavior: 'smooth' }));

  FilterWrap.addEventListener('click', E => {
    const Chip = E.target.closest('.filter-chip');
    if (!Chip) return;
    const Key = Chip.dataset.quality;
    if (ActiveQualities.has(Key)) {
      if (ActiveQualities.size === 1) return;
      ActiveQualities.delete(Key);
      Chip.classList.remove('active');
    } else {
      ActiveQualities.add(Key);
      Chip.classList.add('active');
    }
    if (AllData) RenderEras(AllData, SearchBox.value);
  });

  (async () => {
    try {
      const Res = await fetch(`https://docs.google.com/spreadsheets/d/${SheetId}/export?format=csv`);
      if (!Res.ok) throw new Error(`HTTP ${Res.status}`);
      const Text = await Res.text();
      if (!Text.trim()) throw new Error('Empty response from sheet');
      AllData = BuildData(ParseCsv(Text));
      if (Object.keys(AllData).length === 0) throw new Error('No data found - check sheet permissions');
      RenderEras(AllData);
    } catch (Err) {
      console.error('Failed to load sheet data:', Err);
      ShowError(Err.message || 'Failed to load data');
    }
  })();
});
