function QClass(Q) {
  if (!Q) return 'q-na';
  const L = Q.toLowerCase();
  if (L.includes('high')) return 'q-high';
  if (L.includes('cd')) return 'q-cd';
  if (L.includes('low')) return 'q-low';
  if (L.includes('record')) return 'q-rec';
  if (L.includes('confirm')) return 'q-conf';
  if (L.includes('not avail') || L.includes('unavail')) return 'q-na';
  return 'q-other';
}

let AllData = null;

const SheetId = '1cC-caBQ4j-OWreS37ackw7Gkkq83Hvi6x-mIRHBLxJo';

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
      else if (Ch === '\r') {}
      else Field += Ch;
    }
  }
  if (Field || Row.length) { Row.push(Field); Rows.push(Row); }
  return Rows;
}

function BuildDataFromRows(Rows) {
  const EraMap = {};
  if (Rows.length < 2) return EraMap;
  const Header = Rows[0].map(H => H.trim().toLowerCase());
  const ColEra = Header.indexOf('era');
  const ColName = Header.findIndex(H => H === 'name' || H === 'title' || H === 'song');
  const ColQuality = Header.findIndex(H => H.includes('quality') || H.includes('qual'));
  const ColLength = Header.findIndex(H => H.includes('length') || H.includes('duration') || H.includes('len') || H.includes('time'));
  const ColUrl = Header.findIndex(H => H === 'url' || H === 'link' || H === 'href');
  const ColNotes = Header.findIndex(H => H.includes('note') || H.includes('desc'));

  const SummaryPattern = /^\d+\s+(og file|full|tagged|partial|snippet|stem bounce|unavailable)/i;

  for (let I = 1; I < Rows.length; I++) {
    const R = Rows[I];
    if (!R || R.every(C => !C.trim())) continue;
    const Era = ColEra >= 0 ? (R[ColEra] || '').trim() : 'Unknown';
    if (!Era) continue;
    const Name = ColName >= 0 ? (R[ColName] || '').trim() : (R[0] || '').trim();
    if (!Name) continue;
    if (SummaryPattern.test(Name) || SummaryPattern.test(Era)) continue;
    const Quality = ColQuality >= 0 ? (R[ColQuality] || '').trim() : '';
    const Length = ColLength >= 0 ? (R[ColLength] || '').trim() : '';
    const Url = ColUrl >= 0 ? (R[ColUrl] || '').trim() : '';
    const Notes = ColNotes >= 0 ? (R[ColNotes] || '').trim() : '';
    if (!EraMap[Era]) EraMap[Era] = [];
    EraMap[Era].push([Name, Quality, Length, Url, Notes]);
  }
  return EraMap;
}

async function FetchSheet() {
  const Url = `https://docs.google.com/spreadsheets/d/${SheetId}/export?format=csv`;
  const Res = await fetch(Url);
  if (!Res.ok) throw new Error(`Sheet fetch failed: ${Res.status}`);
  return Res.text();
}

document.addEventListener('keydown', E => {
  const SearchBox = document.getElementById('search-box');
  if (E.key === '/' && document.activeElement !== SearchBox) {
    E.preventDefault();
    SearchBox.focus();
  }
  if (E.key === 'Escape') SearchBox.blur();
});

window.addEventListener('scroll', () => {
  const ScrollY = window.pageYOffset || document.documentElement.scrollTop || 0;
  document.getElementById('scroll-top').classList.toggle('visible', ScrollY > 400);
}, { passive: true });

function GoToTop() { window.scrollTo({ top: 0, behavior: 'smooth' }); }

