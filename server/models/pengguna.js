
const PenggunaModel = (sequelize, DataTypes) => {
  const penggunaField = sequelize.define('pengguna', {
    idpengguna: {
      autoIncrement: true,
      type: DataTypes.INTEGER,
      allowNull: false,
      primaryKey: true
    },
    nama: {
      type: DataTypes.STRING(24),
      allowNull: false
    },
    username: {
      type: DataTypes.STRING(12),
      allowNull: false
    },
    password: {
      type: DataTypes.STRING(256),
      allowNull: false
    },
    jabatan: {
      type: DataTypes.STRING(12),
      allowNull: false
    },
    notification_token: {
      type: DataTypes.STRING(512),
      allowNull: true
    },
    aktif: {
      type: DataTypes.INTEGER,
      allowNull: false
    },
    last_login: {
      type: DataTypes.DATE,
      allowNull: false
    },
    created: {
      type: DataTypes.DATE,
      allowNull: true
    },
    edited: {
      type: DataTypes.DATE,
      allowNull: true
    },
    sales: {
      type: DataTypes.STRING,
      allowNull: true
    }
  });
  return penggunaField
};

module.exports = PenggunaModel
