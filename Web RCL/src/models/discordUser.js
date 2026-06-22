const pool = require('./db');

async function findById(id) {
  const [rows] = await pool.query('SELECT * FROM discord_users WHERE id = ?', [id]);
  return rows[0] || null;
}

async function findByDiscordId(discordId) {
  const [rows] = await pool.query('SELECT * FROM discord_users WHERE discord_id = ?', [discordId]);
  return rows[0] || null;
}

async function upsert({ discord_id, username, avatar, access_token, refresh_token }) {
  await pool.query(
    `INSERT INTO discord_users (discord_id, username, avatar, access_token, refresh_token)
     VALUES (?, ?, ?, ?, ?)
     ON DUPLICATE KEY UPDATE
       username      = VALUES(username),
       avatar        = VALUES(avatar),
       access_token  = VALUES(access_token),
       refresh_token = VALUES(refresh_token),
       updated_at    = CURRENT_TIMESTAMP`,
    [discord_id, username, avatar, access_token, refresh_token]
  );
  return findByDiscordId(discord_id);
}

module.exports = { findById, findByDiscordId, upsert };
