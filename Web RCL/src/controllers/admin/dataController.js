const db = require('../../models/db');

const allowedTables = ['jugadores', 'equipos', 'match_stats', 'picks_equipos', 'partidos', 'jornadas'];

async function tableBrowser(req, res, next) {
  try {
    const table = allowedTables.includes(req.query.tabla) ? req.query.tabla : 'jugadores';
    const [rows] = await db.query(`SELECT * FROM ${table}`);
    res.render('pages/admin/info-tablas', {
      title: 'Ver tablas',
      allowedTables,
      table,
      rows,
      columns: rows.length ? Object.keys(rows[0]) : []
    });
  } catch (error) { next(error); }
}

module.exports = { tableBrowser, allowedTables };
