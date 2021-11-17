//Plugin
require('dotenv').config()
const jwt = require('jsonwebtoken')
const bcrypt = require('bcrypt')
const mysql = require('mysql')

/**
 * ! Pool setting up
 * * pool connection limit 10
 * * queue limit 25
 */

const pool = mysql.createPool({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME,
    port: process.env.DB_PORT,
    connectionLimit: 10,
    queueLimit: 25,
    timezone: 'utc-8'
})

/**
 * @swagger
 * tags:
 *  name: PENGGUNA
 *  description: endpoint API for regenerate access token
 */

/**
 * @swagger
 * components:
 *  securitySchemes:
 *      bearerAuth:
 *          type: http
 *          scheme: bearer
 *          bearerFormat: JWT
 */

// * FUNCTION GET LIST PENGGUNA

/**
 * @swagger
 * /pengguna:
 *  get:
 *      summary: untuk menampilkan semua data pengguna, [header token]
 *      tags: [PENGGUNA]
 *      parameters:
 *          - name: token
 *            in: header
 *            schema:
 *              type: string
 *              description: >
 *                  parameter `token` dikirim di header, token/access token digunakan untuk validasi keamanan API.
 *      security:
 *          - bearerAuth: []
 *      responses:
 *          200:
 *              description: jika data berhasil di fetch
 *          204:
 *              description: jika data yang dicari tidak ada
 *          400:
 *              description: kendala koneksi pool database
 *          401:
 *              description: token tidak valid
 *          500:
 *              description: kesalahan pada query sql
 */

async function getAllPengguna(req, res) {
    const token = req.headers.authorization;
    if (token != null) {     try {
        jwt.verify(token.split(' ')[1], process.env.ACCESS_SECRET, (jwterror, jwtresult) => {
            if (!jwtresult) {
                res.status(401).send(JSON.stringify({
                    message: "Sorry, Your token has expired!",
                    error: jwterror,
                    data: null
                }))
            } else {
                pool.getConnection(function (error, database) {
                    if (error) {
                        return res.status(400).send({
                            message: "Sorry, your connection has refused!",
                            error: error,
                            data: null
                        })
                    } else {
                        var sqlquery = "SELECT * FROM pengguna"
                        database.query(sqlquery, (error, rows) => {
                            if (error) {
                                return res.status(500).send({
                                    message: "Sorry, query has error!",
                                    error: error,
                                    data: null
                                });
                            } else {
                                if (rows.length <= 0) {
                                    return res.status(204).send({
                                        message: "Sorry, data empty!",
                                        error: null,
                                        data: rows
                                    });
                                } else {
                                    return res.status(200).send({
                                        message: "Done!, data has fetched!",
                                        error: null,
                                        data: rows
                                    });
                                }
                            }
                        })
                    }
                })
            }
        })
    } catch (error) {
        return res.status(403).send({
            message: "Forbidden.",
            data: rows
        });
    } } else {
        res.status(401).send({
            message: "Sorry, Need Token Validation!",
            error: null,
            data: null
        })
    }
}

// * FUNCTION ADD DATA PENGGUNA

/**
 * @swagger
 * /pengguna:
 *  post:
 *      summary: endpoint API menambah data pengguna.
 *      tags: [PENGGUNA]
 *      security:
 *          - bearerAuth: []
 *      consumes:
 *          - application/json
 *      parameters:
 *          - name: token
 *            in: header
 *            schema:
 *              type: string
 *              description: >
 *                  parameter `token` dikirim di header, token/access token digunakan untuk validasi keamanan API.
 *          - in: body
 *            name: Parameter
 *            schema:
 *              properties:
 *                  nama: 
 *                      type: string
 *                      description: nama pengguna
 *                  username:
 *                      type: string
 *                      description: username untuk username validasi login aplikasi.
 *                  password:
 *                      type: string
 *                      description: password sebagai validasi login pengguna, yang selanjutnya akan di encrypt.
 *                  jabatan:
 *                      type: string
 *                      description: untuk menentukan role akses pengguna
 *                  notification_token:
 *                      type: string
 *                      description: untuk menyimpan token notifikasi firebase untuk keperluan push notification
 *                  aktif:
 *                      type: int
 *                      description: flag untuk menentukan apakah user masih aktif atau tidak
 *      responses:
 *          200:
 *              description: jika data berhasil di fetch
 *          204:
 *              description: jika data yang dicari tidak ada
 *          400:
 *              description: kendala koneksi pool database
 *          401:
 *              description: token tidak valid
 *          405:
 *              description: parameter yang dikirim tidak sesuai
 *          407:
 *              description: gagal generate encrypt password 
 *          500:
 *              description: kesalahan pada query sql
 */

