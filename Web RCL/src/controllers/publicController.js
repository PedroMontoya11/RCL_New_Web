const db = require('../models/db');
const { slugChampion, teamLogo, roleIcon, teamClass, jornadaRange, formatDM } = require('../helpers/league');

function getDivision(req) {
  return req.query.division === 'Segunda' ? 'Segunda' : 'Primera';
}

async function home(req, res, next) {
  try {
    res.render('pages/index', {
      title: 'Rift Champions League',
      featuredVideos: [
        { file: 'Penta de lGengisK.mp4', title: 'Penta de lGengisK' },
        { file: 'Penta de Kento.mp4', title: 'Penta de Kento' },
        { file: 'Penta de TheConito.mp4', title: 'Penta de TheConito' }
      ]
    });
  } catch (error) { next(error); }
}

async function clasificacion(req, res, next) {
  try {
    const division = getDivision(req);
    const [rows] = await db.query(`
      SELECT id_equipo, nombre, victorias, derrotas, diferencia_mapas, division
      FROM equipos
      WHERE division = ?
      ORDER BY victorias DESC, derrotas ASC, diferencia_mapas DESC, nombre ASC
    `, [division]);

    res.render('pages/clasificacion', {
      title: 'Clasificación',
      equipos: rows,
      division,
      teamClass,
      formatDM
    });
  } catch (error) { next(error); }
}

async function calendario(req, res, next) {
  try {
    const division = getDivision(req);
    const [jornadaIdColumns] = await db.query(`SHOW COLUMNS FROM partidos LIKE 'jornada_id'`);
    const partidosJoin = jornadaIdColumns.length
      ? 'LEFT JOIN partidos p ON p.jornada_id = j.id'
      : `LEFT JOIN partidos p ON p.equipo1_id = j.local_id AND p.equipo2_id = j.visitante_id
        AND p.fecha = j.fecha`;

    const [rows] = await db.query(`
      SELECT
        j.id AS jornada_id,
        j.jornada,
        j.fase_playoff,
        el.nombre AS local,
        ev.nombre AS visitante,
        j.fecha,
        j.hora,
        p.ganador_id,
        p.resultado,
        el.id_equipo AS local_id,
        ev.id_equipo AS visitante_id,
        el.division
      FROM jornadas j
      JOIN equipos el ON j.local_id = el.id_equipo
      JOIN equipos ev ON j.visitante_id = ev.id_equipo
      ${partidosJoin}
      WHERE el.division = ? AND ev.division = ?
      ORDER BY j.jornada ASC, j.fecha ASC, j.hora ASC, j.id ASC
    `, [division, division]);

    const calendario = {};
    const playoffsPorFase = {};
    let maxRegularSeason = 0;

    for (const row of rows) {
      const jornada = Number(row.jornada);
      if (row.fase_playoff) {
        const fase = row.fase_playoff || 'Sin fase';
        if (!playoffsPorFase[fase]) playoffsPorFase[fase] = [];
        playoffsPorFase[fase].push(row);
        continue;
      }

      maxRegularSeason = Math.max(maxRegularSeason, jornada);
      if (!calendario[jornada]) calendario[jornada] = [];
      calendario[jornada].push(row);
    }

    for (let i = 1; i <= maxRegularSeason; i++) {
      if (!calendario[i]) calendario[i] = [];
    }

    res.render('pages/calendario', {
      title: 'Calendario',
      calendario,
      playoffsPorFase,
      division,
      maxRegularSeason,
      jornadaRange,
      teamLogo
    });
  } catch (error) { next(error); }
}

async function equipos(req, res, next) {
  try {
    const division = getDivision(req);
    const [equipos] = await db.query(`
      SELECT id_equipo, nombre, class_color, division
      FROM equipos
      WHERE division = ?
      ORDER BY nombre ASC
    `, [division]);

    res.render('pages/equipos-list', {
      title: 'Equipos',
      equipos,
      division,
      teamLogo
    });
  } catch (error) { next(error); }
}

