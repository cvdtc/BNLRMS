module.exports = function (sequelize, DataTypes) {
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
    flag_selesai: {
      type: DataTypes.INTEGER,
      allowNull: false
    },
    idpengguna: {
      type: DataTypes.INTEGER,
      allowNull: false,
      primaryKey: true
    },
    keterangan_selesai: {
      type: DataTypes.STRING(1028),
      allowNull: true
    },
    idpengguna_close_permintaan: {
      type: DataTypes.INTEGER,
      allowNull: true
    },
    url_web: {
      type: DataTypes.STRING,
      allowNull: true
    },
    created: {
      type: DataTypes.DATE,
      allowNull: true
    },
    edited: {
      type: DataTypes.DATE,
      allowNull: true
    },
  });
};