function RenderEras(EraObj, Filter = '') {
  const List = document.getElementById('era-list');
  const Keys = Object.keys(EraObj);
  const Total = Keys.reduce((S, K) => S + EraObj[K].length, 0);
  document.getElementById('nav-eras').textContent = Keys.length;
  document.getElementById('nav-songs').textContent = Total.toLocaleString();

  let Filtered = {};
  if (Filter) {
    const F = Filter.toLowerCase();
    Object.entries(EraObj).forEach(([Era, Songs]) => {
      const Matched = Songs.filter(([Name]) => Name.toLowerCase().includes(F));
      if (Matched.length || Era.toLowerCase().includes(F))
        Filtered[Era] = Matched.length ? Matched : Songs;
    });
  } else {
    Filtered = EraObj;
  }

  List.innerHTML = '';
  if (Object.keys(Filtered).length === 0) {
    List.innerHTML = '<div class="no-results">no results found</div>';
    return;
  }

  Object.entries(Filtered).forEach(([Era, Songs]) => {
    const Wrap = document.createElement('div');
    Wrap.className = 'era-wrap';
    const Row = document.createElement('div');
    Row.className = 'era-row';
    Row.innerHTML = `
      <div class="era-row-name">${Era}</div>
      <div class="era-row-right">
        <div class="era-pill">${Songs.length} Songs</div>
        <svg class="era-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6,9 12,15 18,9"/></svg>
      </div>`;

    const Panel = document.createElement('div');
    Panel.className = 'songs-panel';
    const Inner = document.createElement('div');
    Inner.className = 'songs-inner';

    Row.onclick = () => {
      const IsOpen = Panel.classList.contains('open');
      document.querySelectorAll('.songs-panel.open').forEach(P => {
        P.classList.remove('open');
        P.closest('.era-wrap').querySelector('.era-row').classList.remove('active');
      });
      if (!IsOpen) {
        Panel.classList.add('open');
        Row.classList.add('active');
        if (!Inner.dataset.loaded) {
          Inner.dataset.loaded = '1';
          Songs.forEach(([Name, Quality, Length, Url, Notes], I) => {
            const HasNote = Notes && Notes.trim().length > 0;
            const HasUrl = Url && Url.trim().length > 0;

            const El = document.createElement(HasUrl ? 'a' : 'div');
            El.className = 'song-item' + (!HasUrl ? ' no-link' : '') + (HasNote ? ' has-note' : '');
            if (HasUrl) {
              El.href = Url;
              El.target = '_blank';
              El.rel = 'noopener noreferrer';
            }

            El.innerHTML = `
              <div class="song-num">${I + 1}</div>
              <div class="song-name" title="${Name.replace(/"/g, '&quot;')}">${Name}</div>
              ${Quality ? `<div class="song-quality ${QClass(Quality)}">${Quality}</div>` : ''}
              <div class="song-len">${Length}</div>
              ${HasUrl ? `<div class="ext-icon"><svg viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" fill="none"><path d="M18 13v6a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h6"/><polyline points="15,3 21,3 21,9"/><line x1="10" y1="14" x2="21" y2="3"/></svg></div>` : '<div class="ext-icon"></div>'}
              ${HasNote ? '<div class="note-toggle">+</div>' : ''}`;

            if (HasNote) {
              const NoteEl = document.createElement('div');
              NoteEl.className = 'song-note';
              NoteEl.textContent = Notes;
              const Toggle = El.querySelector('.note-toggle');
              Toggle.addEventListener('click', (Ev) => {
                Ev.preventDefault();
                Ev.stopPropagation();
                const IsExp = El.classList.toggle('expanded');
                Toggle.textContent = IsExp ? '-' : '+';
              });
              Inner.appendChild(El);
              Inner.appendChild(NoteEl);
            } else {
              Inner.appendChild(El);
            }
          });
        }
        setTimeout(() => Row.scrollIntoView({ behavior: 'smooth', block: 'nearest' }), 50);
      }
    };

    Panel.appendChild(Inner);
    Wrap.appendChild(Row);
    Wrap.appendChild(Panel);
    List.appendChild(Wrap);
  });
}

let SearchTimer;
function OnSearch(Val) {
  clearTimeout(SearchTimer);
  SearchTimer = setTimeout(() => RenderEras(AllData, Val), 120);
}

function ShowLoadError(Msg) {
  document.getElementById('era-list').innerHTML = `<div class="no-results" style="color:#c0392b">${Msg}</div>`;
}

(async () => {
  try {
    const Csv = await FetchSheet();
    AllData = BuildDataFromRows(ParseCsv(Csv));
    RenderEras(AllData);
  } catch (Err) {
    console.error('Failed to load sheet data:', Err);
    ShowLoadError('failed to load data — check sheet permissions');
  }
})();
