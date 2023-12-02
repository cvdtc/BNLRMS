'use strict';
const { Sequelize } = require('sequelize')
const connectToDB = require('../config/index.js')
const PermintaanModel = require('../models/permintaan.js');
const ProgressModel = require('../models/progress.js')
const PenggunaModel = require('../models/pengguna.js')
const NoteModel = require('../models/note.js')

const db = {}


db.Sequelize = Sequelize
db.connectToDB = connectToDB

db.PenggunaModel = PenggunaModel(connectToDB, Sequelize)
db.NoteModel = NoteModel(connectToDB, Sequelize)
db.PermintaanModel = PermintaanModel(connectToDB, Sequelize)
db.ProgressModel = ProgressModel(connectToDB, Sequelize)

// Association
// Permintaan to Progress
db.PermintaanModel.hasMany(db.ProgressModel, { foreignKey: 'idpermintaan' })
db.ProgressModel.belongsTo(db.PermintaanModel, { foreignKey: 'idpermintaan' })
//Pengguna to Permintaan
db.PenggunaModel.hasMany(db.PermintaanModel, { foreignKey: 'idpengguna' })
db.PermintaanModel.belongsTo(db.PenggunaModel, { foreignKey: 'idpengguna' })
//Pengguna to Progress
db.PenggunaModel.hasMany(db.ProgressModel, { foreignKey: 'idpengguna' })
db.ProgressModel.belongsTo(db.PenggunaModel, { foreignKey: 'idpengguna' })

db.connectToDB.sync({ force: false, alter: true })

module.exports = db;
