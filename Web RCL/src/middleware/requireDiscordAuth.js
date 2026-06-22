module.exports = function requireDiscordAuth(req, res, next) {
  if (!req.isAuthenticated()) {
    return res.redirect('/auth/discord');
  }
  next();
};
