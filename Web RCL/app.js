require('dotenv').config();
const path = require('path');
const express = require('express');
const session = require('express-session');
const passport = require('./src/config/passport');

const app = express();
const PORT = process.env.PORT || 3000;

app.set('view engine', 'ejs');
app.set('views', path.join(__dirname, 'src', 'views'));

app.use(express.urlencoded({ extended: true }));
app.use(express.json());
app.use(express.static(path.join(__dirname, 'src', 'public')));
app.use(session({
  secret: process.env.SESSION_SECRET || 'dev-secret-change-me',
  resave: false,
  saveUninitialized: false,
  cookie: { httpOnly: true, sameSite: 'lax' }
}));
app.use(passport.initialize());
app.use(passport.session());

app.use((req, res, next) => {
  res.locals.currentPath = req.path;
  res.locals.adminLoggedIn = !!req.session.adminLoggedIn;
  res.locals.discordUser = req.user || null;
  res.locals.gaMeasurementId = process.env.GA_MEASUREMENT_ID || '';
  next();
});

app.use('/', require('./src/routes/publicRoutes'));
app.use('/admin', require('./src/routes/adminRoutes'));
app.use('/auth', require('./src/routes/authRoutes'));

app.use((req, res) => {
  res.status(404).render('pages/404', { title: '404' });
});

app.use((err, req, res, next) => {
  console.error(err);
  res.status(500).render('pages/500', {
    title: 'Error',
    message: process.env.NODE_ENV === 'production' ? 'Ha ocurrido un error inesperado.' : err.message
  });
});

app.listen(PORT, '0.0.0.0', () => {
  console.log(`Servidor iniciado en http://0.0.0.0:${PORT}`);
});
