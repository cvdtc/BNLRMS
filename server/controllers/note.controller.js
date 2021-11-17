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
 *  name: NOTE
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

// * FUNCTION GET LIST NOTE

/**
 * @swagger
 * /note/:filter:
 *  get:
 *      summary: untuk menampilkan semua note berdasarkan filter `aktif` atau `nonaktif`. [header token]
 *      tags: [NOTE]
 *      parameters:
 *          - name: token
 *            in: header
 *            schema:
 *              type: string
 *              description: >
 *                  parameter `token` dikirim di header, token/access token digunakan untuk validasi keamanan API.
 *          - name: filter
 *            in: path
 *            schema:
 *              type: integer
 *              description: >
 *                  parameter `filter` dikirim di url, yang dikirim hanya `0` untuk non-aktif, `1` untuk aktif dan `2` untuk semua/tanpa filter.
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

async function getAllNote(req, res) {
    const token = req.headers.authorization;
    const filter = req.params.filter
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
                            var sqlfilter = ``
                            if(filter == 0){
                                sqlfilter = `AND flag_selesai=0`
                            }else if(filter == 1){
                                sqlfilter = `AND flag_selesai=1`
                            }else if(filter == 2){
                                sqlfilter = ``
                            }else{
                                return res.status(405).send({
                                    message: "Sorry,  parameters not match",
                                    error: null,
                                    data: null
                                })
                            }
                            var sqlquery = `SELECT * FROM note WHERE pengguna_idpengguna = ? `+sqlfilter
                            database.query(sqlquery, [jwtresult.idpengguna], (error, rows) => {
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

// * FUNCTION ADD DATA NOTE

/**
 * @swagger
 * /note:
 *  post:
 *      summary: endpoint API menambah Note/Catatan.
 *      tags: [NOTE]
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
 *                      description: deskripsi catatan.
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

async function addNote(req, res) {
    var keterangan = req.body.keterangan
    const token = req.headers.authorization
    if (Object.keys(req.body).length != 1) {
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
                            let datanote = {
                                keterangan: keterangan,
                                flag_selesai: 0,
                                created: new Date().toISOString().replace('T', ' ').substring(0, 19),
                                pengguna_idpengguna: jwtresult.idpengguna // * will be change to idpengguna
                            }
                            var sqlquery = "INSERT INTO note SET ?"
                            database.query(sqlquery, datanote, (error, result) => {
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
 * /note/:idnote:
 *  put:
 *      summary: endpoint API mengubah Catatan.
 *      tags: [NOTE]
 *      security:
 *          - bearerAuth: []
 *      consumes:
 *          - application/json
 *      parameters:
 *          - name: idnote
 *            in: path
 *            schema:
 *              type: integer
 *              description: >
 *                  parameter `idnote` dikirim di dipath/url.
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
 *                      description: deskripsi Catatan.
 *                  flag_selesai:
 *                      type: integer
 *                      description: sebagai flag apakah catatan ini sudah selesai apa belum. flag ini hanya bernilai `0` dan `1`.
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

async function ubahNote(req, res) {
    var keterangan = req.body.keterangan
    var flag_selesai = req.body.flag_selesai
    var idnote = req.params.idnote // * will be change to idnote
    const token = req.headers.authorization
    if (Object.keys(req.body).length != 2) {
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
                                let updatenote = {
                                    keterangan: keterangan,
                                    flag_selesai: flag_selesai,
                                    idpengguna: jwtresult.idpengguna
                                }
                                var sqlquery = "UPDATE note SET ? WHERE idreminder = ?" // * idreminder will be change to idnote
                                database.query(sqlquery, [updatenote, idnote], (error, result) => {
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

// * FUNCTION CHANGE DATA NOTE

/**
 * @swagger
 * /note/:idnote:
 *  delete:
 *      summary: endpoint API menghapus Catatan.
 *      tags: [NOTE]
 *      security:
 *          - bearerAuth: []
 *      consumes:
 *          - application/json
 *      parameters:
 *          - name: idnote
 *            in: path
 *            schema:
 *              type: int
 *              description: >
 *                  parameter `idnote` dikirim di dipath.
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

async function deleteNote(req, res) {
    var idnote = req.params.idnote
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
                            var sqlquery = "DELETE FROM note WHERE idreminder = ?" // * idreminder will be change to idnote
                            database.query(sqlquery, [idprogress], (error, result) => {
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
                                                    message: "Sorry,  fail to change data",
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
    getAllNote,
    addNote,
    ubahNote,
    deleteNote
}