async function equipoDetalle(req, res, next) {
  try {
    const id = Number(req.params.id);

    const [[equipo]] = await db.query(`
      SELECT id_equipo, nombre, division
      FROM equipos
      WHERE id_equipo = ?
    `, [id]);

    if (!equipo) {
      return res.status(404).render('pages/404', { title: 'Equipo no encontrado' });
    }

    const [jugadores] = await db.query(`
      SELECT id, nombre_usuario, riot_tag, rol, capi
      FROM jugadores
      WHERE equipo_id = ?
      ORDER BY FIELD(rol, 'Top', 'Jungla', 'Mid', 'ADC', 'Support', 'Polivalente'), nombre_usuario ASC
    `, [id]);

    const [champions] = await db.query(`
      SELECT
        nombre,
        COUNT(*) AS total,
        SUM(win) AS victorias,
        ROUND((SUM(win) / COUNT(*)) * 100, 2) AS wr
      FROM picks_equipos
      WHERE id_equipo = ?
      GROUP BY nombre
      HAVING total >= 2 AND (SUM(win) / COUNT(*)) >= 0.5
      ORDER BY wr DESC, total DESC, nombre ASC
      LIMIT 6
    `, [id]);

    const opggLink = jugadores.length
      ? `https://op.gg/es/lol/multisearch/euw?summoners=${jugadores.map((j) => encodeURIComponent(`${j.nombre_usuario}${j.riot_tag}`.trim())).join(',')}`
      : null;

    res.render('pages/equipo-detalle', {
      title: equipo.nombre,
      equipo,
      jugadores,
      champions,
      opggLink,
      teamLogo,
      roleIcon,
      slugChampion
    });
  } catch (error) { next(error); }
}

async function jugadores(req, res, next) {
  try {
    const sortOption = req.query.sort || 'kda';
    const order = req.query.order === 'asc' ? 'asc' : 'desc';
    const role = req.query.role || '';
    const team = req.query.team || '';
    const division = getDivision(req);

    const orderMap = {
      kda: 'kda',
      cs: 'cs_min',
      dmg: 'dmg_min',
      winrate: 'winrate',
      mvp: 'total_mvps'
    };

    const column = orderMap[sortOption] || orderMap.kda;
    const orderBy = `${column} ${order.toUpperCase()}, mapas DESC`;

    // Construcción dinámica del WHERE
    const where = ['e.division = ?'];
    const queryParams = [division];

    if (role) {
        where.push('j.rol = ?');
        queryParams.push(role);
    }

    if (team) {
        where.push('e.nombre = ?');
        queryParams.push(team);
    }

    const [ranking] = await db.query(`
      SELECT
        j.id,
        j.nombre_usuario,
        j.riot_tag,
        e.nombre AS equipo,
        e.division,
        j.rol,
        COUNT(*) AS mapas,
        COALESCE(SUM(m.mvp), 0) AS total_mvps,
        ROUND(
          AVG(
            CASE
              WHEN m.deaths = 0
              THEN m.kills + m.assists
              ELSE (m.kills + m.assists) / m.deaths
            END
          ), 2
        ) AS kda,
        ROUND(SUM(m.cs) / SUM(m.duracion_min), 2) AS cs_min,
        ROUND(SUM(m.dmg) / SUM(m.duracion_min), 2) AS dmg_min,
        ROUND((SUM(m.win) / COUNT(*)) * 100, 2) AS winrate
      FROM jugadores j
      JOIN equipos e ON j.equipo_id = e.id_equipo
      JOIN match_stats m ON j.id = m.id_jugador
      WHERE ${where.join(' AND ')}
      GROUP BY
        j.id,
        j.nombre_usuario,
        j.riot_tag,
        j.rol,
        e.nombre,
        e.division
      ORDER BY ${orderBy}
    `, queryParams);

    const [[topPick]] = await db.query(`
      SELECT pe.nombre, COUNT(*) AS total, SUM(pe.win) AS victorias
      FROM picks_equipos pe
      JOIN equipos e ON e.id_equipo = pe.id_equipo
      WHERE e.division = ?
      GROUP BY pe.nombre
      ORDER BY total DESC, pe.nombre ASC
      LIMIT 1
    `, [division]);

    const [[sides]] = await db.query(`
      SELECT
        SUM(CASE WHEN m.lado = 'Azul' AND m.win = 1 THEN 1 ELSE 0 END) AS victorias_azul,
        SUM(CASE WHEN m.lado = 'Rojo' AND m.win = 1 THEN 1 ELSE 0 END) AS victorias_rojo,
        SUM(m.win) AS total_victorias
      FROM match_stats m
      JOIN jugadores j ON j.id = m.id_jugador
      JOIN equipos e ON e.id_equipo = j.equipo_id
      WHERE e.division = ?
    `, [division]);

    const [equipos] = await db.query(`
      SELECT nombre
      FROM equipos
      WHERE division = ?
      ORDER BY nombre ASC
    `, [division]);

    const totalWins = Number(sides?.total_victorias || 0);
    const blueWR = totalWins
      ? Number(((Number(sides.victorias_azul || 0) / totalWins) * 100).toFixed(2))
      : 0;

    const redWR = totalWins
      ? Number(((Number(sides.victorias_rojo || 0) / totalWins) * 100).toFixed(2))
      : 0;

    res.render('pages/jugadores', {
      title: 'Jugadores',
      ranking,
      equipos,
      sortOption,
      order,
      role,
      team,
      division,
      topPick,
      blueWR,
      redWR,
      slugChampion,
      roleIcon,
      teamLogo
    });
  } catch (error) {
    next(error);
  }
}

