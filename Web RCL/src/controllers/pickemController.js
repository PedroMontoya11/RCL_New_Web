const db = require('../models/db');
const pickemModel = require('../models/pickem');
const { teamLogo, slugChampion } = require('../helpers/league');

const BONUS_QUESTIONS = [
  { id: 1, label: 'Jugador con mejor KDA de Playoffs',    type: 'player',   icon: '⚔️' },
  { id: 2, label: 'Campeón con más Winrate en Playoffs',  type: 'champion', icon: '📈' },
  { id: 3, label: 'Campeón más pickeado en Playoffs',     type: 'champion', icon: '🏹' },
  { id: 4, label: 'Campeón más baneado en Playoffs',      type: 'champion', icon: '🚫' },
  { id: 5, label: 'Jugador con más Kills en Playoffs',    type: 'player',   icon: '💀' },
];

async function page(req, res, next) {
  try {
    const [jornadaIdCols] = await db.query(`SHOW COLUMNS FROM partidos LIKE 'jornada_id'`);
    const joinPartidos = jornadaIdCols.length
      ? 'LEFT JOIN partidos p ON p.jornada_id = j.id'
      : 'LEFT JOIN partidos p ON p.equipo1_id = j.local_id AND p.equipo2_id = j.visitante_id AND p.fecha = j.fecha';

    const [matches] = await db.query(`
      SELECT
        j.id            AS jornada_id,
        j.jornada,
        j.fase_playoff,
        j.fecha,
        j.hora,
        el.id_equipo    AS local_id,
        el.nombre       AS local,
        ev.id_equipo    AS visitante_id,
        ev.nombre       AS visitante,
        p.ganador_id,
        p.resultado,
        COALESCE(TIMESTAMP(j.fecha, j.hora), j.fecha) < NOW() AS is_locked
      FROM jornadas j
      JOIN equipos el ON j.local_id     = el.id_equipo
      JOIN equipos ev ON j.visitante_id = ev.id_equipo
      ${joinPartidos}
      WHERE el.division = 'Primera' AND ev.division = 'Primera'
      ORDER BY j.jornada ASC, j.fecha ASC, j.hora ASC, j.id ASC
    `);

    let userPredictions = {};
    if (req.user) {
      const preds = await pickemModel.findByUser(req.user.id);
      for (const p of preds) {
        userPredictions[p.jornada_id] = p.equipo_id;
      }
    }

    const PLAYOFF_TEAMS = ['Planar Shock Pingus', 'Mezkos Esports', 'Panda-Kensei', 'Ultimate Morenos'];
    const teamPlaceholders = PLAYOFF_TEAMS.map(() => '?').join(',');
    const [playerRows] = await db.query(`
      SELECT j.id, j.nombre_usuario, e.nombre AS equipo
      FROM jugadores j
      JOIN equipos e ON e.id_equipo = j.equipo_id
      WHERE e.nombre IN (${teamPlaceholders})
      ORDER BY e.nombre ASC, j.nombre_usuario ASC
    `, PLAYOFF_TEAMS);
    const [champRows] = await db.query(
      'SELECT DISTINCT nombre FROM picks_equipos ORDER BY nombre ASC'
    );
    const bonusChampions = champRows.map(c => c.nombre);

    let userBonusPredictions = {};
    if (req.user) {
      const bonusPreds = await pickemModel.findBonusByUser(req.user.id);
      for (const p of bonusPreds) {
        userBonusPredictions[p.question_id] = p.answer;
      }
    }

    const grupos = {};
    const gruposOrder = [];
    for (const m of matches) {
      const key = m.fase_playoff ? m.fase_playoff : String(m.jornada);
      if (!grupos[key]) {
        grupos[key] = [];
        gruposOrder.push(key);
      }
      grupos[key].push(m);
    }

    const hasOpenMatches = matches.some(m => !m.is_locked);

    res.render('pages/pickem', {
      title: "Pick'Em",
      grupos,
      gruposOrder,
      userPredictions,
      hasOpenMatches,
      teamLogo,
      slugChampion,
      bonusQuestions: BONUS_QUESTIONS,
      bonusPlayers: playerRows,
      bonusChampions,
      userBonusPredictions,
      saved: req.query.saved === '1',
    });
  } catch (err) { next(err); }
}

async function submit(req, res, next) {
  try {
    const predictions = req.body.predictions || {};
    const jornadaIds = Object.keys(predictions).map(k => Number(k.replace(/^j/, ''))).filter(Boolean);
    if (!jornadaIds.length) return res.redirect('/pickem');

    const placeholders = jornadaIds.map(() => '?').join(',');
    const [matches] = await db.query(
      `SELECT id, COALESCE(TIMESTAMP(fecha, hora), fecha) < NOW() AS is_locked
       FROM jornadas WHERE id IN (${placeholders})`,
      jornadaIds
    );
    const lockedSet = new Set(matches.filter(m => m.is_locked).map(m => m.id));

    for (const [jornadaIdStr, equipoIdStr] of Object.entries(predictions)) {
      const jornadaId = Number(jornadaIdStr.replace(/^j/, ''));
      const equipoId  = Number(equipoIdStr);
      if (!jornadaId || !equipoId) continue;
      if (lockedSet.has(jornadaId)) continue;
      await pickemModel.upsertPrediction(req.user.id, jornadaId, equipoId);
    }

    res.redirect('/pickem?saved=1');
  } catch (err) { next(err); }
}

async function submitBonus(req, res, next) {
  try {
    const bonus = req.body.bonus || {};
    const validIds = new Set([1, 2, 3, 4, 5]);
    for (const [qIdStr, answer] of Object.entries(bonus)) {
      const qId = Number(qIdStr.replace(/^q/, ''));
      if (!validIds.has(qId) || !answer || !String(answer).trim()) continue;
      await pickemModel.upsertBonusPrediction(req.user.id, qId, String(answer).trim());
    }
    res.redirect('/pickem?saved=1&tab=bonus');
  } catch (err) { next(err); }
}

module.exports = { page, submit, submitBonus };