async function addPengguna(req, res) {
    var nama = req.body.nama
    var username = req.body.username
    var password = req.body.password
    var jabatan = req.body.jabatan
    var notification_token = req.body.notification_token
    var aktif = req.body.aktif
    const token = req.headers.authorization
    if (Object.keys(req.body).length != 6) {
        return res.status(405).send({
            message: "Sorry,  parameters not match",
            error: jwtresult,
            data: null
        })
    } else {
        try {
            jwt.verify(token.split(' ')[1], process.env.ACCESS_SECRET, (jwterror, jwtresult) => {
                if (!jwtresult) {
                    return res.status(401).send({
                        message: "Sorry,  Your token has expired!",
                        error: jwterror,
                        data: null
                    });
                } else {
                    pool.getConnection(function (error, database) {
                        if (error) {
                            return res.status(400).send({
                                message: "Sorry,  your connection has refused!",
                                error: error,
                                data: null
                            });
                        } else {
                            database.beginTransaction(function (error) {
                                bcrypt.hash(password, 10, (errorencrypt, encrypt) => {
                                    if (errorencrypt) {
                                        return res.status(407).send({
                                            message: "Sorry,  password fail to generate!",
                                            error: errorencrypt,
                                            data: null
                                        });
                                    } else {
                                        let datapengguna = {
                                            nama: nama,
                                            username: username,
                                            password: encrypt,
                                            jabatan: jabatan,
                                            aktif: aktif,
                                            notification_token: notification_token,
                                            created: new Date().toISOString().replace('T', ' ').substring(0, 19),
                                            last_login: new Date().toISOString().replace('T', ' ').substring(0, 19)
                                        }
                                        var sqlquery = "INSERT INTO pengguna SET ?"
                                        database.query(sqlquery, datapengguna, (error, result) => {
                                            if (error) {
                                                database.rollback(function () {
                                                    database.release()
                                                    return res.status(407).send({
                                                        message: "Sorry,  query has error!",
                                                        error: error,
                                                        data: null
                                                    })
                                                })
                                            } else {
                                                database.commit(function (errcommit) {
                                                    if (errcommit) {
                                                        database.rollback(function () {
                                                            database.release()
                                                            return res.status(407).send({
                                                                message: "Sorry,  fail to store data pengguna",
                                                                error: errcommit,
                                                                data: null
                                                            })
                                                        })
                                                    } else {
                                                        database.release()
                                                        return res.status(200).send({
                                                            message: "Done!,  Data has been stored!",
                                                            error: null,
                                                            data: null
                                                        })
                                                    }
                                                })
                                            }
                                        })
                                    }
                                })
                            })
                        }
                    })
                }
            })
        } catch (error) {
            return res.status(403).send({
                message: "forbiden!",
                error: error,
                data: null
            })
        }
    }
}

// * FUNCTION CHANGE DATA PENGGUNA