async function campeones(req, res, next) {
  try {
    const division = getDivision(req);
    const sort = req.query.sort || 'nombre';

    const orderMap = {
      nombre: 'pe.nombre ASC',
      winrate: 'winrate DESC, partidas DESC, pe.nombre ASC',
      partidas: 'partidas DESC, winrate DESC, pe.nombre ASC'
    };

    const orderBy = orderMap[sort] || orderMap.nombre;

    const [champions] = await db.query(`
      SELECT
        pe.nombre,
        COUNT(*) AS partidas,
        SUM(pe.win) AS victorias,
        COUNT(*) - SUM(pe.win) AS derrotas,
        ROUND((SUM(pe.win) / COUNT(*)) * 100, 2) AS winrate
      FROM picks_equipos pe
      JOIN equipos e ON e.id_equipo = pe.id_equipo
      WHERE e.division = ?
      GROUP BY pe.nombre
      ORDER BY ${orderBy}
    `, [division]);

res.render('pages/campeones', 
{
  title: 'Campeones',
  champions,
  division,
  sort,
  slugChampion
});
  } catch (error) {
    next(error);
  }
}
async function jugadorResumen(req, res, next) {
  try {
    const id = Number(req.params.id);
    const [[player]] = await db.query(`
      SELECT
        j.id,
        j.nombre_usuario,
        j.riot_tag,
        j.rol,
        e.nombre AS equipo,
        e.division,
        COUNT(m.id_jugador) AS mapas,
        COALESCE(SUM(m.mvp), 0) AS mvps,
        COALESCE(ROUND(AVG(CASE WHEN m.id_jugador IS NULL THEN NULL WHEN m.deaths = 0 THEN m.kills + m.assists ELSE (m.kills + m.assists) / m.deaths END), 2), 0) AS kda,
        ROUND(SUM(m.cs) / IF(SUM(m.duracion_min) = 0, 1, SUM(m.duracion_min)), 2) AS csMin,
        ROUND(SUM(m.dmg) / IF(SUM(m.duracion_min) = 0, 1, SUM(m.duracion_min)), 2) AS dmgMin,
        ROUND((SUM(m.win) / COUNT(m.id_jugador)) * 100, 2) AS winrate
      FROM jugadores j
      JOIN equipos e ON e.id_equipo = j.equipo_id
      LEFT JOIN match_stats m ON m.id_jugador = j.id
      WHERE j.id = ?
      GROUP BY j.id, j.nombre_usuario, j.riot_tag, j.rol, e.nombre, e.division
    `, [id]);

    if (!player) {
      return res.status(404).json({ error: 'Jugador no encontrado' });
    }

    const [champions] = await db.query(`
      SELECT
        campeon,
        COUNT(*) AS partidas,
        SUM(win) AS victorias,
        ROUND((SUM(win) / COUNT(*)) * 100, 2) AS winrate
      FROM match_stats
      WHERE id_jugador = ? AND campeon IS NOT NULL AND campeon <> ''
      GROUP BY campeon
      ORDER BY winrate DESC, partidas DESC, campeon ASC
      LIMIT 6
    `, [id]);

    res.json({
      ...player,
      opggUrl: `https://op.gg/es/lol/summoners/euw/${encodeURIComponent(player.nombre_usuario)}-${encodeURIComponent((player.riot_tag || '').replace('#', ''))}`,
      champions
    });
  } catch (error) { next(error); }
}

