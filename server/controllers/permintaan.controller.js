//Plugin
require('dotenv').config()
const jwt = require('jsonwebtoken')
const mysql = require('mysql')
var fcmadmin = require('../utils/firebaseconfiguration')

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
 *  name: PERMINTAAN
 *  description: endpoint API for get, post, put and delete permintaan/request
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

// * FUNCTION GET LIST PERMINTAAN

/**
 * @swagger
 * /permintaan:
 *  get:
 *      summary: untuk menampilkan semua data permintaan/request, [header token]
 *      tags: [PERMINTAAN]
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
 *          400:
 *              description: kendala koneksi pool database
 *          401:
 *              description: token tidak valid
 *          500:
 *              description: kesalahan pada query sql
 */

async function getAllPermintaan(req, res) {
    const token = req.headers.authorization;
    console.log('Akses Permintaan...')
    if (token != null) {
        try {
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
                            var sqlquery = `SELECT idpermintaan, keterangan, kategori, DATE_FORMAT(due_date, "%Y-%m-%d") as due_date, DATE_FORMAT(p.created, "%Y-%m-%d %H:%i") as created, DATE_FORMAT(p.edited, "%Y-%m-%d %H:%i") as edited, flag_selesai, keterangan_selesai, pg.nama as nama_request FROM permintaan p, pengguna pg WHERE p.idpengguna=pg.idpengguna ORDER BY p.flag_selesai ASC, p.due_date ASC`
                            database.query(sqlquery, (error, rows) => {
                                database.release()
                                if (error) {
                                    return res.status(500).send({
                                        message: "Sorry, query has error!",
                                        error: error,
                                        data: null
                                    });
                                } else {
                                    if (rows.length <= 0) {
                                        return res.status(200).send({
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
        }
    } else {
        res.status(401).send({
            message: "Sorry, Need Token Validation!",
            error: null,
            data: null
        })
    }
}

// * FUNCTION ADD DATA PERMINTAAN

/**
 * @swagger
 * /permintaan:
 *  post:
 *      summary: endpoint API menambah data permintaan/request.
 *      tags: [PERMINTAAN]
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
 *                  keterangan: 
 *                      type: string
 *                      description: deskripsi permintaan/request
 *                  kategori:
 *                      type: string
 *                      description: untuk menentukan pengelompokan kategori permintaan
 *                  due_date:
 *                      type: date
 *                      description: untuk menyimpan data tanggal deadline penyelesaian permintaan/request
 *                  flag_selesai:
 *                      type: int
 *                      description: untuk menentukan flag permintaan/request apakah sudah selesai atau belum
 *      responses:
 *          201:
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

async function addPermintaan(req, res) {
    var keterangan = req.body.keterangan
    var kategori = req.body.kategori
    var due_date = req.body.due_date
    var flag_selesai = req.body.flag_selesai
    const token = req.headers.authorization
    if (Object.keys(req.body).length != 4) {
        return res.status(405).send({
            message: "Sorry,  parameters not match",
            error: null,
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
                            let datapermintaan = {
                                keterangan: keterangan,
                                kategori: kategori,
                                due_date: due_date,
                                flag_selesai: flag_selesai,
                                created: new Date().toISOString().replace('T', ' ').substring(0, 19),
                                idpengguna: jwtresult.idpengguna
                            }
                            var sqlquery = "INSERT INTO permintaan SET ?"
                            database.query(sqlquery, datapermintaan, (error, result) => {
                                if (error) {
                                    database.rollback(function () {
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
                                                return res.status(407).send({
                                                    message: "Sorry,  fail to store data!",
                                                    error: errcommit,
                                                    data: null
                                                })
                                            })
                                        } else {
                                            var getnameuser = "SELECT nama FROM pengguna WHERE idpengguna = ?"
                                            database.query(getnameuser, jwtresult.idpengguna, (error, result)=>{
                                                database.release()
                                                // * set firebase notification message 
                                                let notificationMessage = {
                                                    notification: {
                                                        title: `Permintaan baru dari ${result[0].nama}`,
                                                        body: keterangan,
                                                        sound: 'default',
                                                        'click_action': 'FCM_PLUGIN_ACTIVITY'
                                                    },
                                                    data:{
                                                        "judul": `Permintaan baru dari ${result[0].nama}`,
                                                        "isi": keterangan
                                                    }
                                                }
                                                // * sending notification topic RMSPERMINTAAN
                                                fcmadmin.messaging().sendToTopic('RMSPERMINTAAN', notificationMessage)
                                                .then(function (response) {
                                                    return res.status(201).send({
                                                        message: "Done!,  Data has been stored!",
                                                        error: null,
                                                        data: response
                                                    })
                                                }).catch(function (error) {
                                                    return res.status(201).send({
                                                        message: "Done!,  Data has been stored!",
                                                        error: error,
                                                        data: null
                                                    })
                                                })
                                            })
                                        }
                                    })
                                }
                            })
                        }
                    })
                }
            })
        } catch (error) {
            console.log('FORBIDDEN PERMINTAAN')
            return res.status(403).send({
                message: "forbiden!",
                error: error,
                data: null
            })
        }
    }
}

// * FUNCTION CHANGE DATA PERMINTAAN

/**
 * @swagger
 * /permintaan/:idpermintaan:
 *  put:
 *      summary: endpoint API mengubah data permintaan/request.
 *      tags: [PERMINTAAN]
 *      security:
 *          - bearerAuth: []
 *      consumes:
 *          - application/json
 *      parameters:
 *          - name: idpermintaan
 *            in: path
 *            schema:
 *              type: int
 *              description: >
 *                  parameter `idpermintaan` dikirim di dipath.
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
 *                  keterangan: 
 *                      type: string
 *                      description: deskripsi permintaan/request
 *                  kategori:
 *                      type: string
 *                      description: untuk menentukan pengelompokan kategori permintaan
 *                  due_date:
 *                      type: date
 *                      description: untuk menyimpan data tanggal deadline penyelesaian permintaan/request
 *                  flag_selesai:
 *                      type: int
 *                      description: untuk menentukan flag permintaan/request apakah sudah selesai atau belum
 *                  keterangan_selesai:
 *                      type: string
 *                      description: untuk menyimpan data keterangan selesai apabila permintaan/request benar2 selesai
 *                  tipeupdate:
 *                      type: string
 *                      description: untuk menentukan tipe update data apakah update permintaan atau update selesai. tipe update hanya ada 2 yaitu `data` untuk mengupdate data permintaan/request atau `selesai` untuk mengupdate data permintaan menjadi selesai
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

async function ubahPermintaan(req, res) {
    var keterangan = req.body.keterangan
    var kategori = req.body.kategori
    var due_date = req.body.due_date
    var flag_selesai = req.body.flag_selesai
    var keterangan_selesai = req.body.keterangan_selesai
    var tipeupdate = req.body.tipeupdate
    var idpermintaan = req.params.idpermintaan
    const token = req.headers.authorization
    if (Object.keys(req.body).length != 6) {
        return res.status(405).send({
            message: "Sorry,  parameters not match",
            error: null,
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
                                let updatedatapermintaan = {
                                    keterangan: keterangan,
                                    kategori: kategori,
                                    due_date: due_date,
                                    flag_selesai: flag_selesai,
                                    keterangan_selesai: keterangan_selesai,
                                    edited: new Date().toISOString().replace('T', ' ').substring(0, 19),
                                    idpengguna: jwtresult.idpengguna
                                }
                                let selesaidatapermintaan = {
                                    keterangan: keterangan,
                                    kategori: kategori,
                                    due_date: due_date,
                                    flag_selesai: flag_selesai,
                                    keterangan_selesai: keterangan_selesai,
                                    edited: new Date().toISOString().replace('T', ' ').substring(0, 19),
                                    idpengguna_close_permintaan: jwtresult.idpengguna // * doesn't work bcz database failed to sync
                                }
                                var sqlquery = "UPDATE permintaan SET ? WHERE idpermintaan = ?"
                                database.query(sqlquery, [tipeupdate == 'selesai' ? selesaidatapermintaan : updatedatapermintaan, idpermintaan], (error, result) => {
                                    database.release()
                                    if (error) {
                                        database.rollback(function () {
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
                                                    return res.status(407).send({
                                                        message: "Sorry,  fail to change data pengguna",
                                                        error: errcommit,
                                                        data: null
                                                    })
                                                })
                                            } else {
                                                return res.status(200).send({
                                                    message: "Done!,  Data has changed!",
                                                    error: null,
                                                    data: null
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

// * FUNCTION CHANGE DATA PERMINTAAN

/**
 * @swagger
 * /permintaan/:idpermintaan:
 *  delete:
 *      summary: endpoint API menghapus data permintaan/request.
 *      tags: [PERMINTAAN]
 *      security:
 *          - bearerAuth: []
 *      consumes:
 *          - application/json
 *      parameters:
 *          - name: idpermintaan
 *            in: path
 *            schema:
 *              type: int
 *              description: >
 *                  parameter `idpermintaan` dikirim di dipath.
 *          - name: token
 *            in: header
 *            schema:
 *              type: string
 *              description: >
 *                  parameter `token` dikirim di header, token/access token digunakan untuk validasi keamanan API.
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

async function deletePermintaan(req, res) {
    var idpermintaan = req.params.idpermintaan
    const token = req.headers.authorization
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
                            var sqlquery = "DELETE FROM permintaan WHERE idpermintaan = ?"
                            database.query(sqlquery, [idpermintaan], (error, result) => {
                                database.release()
                                if (error) {
                                    database.rollback(function () {
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
                                                return res.status(407).send({
                                                    message: "Sorry,  fail to change data pengguna",
                                                    error: errcommit,
                                                    data: null
                                                })
                                            })
                                        } else {
                                            return res.status(200).send({
                                                message: "Done!,  Data has removed!",
                                                error: null,
                                                data: null
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

module.exports = {
    getAllPermintaan,
    addPermintaan,
    ubahPermintaan,
    deletePermintaan
}
