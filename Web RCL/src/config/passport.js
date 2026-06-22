const passport = require('passport');
const DiscordStrategy = require('passport-discord').Strategy;
const discordUser = require('../models/discordUser');

passport.serializeUser((user, done) => {
  done(null, user.id);
});

passport.deserializeUser(async (id, done) => {
  try {
    const user = await discordUser.findById(id);
    done(null, user || false);
  } catch (err) {
    done(err);
  }
});

passport.use(new DiscordStrategy(
  {
    clientID:     process.env.DISCORD_CLIENT_ID,
    clientSecret: process.env.DISCORD_CLIENT_SECRET,
    callbackURL:  process.env.DISCORD_CALLBACK_URL,
    scope:        ['identify', 'guilds'],
  },
  async (accessToken, refreshToken, profile, done) => {
    try {
      const isMember = profile.guilds?.some(g => g.id === process.env.DISCORD_GUILD_ID);
      if (!isMember) {
        return done(null, false, { message: 'No perteneces al servidor de Discord de la liga.' });
      }

      const user = await discordUser.upsert({
        discord_id:    profile.id,
        username:      profile.username,
        avatar:        profile.avatar,
        access_token:  accessToken,
        refresh_token: refreshToken || null,
      });

      return done(null, user);
    } catch (err) {
      return done(err);
    }
  }
));

module.exports = passport;
