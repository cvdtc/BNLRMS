var DataTypes = require("sequelize").DataTypes;
var _note = require("./note");
var _pengguna = require("./pengguna");
var _permintaan = require("./permintaan");
var _progress = require("./progress");

function initModels(sequelize) {
  var note = _note(sequelize, DataTypes);
  var pengguna = _pengguna(sequelize, DataTypes);
  var permintaan = _permintaan(sequelize, DataTypes);
  var progress = _progress(sequelize, DataTypes);

  pengguna.belongsToMany(permintaan, { as: 'idpermintaan_permintaans', through: progress, foreignKey: "idpengguna", otherKey: "idpermintaan" });
  permintaan.belongsToMany(pengguna, { as: 'idpengguna_penggunas', through: progress, foreignKey: "idpermintaan", otherKey: "idpengguna" });
  note.belongsTo(pengguna, { as: "idpengguna_pengguna", foreignKey: "idpengguna"});
  pengguna.hasMany(note, { as: "notes", foreignKey: "idpengguna"});
  permintaan.belongsTo(pengguna, { as: "idpengguna_pengguna", foreignKey: "idpengguna"});
  pengguna.hasMany(permintaan, { as: "permintaans", foreignKey: "idpengguna"});
  progress.belongsTo(pengguna, { as: "idpengguna_pengguna", foreignKey: "idpengguna"});
  pengguna.hasMany(progress, { as: "progresses", foreignKey: "idpengguna"});
  progress.belongsTo(permintaan, { as: "idpermintaan_permintaan", foreignKey: "idpermintaan"});
  permintaan.hasMany(progress, { as: "progresses", foreignKey: "idpermintaan"});

  return {
    note,
    pengguna,
    permintaan,
    progress,
  };
}
module.exports = initModels;
module.exports.initModels = initModels;
module.exports.default = initModels;
