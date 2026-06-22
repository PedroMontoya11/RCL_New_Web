function discordCallback(req, res) {
  res.redirect('/');
}

function authError(req, res) {
  res.render('pages/auth-error', { title: 'Acceso denegado' });
}

function logout(req, res, next) {
  req.logout((err) => {
    if (err) return next(err);
    res.redirect('/');
  });
}

module.exports = { discordCallback, authError, logout };
