//Plugin
require('dotenv').config()
const jwt = require('jsonwebtoken')
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
 *  name: PROGRESS
 *  description: endpoint API for get, post, put and delete progress permintaan
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

// * FUNCTION GET LIST PROGRESS

/**
 * @swagger
 * /progress:
 *  get:
 *      summary: untuk menampilkan semua data Progress. [header token]
 *      tags: [PROGRESS]
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

async function getAllProgress(req, res) {
    const token = req.headers.authorization;
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
                            var sqlquery = `SELECT pr.*, pe.keterangan as permintaan, pe.kategori, pe.due_date FROM permintaan pe, progress pr WHERE pr.idpermintaan=pe.idpermintaan AND pr.idpengguna=?`
                            database.query(sqlquery, [jwtresult.idpengguna], (error, rows) => {
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

// * FUNCTION ADD DATA PROGRESS

/**
 * @swagger
 * /progress:
 *  post:
 *      summary: endpoint API menambah data Progress permintaan/request.
 *      tags: [PROGRESS]
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
 *                      description: deskripsi progress pengerjaan permintaaan.
 *                  idpermintaan:
 *                      type: int
 *                      description: untuk menentukan progress yang disimpan ini merupakan progress permintaan yang mana.
 *      responses:
 *          201:
 *              description: jika data berhasil di simpan
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

async function addProgress(req, res) {
    var keterangan = req.body.keterangan
    var idpermintaan = req.body.idpermintaan
    const token = req.headers.authorization
    if (Object.keys(req.body).length != 2) {
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
                            let dataprogress = {
                                keterangan: keterangan,
                                flag_selesai: 0,
                                idpermintaan: idpermintaan,
                                created: new Date().toISOString().replace('T', ' ').substring(0, 19),
                                idpengguna: jwtresult.idpengguna
                            }
                            var sqlquery = "INSERT INTO progress SET ?"
                            database.query(sqlquery, dataprogress, (error, result) => {
                                database.release()
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
                                                    message: "Sorry,  fail to store!",
                                                    error: errcommit,
                                                    data: null
                                                })
                                            })
                                        } else {
                                            database.release()
                                            return res.status(201).send({
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

// * FUNCTION CHANGE DATA PROGRESS

/**
 * @swagger
 * /progress/:idprogress:
 *  put:
 *      summary: endpoint API mengubah data progress permintaan/request.
 *      tags: [PROGRESS]
 *      security:
 *          - bearerAuth: []
 *      consumes:
 *          - application/json
 *      parameters:
 *          - name: idprogress
 *            in: path
 *            schema:
 *              type: int
 *              description: >
 *                  parameter `idprogress` dikirim di dipath.
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
 *                      description: deskripsi progress pengerjaan permintaaan.
 *                  flag_selesai:
 *                      type: int
 *                      description: sebagai flag apakah progress ini sudah di selesai dikerjakan apa belum. flag ini hanya bernilai `0` dan `1`.
 *                  next_idpengguna:
 *                      type: int
 *                      description: (opsional) untuk menentukan apakah progress ini mau diteruskan ke idpengguna lain atau tidak. jika tidak defaultnya adalah `0` jika iya maka `diisi sesuai idpengguna yang dituju`
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

async function ubahProgress(req, res) {
    var keterangan = req.body.keterangan
    var flag_selesai = req.body.flag_selesai
    var next_idpengguna = req.body.next_idpengguna
    var idprogress = req.params.idprogress
    const token = req.headers.authorization
    if (Object.keys(req.body).length != 3) {
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
                                let updateprogress = {
                                    keterangan: keterangan,
                                    flag_selesai: flag_selesai,
                                    next_idpengguna: next_idpengguna, // * wiil be change to next_idpengguna if database successfull sync
                                    edited: new Date().toISOString().replace('T', ' ').substring(0, 19),
                                    idpengguna: jwtresult.idpengguna
                                }
                                var sqlquery = "UPDATE progress SET ? WHERE idprogress = ?"
                                database.query(sqlquery, [updateprogress, idprogress], (error, result) => {
                                    database.release()
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
                                                    message: "Done!, Data has changed!",
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

// * FUNCTION CHANGE DATA PROGRESS

/**
 * @swagger
 * /progress/:idprogress:
 *  delete:
 *      summary: endpoint API menghapus data Progress permintaan/request.
 *      tags: [PROGRESS]
 *      security:
 *          - bearerAuth: []
 *      consumes:
 *          - application/json
 *      parameters:
 *          - name: idprogress
 *            in: path
 *            schema:
 *              type: int
 *              description: >
 *                  parameter `idprogress` dikirim di dipath.
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

async function deleteProgress(req, res) {
    var idprogress = req.params.idprogress
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
                            var sqlquery = "DELETE FROM progress WHERE idprogress = ?"
                            database.query(sqlquery, [idprogress], (error, result) => {
                                database.release()
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
    getAllProgress,
    addProgress,
    ubahProgress,
    deleteProgress
}