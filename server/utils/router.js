require('dotenv').config()
const jwt = require('jsonwebtoken')
const express = require('express')
const router = express.Router()
global.refreshTokens = []

// ! Login
var RouteToLogin = require('../controllers/login.controller')
router.post('/login', function (req, res) {
    RouteToLogin.Login(req, res)
})
router.post('/newtoken', function (req, res) {
    RouteToLogin.GenerateNewToken(req, res)
})

// ! PENGGUNA
var RouteToPengguna = require('../controllers/pengguna.controller')
router.get('/pengguna', function (req, res) {
    RouteToPengguna.getAllPengguna(req, res)
})
router.post('/pengguna', function (req, res) {
    RouteToPengguna.addPengguna(req, res)
})
router.put('/pengguna', function (req, res) {
    RouteToPengguna.ubahPengguna(req, res)
})

// ! PERMINTAAN / REQUEST
var RouteToPermintaan = require('../controllers/permintaan.controller')
router.get('/permintaan/:tanggal_awal/:tanggal_akhir/:keyword', function (req, res) {
    RouteToPermintaan.getAllPermintaan(req, res)
})
router.post('/permintaan', function (req, res) {
    RouteToPermintaan.addPermintaan(req, res)
})
router.put('/permintaan/:idpermintaan', function (req, res) {
    RouteToPermintaan.ubahPermintaan(req, res)
})
router.delete('/permintaan/:idpermintaan', function (req, res) {
    RouteToPermintaan.deletePermintaan(req, res)
})

// ! PROGRESS
var RouteToProgress = require('../controllers/progress.controller')
router.get('/progress', function (req, res) {
    RouteToProgress.getAllProgress(req, res)
})
router.post('/progress', function (req, res) {
    RouteToProgress.addProgress(req, res)
})
router.put('/progress/:idprogress', function (req, res) {
    RouteToProgress.ubahProgress(req, res)
})
router.delete('/progress/:idprogress', function (req, res) {
    RouteToProgress.deleteProgress(req, res)
})

// ! NOTE
var RouteToNote = require('../controllers/note.controller')
router.get('/note/:filter', function (req, res) {
    RouteToNote.getAllNote(req, res)
})
router.post('/note', function (req, res) {
    RouteToNote.addNote(req, res)
})
router.put('/note/:idnote', function (req, res) {
    RouteToNote.ubahNote(req, res)
})
router.delete('/note/:idnote', function (req, res) {
    RouteToNote.deleteNote(req, res)
})

// ! REPORT
var RouteToReport = require('../controllers/report.controller')
router.get('/timeline/:idpermintaan', function (req, res) {
    RouteToReport.getTimeline(req, res)
});
router.get('/dashboard', function (req, res) {
    RouteToReport.getDashboard(req, res)
});

module.exports = router