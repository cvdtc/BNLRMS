module.exports = function (sequelize, DataTypes) {
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
    flag_selesai: {
      type: DataTypes.TINYINT,
      allowNull: false
    },
    idpengguna: {
      type: DataTypes.INTEGER,
      allowNull: false,
    }
  });
};
