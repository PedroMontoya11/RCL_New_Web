async function loginPage(req, res) {
  if (req.session.adminLoggedIn) return res.redirect('/admin');
  res.render('pages/admin/login', { title: 'Login Admin', error: '' });
}

async function login(req, res) {
  const { username, password } = req.body;
  const adminUser = process.env.ADMIN_USER || 'admin';
  const adminPass = process.env.ADMIN_PASS || 'change-me';

  if (username === adminUser && password === adminPass) {
    req.session.adminLoggedIn = true;
    return res.redirect('/admin');
  }

  return res.status(401).render('pages/admin/login', {
    title: 'Login Admin',
    error: 'Acceso denegado. Credenciales incorrectas.'
  });
}

function logout(req, res, next) {
  req.session.destroy((err) => {
    if (err) return next(err);
    res.redirect('/admin/login');
  });
}

module.exports = { loginPage, login, logout };