async function fails(req, res, next) {
  try {
    res.render('pages/fails', {
      title: 'Fails',
      failVideos: [
        ['Uyy Jax.mp4', '¡Uyy Jax!'],
        ['300 IQ Confundir al Muro.mp4', '300 IQ: Confundir al Muro'],
        ['Déjame abrazarte.mp4', 'Déjame abrazarte :('],
        ['Flash al vacío.mp4', 'Flash al vacío'],
        ['Malphite Jumpscare.mp4', 'Malphite Jumpscare'],
        ['Predict fallido.mp4', 'Predict fallido']
      ],
      topVideos: [
        ['Ornn Resbalón.mp4', 'Ornn Resbalón'],
        ['Pochita farmeando aura.mp4', 'Pochita farmeando aura'],
        ['R al Shaco.mp4', 'R al Shaco'],
	['Ultaca de Seraphine.mp4', 'Ultaca de Seraphine']
      ]
    });
  } catch (error) { next(error); }
}

async function playoffs(req, res, next) {
  try {
    const division = getDivision(req);

    const [rows] = await db.query(`
      SELECT
        j.id,
        j.jornada,
        j.local_id,
        j.visitante_id,
        j.fecha,
        j.hora,
        j.fase_playoff,
        el.nombre AS equipo_local,
        ev.nombre AS equipo_visitante,
        el.division AS division_local,
        ev.division AS division_visitante
      FROM jornadas j
      JOIN equipos el ON el.id_equipo = j.local_id
      JOIN equipos ev ON ev.id_equipo = j.visitante_id
      WHERE j.fase_playoff IS NOT NULL
        AND j.fase_playoff <> ''
        AND el.division = ?
        AND ev.division = ?
      ORDER BY j.fecha ASC, j.hora ASC, j.id ASC
    `, [division, division]);

    const playoffsPorFase = {};

    for (const row of rows) {
      const fase = row.fase_playoff || 'Sin fase';
      if (!playoffsPorFase[fase]) playoffsPorFase[fase] = [];
      playoffsPorFase[fase].push(row);
    }

    res.render('pages/playoffs', {
      title: `Playoffs ${division}`,
      division,
      playoffsPorFase,
      teamLogo
    });
  } catch (error) {
    next(error);
  }
}

module.exports = {
  home,
  clasificacion,
  calendario,
  equipos,
  equipoDetalle,
  jugadores,
  campeones,
  jugadorResumen,
  fails,
  playoffs
};
