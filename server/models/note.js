const Sequelize = require('sequelize');
module.exports = function(sequelize, DataTypes) {
  return sequelize.define('note', {
    idnote: {
      type: DataTypes.INTEGER,
      allowNull: false,
      primaryKey: true
    },
    keterangan: {
      type: DataTypes.STRING(2048),
      allowNull: false
    },
    created: {
      type: DataTypes.DATE,
      allowNull: false
    },
    flag_selesai: {
      type: DataTypes.TINYINT,
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
    }
  }, {
    sequelize,
    tableName: 'note',
    timestamps: false,
    indexes: [
      {
        name: "PRIMARY",
        unique: true,
        using: "BTREE",
        fields: [
          { name: "idnote" },
          { name: "idpengguna" },
        ]
      },
      {
        name: "fk_note_pengguna1_idx",
        using: "BTREE",
        fields: [
          { name: "idpengguna" },
        ]
      },
    ]
  });
};
