const db = require('../../models/db');

function getDivision(req) {
  return req.query.division === 'Segunda' ? 'Segunda' : 'Primera';
}

async function picksPage(req, res, next) {
  try {
    const division = getDivision(req);
    const [equipos] = await db.query(
      'SELECT id_equipo, nombre, division FROM equipos WHERE division = ? ORDER BY nombre ASC',
      [division]
    );
    res.render('pages/admin/picks-equipos', { title: 'Registrar Pick', equipos, division, mensaje: null });
  } catch (error) { next(error); }
}

async function savePick(req, res, next) {
  try {
    const division = getDivision(req);
    const { id_equipo, nombre_champ, resultado } = req.body;
    await db.query('INSERT INTO picks_equipos (id_equipo, nombre, win) VALUES (?, ?, ?)', [id_equipo, nombre_champ, resultado]);
    const [equipos] = await db.query(
      'SELECT id_equipo, nombre, division FROM equipos WHERE division = ? ORDER BY nombre ASC',
      [division]
    );
    res.render('pages/admin/picks-equipos', {
      title: 'Registrar Pick',
      equipos,
      division,
      mensaje: { type: 'success', text: '¡Pick registrado con éxito!' }
    });
  } catch (error) { next(error); }
}

async function matchStatsPage(req, res, next) {
  try {
    const division = getDivision(req);
    const [jugadores] = await db.query(`
      SELECT j.id, j.nombre_usuario, j.riot_tag, e.nombre AS equipo, e.division
      FROM jugadores j
      JOIN equipos e ON e.id_equipo = j.equipo_id
      WHERE e.division = ?
      ORDER BY j.nombre_usuario ASC
    `, [division]);
    res.render('pages/admin/match-stats', { title: 'Registrar stats', jugadores, division, mensaje: null });
  } catch (error) { next(error); }
}

async function saveMatchStats(req, res, next) {
  try {
    const division = getDivision(req);
    const { id_jugador, campeon, kills, deaths, assists, cs, dmg, duracion_min, lado } = req.body;
    const win = req.body.win ? 1 : 0;
    const mvp = req.body.mvp ? 1 : 0;
    await db.query(
      `INSERT INTO match_stats (id_jugador, campeon, kills, deaths, assists, cs, dmg, duracion_min, lado, win, mvp)
       VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
      [id_jugador, campeon, kills, deaths, assists, cs, dmg, duracion_min, lado, win, mvp]
    );
    const [jugadores] = await db.query(`
      SELECT j.id, j.nombre_usuario, j.riot_tag, e.nombre AS equipo, e.division
      FROM jugadores j
      JOIN equipos e ON e.id_equipo = j.equipo_id
      WHERE e.division = ?
      ORDER BY j.nombre_usuario ASC
    `, [division]);
    res.render('pages/admin/match-stats', {
      title: 'Registrar stats',
      jugadores,
      division,
      mensaje: { type: 'success', text: '¡Estadísticas registradas con éxito!' }
    });
  } catch (error) { next(error); }
}

module.exports = { picksPage, savePick, matchStatsPage, saveMatchStats };
