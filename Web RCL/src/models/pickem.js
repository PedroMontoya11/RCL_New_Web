const pool = require('./db');

async function findByUser(userId) {
  const [rows] = await pool.query(
    'SELECT jornada_id, equipo_id FROM pickem_predictions WHERE user_id = ?',
    [userId]
  );
  return rows;
}

async function upsertPrediction(userId, jornadaId, equipoId) {
  await pool.query(
    `INSERT INTO pickem_predictions (user_id, jornada_id, equipo_id)
     VALUES (?, ?, ?)
     ON DUPLICATE KEY UPDATE equipo_id = VALUES(equipo_id), updated_at = CURRENT_TIMESTAMP`,
    [userId, jornadaId, equipoId]
  );
}

async function findBonusByUser(userId) {
  const [rows] = await pool.query(
    'SELECT question_id, answer FROM pickem_bonus_predictions WHERE user_id = ?',
    [userId]
  );
  return rows;
}

async function upsertBonusPrediction(userId, questionId, answer) {
  await pool.query(
    `INSERT INTO pickem_bonus_predictions (user_id, question_id, answer)
     VALUES (?, ?, ?)
     ON DUPLICATE KEY UPDATE answer = VALUES(answer), updated_at = CURRENT_TIMESTAMP`,
    [userId, questionId, answer]
  );
}

module.exports = { findByUser, upsertPrediction, findBonusByUser, upsertBonusPrediction };
