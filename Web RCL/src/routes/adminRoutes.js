const router = require('express').Router();
const requireAdmin = require('../middleware/requireAdmin');
const authController = require('../controllers/admin/authController');
const dashboardController = require('../controllers/admin/dashboardController');
const formsController = require('../controllers/admin/formsController');
const dataController = require('../controllers/admin/dataController');

router.get('/login', authController.loginPage);
router.post('/login', authController.login);
router.get('/logout', authController.logout);

router.get('/', requireAdmin, dashboardController.dashboard);
router.get('/picks-equipos', requireAdmin, formsController.picksPage);
router.post('/picks-equipos', requireAdmin, formsController.savePick);
router.get('/match-stats', requireAdmin, formsController.matchStatsPage);
router.post('/match-stats', requireAdmin, formsController.saveMatchStats);
router.get('/info-tablas', requireAdmin, dataController.tableBrowser);

module.exports = router;
