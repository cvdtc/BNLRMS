const Sequelize = require('sequelize');
module.exports = function(sequelize, DataTypes) {
  return sequelize.define('progress', {
    idprogress: {
      autoIncrement: true,
      type: DataTypes.INTEGER,
      allowNull: false,
      primaryKey: true
    },
    keterangan: {
      type: DataTypes.STRING(1028),
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
      type: DataTypes.TINYINT,
      allowNull: false
    },
    next_idpengguna: {
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
    idpermintaan: {
      type: DataTypes.INTEGER,
      allowNull: false,
      primaryKey: true,
      references: {
        model: 'permintaan',
        key: 'idpermintaan'
      }
    }
  }, {
    sequelize,
    tableName: 'progress',
    timestamps: false,
    indexes: [
      {
        name: "PRIMARY",
        unique: true,
        using: "BTREE",
        fields: [
          { name: "idprogress" },
          { name: "idpengguna" },
          { name: "idpermintaan" },
        ]
      },
      {
        name: "fk_progress_pengguna1_idx",
        using: "BTREE",
        fields: [
          { name: "idpengguna" },
        ]
      },
      {
        name: "fk_progress_permintaan1_idx",
        using: "BTREE",
        fields: [
          { name: "idpermintaan" },
        ]
      },
    ]
  });
};
