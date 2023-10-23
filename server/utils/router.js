require('dotenv').config();
const jwt = require('jsonwebtoken');
const authToken = require('../middleware/auth.js');
const express = require('express');
const router = express.Router();
global.refreshTokens = [];

// ! Login
var RouteToLogin = require('../controllers/login.controller');
router.post('/login', function (req, res) {
    RouteToLogin.Login(req, res);
});
router.post('/newtoken', function (req, res) {
    RouteToLogin.GenerateNewToken(req, res);
});

// ! PENGGUNA
var RouteToPengguna = require('../controllers/pengguna.controller');
router.get('/pengguna', authToken, RouteToPengguna.getAllPengguna);
router.post('/pengguna', authToken, RouteToPengguna.addPengguna);
router.put('/pengguna/:idpengguna', authToken, RouteToPengguna.ubahPengguna);

// ! PERMINTAAN / REQUEST
var RouteToPermintaan = require('../controllers/permintaan.controller');
router.post('/permintaan', function (req, res) {
    RouteToPermintaan.getAllPermintaan(req, res);
});
router.get('/permintaand', function (req, res) {
    RouteToPermintaan.getAllPermintaanD(req, res);
});
router.post('/addpermintaan', function (req, res) {
    RouteToPermintaan.addPermintaan(req, res);
});
router.post('/addpermintaandanprogress', function (req, res) {
    RouteToPermintaan.addPermintaandanProgress(req, res);
});
router.put('/permintaan/:idpermintaan', function (req, res) {
    RouteToPermintaan.ubahPermintaan(req, res);
});
router.delete('/permintaan/:idpermintaan', function (req, res) {
    RouteToPermintaan.deletePermintaan(req, res);
});

// ! PROGRESS
var RouteToProgress = require('../controllers/progress.controller');
router.get('/progress', authToken, RouteToProgress.getAllProgress);
router.post('/progress', authToken, RouteToProgress.addProgress);
router.put('/progress/:idprogress', authToken, RouteToProgress.ubahProgress);
router.delete(
    '/progress/:idprogress',
    authToken,
    RouteToProgress.deleteProgress
);

// ! NOTE
var RouteToNote = require('../controllers/note.controller');
router.get('/note/:filter', function (req, res) {
    RouteToNote.getAllNote(req, res);
});
router.post('/note', function (req, res) {
    RouteToNote.addNote(req, res);
});
router.put('/note/:idnote', function (req, res) {
    RouteToNote.ubahNote(req, res);
});
router.delete('/note/:idnote', function (req, res) {
    RouteToNote.deleteNote(req, res);
});

// ! REPORT
var RouteToReport = require('../controllers/report.controller');
router.get('/timeline/:idpermintaan', function (req, res) {
    RouteToReport.getTimeline(req, res);
});
router.get('/dashboard', function (req, res) {
    RouteToReport.getDashboard(req, res);
});
router.get('/dashboardmerekinternasional', function (req, res) {
    RouteToReport.getMerekInternasionalDashboard(req, res);
});
router.get('/merekinternasional', function (req, res) {
    RouteToReport.getMerekInternasional(req, res);
});
router.get('/timelinemerekinternasional', function (req, res) {
    RouteToReport.getTimelineMerekInternasional(req, res);
});

module.exports = router;
