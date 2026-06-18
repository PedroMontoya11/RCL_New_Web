function slugChampion(name = '') {
  return name
    .toLowerCase()
    .normalize('NFD')
    .replace(/[\u0300-\u036f]/g, '')
    .replace(/[^a-z0-9]/g, '');
}

function teamLogo(name = '') {
  if (!name) return '/assets/img/liga.png';

  const slug = name
    .trim()
    .toLowerCase()
    .normalize('NFD')
    .replace(/[\u0300-\u036f]/g, '')
    .replace(/\s+/g, '-');

  const logos = {
    'draconis-aeterni': '/assets/img/draconis-aeterni.png', 
    'fnix': '/assets/img/fnix.png',
    'hold-the-nexus': '/assets/img/hold-the-nexus.png',
    'kaos': '/assets/img/kaos.png',
    'mezkos-esports': '/assets/img/mezkos-esports.png',
    'nortenos': '/assets/img/nortenos.png',
    'panda-kensei': '/assets/img/panda-kensei.png',
    'planar-shock-pingus': '/assets/img/planar-shock-pingus.png',
    'ultimate-morenos': '/assets/img/ultimate-morenos.png',
    'vdk-abyssal': '/assets/img/vdk-abyssal.png',
    'brotes': '/assets/img/brotes.png',
    'fnix-nest': '/assets/img/fnix-nest.png',
    'la-divina-papaya': '/assets/img/la-divina-papaya.png',
    'los-restos': '/assets/img/los-restos.png',
    'nortenos-vikings': '/assets/img/nortenos-vikings.png',
    'paraselene': '/assets/img/paraselene.png',
    'seal': '/assets/img/seal.png',
    'troncos': '/assets/img/troncos.png',
  };

  return logos[slug] || '/assets/img/liga.png';
}

function roleIcon(role = '') {
  const map = {
    Top: '/assets/img/TOP.webp',
    Jungla: '/assets/img/JUNGLE.webp',
    Mid: '/assets/img/MID.webp',
    ADC: '/assets/img/ADC.webp',
    Support: '/assets/img/SUPP.webp',
    Polivalente: '/assets/img/FILL.webp'
  };
  return map[role] || '/assets/img/liga.png';
}

function teamClass(name = '', fallback = '') {
  const slug = name
    .trim()
    .toLowerCase()
    .normalize('NFD')
    .replace(/[\u0300-\u036f]/g, '')
    .replace(/\s+/g, '-');

  const map = {
    'draconis-aeterni': 'text-dra', 
    'fnix': 'text-fnx',
    'hold-the-nexus': 'text-htn',
    'kaos': 'text-kaos',
    'mezkos-esports': 'text-mezkos',
    'nortenos': 'text-nortenos',
    'planar-shock-pingus': 'text-psp',    
    'ultimate-morenos': 'text-ums',
    'vdk-abyssal': 'text-vda',
    'brotes': 'text-brotes',
    'fnix-nest': 'text-nest',
    'la-divina-papaya': 'text-ldp',
    'los-restos': 'text-res',
    'nortenos-vikings': 'text-nvk',
    'paraselene': 'text-sps',
    'seal': 'text-seal',
    'troncos': 'text-tro'
  };

  return map[slug] || fallback || ''; // ? aquí estaba el fallo
}

function jornadaRange(numJornada, start = '2026-02-02', daysPerJornada = 7) {
  const inicioLiga = new Date(`${start}T00:00:00`);
  const inicio = new Date(inicioLiga);
  inicio.setDate(inicioLiga.getDate() + ((numJornada - 1) * daysPerJornada));
  const fin = new Date(inicio);
  fin.setDate(inicio.getDate() + (daysPerJornada - 1));
  return { inicio, fin };
}

function formatDM(value) {
  const n = Number(value || 0);
  return n > 0 ? `+${n}` : `${n}`;
}

module.exports = { slugChampion, teamLogo, roleIcon, teamClass, jornadaRange, formatDM };