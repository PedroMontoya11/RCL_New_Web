const router = require('express').Router();
const controller = require('../controllers/publicController');
const pickemController = require('../controllers/pickemController');
const requireDiscordAuth = require('../middleware/requireDiscordAuth');

router.get('/', controller.home);
router.get('/index', controller.home);
router.get('/clasificacion', controller.clasificacion);
router.get('/calendario', controller.calendario);
router.get('/equipos', controller.equipos);
router.get('/equipos/:id', controller.equipoDetalle);
router.get('/jugadores', controller.jugadores);
router.get('/campeones', controller.campeones);
router.get('/api/jugadores/:id/resumen', controller.jugadorResumen);
router.get('/fails', controller.fails);
router.get('/playoffs', controller.playoffs);
router.get('/pickem', pickemController.page);
router.post('/pickem', requireDiscordAuth, pickemController.submit);
router.post('/pickem/bonus', requireDiscordAuth, pickemController.submitBonus);

module.exports = router;