/**
 * @swagger
 * /pengguna/:idpengguna:
 *  put:
 *      summary: endpoint API mengubah data pengguna.
 *      tags: [PENGGUNA]
 *      security:
 *          - bearerAuth: []
 *      consumes:
 *          - application/json
 *      parameters:
 *          - name: idpengguna
 *            in: path
 *            schema:
 *              type: int
 *              description: >
 *                  parameter `idpengguna` dikirim di dipath.
 *          - name: token
 *            in: header
 *            schema:
 *              type: string
 *              description: >
 *                  parameter `token` dikirim di header, token/access token digunakan untuk validasi keamanan API.
 *          - in: body
 *            name: Parameter
 *            schema:
 *              properties:
 *                  nama: 
 *                      type: string
 *                      description: nama pengguna
 *                  username:
 *                      type: string
 *                      description: username untuk username validasi login aplikasi.
 *                  password:
 *                      type: string
 *                      description: password sebagai validasi login pengguna, yang selanjutnya akan di encrypt.
 *                  jabatan:
 *                      type: string
 *                      description: untuk menentukan role akses pengguna
 *                  notification_token:
 *                      type: string
 *                      description: untuk menyimpan token notifikasi firebase untuk keperluan push notification
 *                  aktif:
 *                      type: int
 *                      description: flag untuk menentukan apakah user masih aktif atau tidak
 *      responses:
 *          200:
 *              description: jika data berhasil di fetch
 *          204:
 *              description: jika data yang dicari tidak ada
 *          400:
 *              description: kendala koneksi pool database
 *          401:
 *              description: token tidak valid
 *          405:
 *              description: parameter yang dikirim tidak sesuai
 *          407:
 *              description: gagal generate encrypt password 
 *          500:
 *              description: kesalahan pada query sql
 */

 async function ubahPengguna(req, res) {
    var nama = req.body.nama
    var username = req.body.username
    var password = req.body.password
    var jabatan = req.body.jabatan
    var notification_token = req.body.notification_token
    var aktif = req.body.aktif
    var idpengguna = req.params.idpengguna
    const token = req.headers.authorization
    if (Object.keys(req.body).length != 6) {
        return res.status(405).send({
            message: "Sorry,  parameters not match",
            error: jwtresult,
            data: null
        })
    } else {
        try {
            jwt.verify(token.split(' ')[1], process.env.ACCESS_SECRET, (jwterror, jwtresult) => {
                if (!jwtresult) {
                    return res.status(401).send({
                        message: "Sorry,  Your token has expired!",
                        error: jwterror,
                        data: null
                    });
                } else {
                    pool.getConnection(function (error, database) {
                        if (error) {
                            return res.status(400).send({
                                message: "Sorry,  your connection has refused!",
                                error: error,
                                data: null
                            });
                        } else {
                            database.beginTransaction(function (error) {
                                bcrypt.hash(password, 10, (errorencrypt, encrypt) => {
                                    if (errorencrypt) {
                                        return res.status(407).send({
                                            message: "Sorry,  password fail to generate!",
                                            error: errorencrypt,
                                            data: null
                                        });
                                    } else {
                                        let datapengguna = {
                                            nama: nama,
                                            username: username,
                                            password: encrypt,
                                            jabatan: jabatan,
                                            aktif: aktif,
                                            notification_token: notification_token,
                                            edited: new Date().toISOString().replace('T', ' ').substring(0, 19),
                                            last_login: new Date().toISOString().replace('T', ' ').substring(0, 19)
                                        }
                                        var sqlquery = "UPDATE pengguna SET ? WHERE idpengguna = ?"
                                        database.query(sqlquery, [datapengguna, idpengguna], (error, result) => {
                                            if (error) {
                                                database.rollback(function () {
                                                    database.release()
                                                    return res.status(407).send({
                                                        message: "Sorry,  query has error!",
                                                        error: error,
                                                        data: null
                                                    })
                                                })
                                            } else {
                                                database.commit(function (errcommit) {
                                                    if (errcommit) {
                                                        database.rollback(function () {
                                                            database.release()
                                                            return res.status(407).send({
                                                                message: "Sorry,  fail to change data pengguna",
                                                                error: errcommit,
                                                                data: null
                                                            })
                                                        })
                                                    } else {
                                                        database.release()
                                                        return res.status(200).send({
                                                            message: "Done!,  Data has changed!",
                                                            error: null,
                                                            data: null
                                                        })
                                                    }
                                                })
                                            }
                                        })
                                    }
                                })
                            })
                        }
                    })
                }
            })
        } catch (error) {
            return res.status(403).send({
                message: "forbiden!",
                error: error,
                data: null
            })
        }
    }
}

module.exports = {
    getAllPengguna,
    addPengguna,
    ubahPengguna
}