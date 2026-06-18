const router = require('express').Router();
const controller = require('../controllers/publicController');

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

module.exports = router;
