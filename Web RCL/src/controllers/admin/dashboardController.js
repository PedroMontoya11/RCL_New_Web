function dashboard(req, res) {
  res.render('pages/admin/index', { title: 'Panel Admin' });
}

module.exports = { dashboard };
