module.exports = function (sequelize, DataTypes) {
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
    },
    idpermintaan: {
      type: DataTypes.INTEGER,
      allowNull: false,
    },
    created: {
      type: DataTypes.DATE,
      allowNull: true
    },
    edited: {
      type: DataTypes.DATE,
      allowNull: true
    },
    url_web: {
      type: DataTypes.STRING,
      allowNull: true
    },
  });
};
