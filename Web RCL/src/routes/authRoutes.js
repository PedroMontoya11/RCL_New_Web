const router = require('express').Router();
const passport = require('passport');
const authController = require('../controllers/authController');

router.get('/discord', passport.authenticate('discord'));

router.get(
  '/discord/callback',
  passport.authenticate('discord', { failureRedirect: '/auth/error' }),
  authController.discordCallback
);

router.get('/error', authController.authError);

router.get('/logout', authController.logout);

module.exports = router;
