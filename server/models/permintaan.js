const Sequelize = require('sequelize');
module.exports = function(sequelize, DataTypes) {
  return sequelize.define('permintaan', {
    idpermintaan: {
      autoIncrement: true,
      type: DataTypes.INTEGER,
      allowNull: false,
      primaryKey: true
    },
    keterangan: {
      type: DataTypes.STRING(1028),
      allowNull: false
    },
    kategori: {
      type: DataTypes.STRING(24),
      allowNull: false
    },
    due_date: {
      type: DataTypes.DATEONLY,
      allowNull: false
    },
    created: {
      type: DataTypes.DATE,
      allowNull: false
    },
    edited: {
      type: DataTypes.DATE,
      allowNull: true
    },
    flag_selesai: {
      type: DataTypes.INTEGER,
      allowNull: false
    },
    idpengguna: {
      type: DataTypes.INTEGER,
      allowNull: false,
      primaryKey: true,
      references: {
        model: 'pengguna',
        key: 'idpengguna'
      }
    },
    keterangan_selesai: {
      type: DataTypes.STRING(1028),
      allowNull: true
    },
    idpengguna_close_permintaan: {
      type: DataTypes.INTEGER,
      allowNull: true
    }
  }, {
    sequelize,
    tableName: 'permintaan',
    timestamps: false,
    indexes: [
      {
        name: "PRIMARY",
        unique: true,
        using: "BTREE",
        fields: [
          { name: "idpermintaan" },
          { name: "idpengguna" },
        ]
      },
      {
        name: "fk_permintaan_pengguna_idx",
        using: "BTREE",
        fields: [
          { name: "idpengguna" },
        ]
      },
    ]
  });
};
