require('dotenv').config();
const { Sequelize } = require('sequelize');

const dbConfig = {
    DBHOST: process.env.DB_HOST,
    DBUSER: process.env.DB_USER,
    DBPASSWORD: process.env.DB_PASSWORD,
    DBNAME: process.env.DB_NAME,
    DIALECT: 'mysql',
};

const connectToDB = new Sequelize(
    dbConfig.DBNAME,
    dbConfig.DBUSER,
    dbConfig.DBPASSWORD,
    {
        port: 3306,
        host: dbConfig.DBHOST,
        dialect: dbConfig.DIALECT,
        operatorAliases: false,
        timezone: '+07:00',
        dialectOptions: { useUTC: false, timezone: '+07:00' },
        define: { freezeTableName: true },
    }
);

module.exports = connectToDB 