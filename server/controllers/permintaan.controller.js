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

var nows = {
    toSqlString: function () {
        return "NOW()";
    },
}

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

/**
 * * [1] 11 Des 2021 tambah filter Marketing hanya keluar requestnya sendiri
 */

async function getAllPermintaan(req, res) {
    const token = req.headers.authorization
    const {tanggal_awal, tanggal_akhir, keyword} = req.params;
    console.log('Akses Permintaan...')
    if (token != null) {
        try {
            jwt.verify(token.split(' ')[1], process.env.ACCESS_SECRET, (jwterror, jwtresult) => {
                if (!jwtresult) {
                    return res.status(401).send(JSON.stringify({
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
                            var filter = (jwtresult.jabatan == "Marketing") ? (" where idpengguna=" + jwtresult.idpengguna) : ("") //[1]
                            var filtertanggal='';
                            /// cek filter tanggal dan keyword [06122022]
                            if(tanggal_awal!=''||tanggal_akhir!=''){
                                    filtertanggal = `and date(p.created) between ${tanggal_awal} and ${tanggal_akhir} and p.keterangan like %${keyword}%`;
                            }
                            var sqlquery = `select a.*, ifnull(b.jml,0) as jmlprogress from (SELECT idpermintaan, keterangan, kategori, DATE_FORMAT(due_date, "%Y-%m-%d") as due_date, DATE_FORMAT(p.created, "%Y-%m-%d %H:%i") as created, DATE_FORMAT(p.edited, "%Y-%m-%d %H:%i") as edited, flag_selesai, keterangan_selesai, pg.nama as nama_request, p.idpengguna, url_web as url_permintaan FROM permintaan p, pengguna pg WHERE p.idpengguna=pg.idpengguna `+filtertanggal+`)a left join (select idpermintaan, count(*) as jml from progress GROUP BY idpermintaan)b ON a.idpermintaan=b.idpermintaan ` + filter + ` ORDER BY flag_selesai ASC, due_date ASC`
                            database.query(sqlquery, (error, rows) => {
                                console.log("🚀 ~ file: permintaan.controller.js:113 ~ sqlquery", sqlquery)
                                database.release()
                                if (error) {
                                    return res.status(500).send({
                                        message: "Sorry, query has error!",
                                        error: error,
                                        data: null
                                    })
                                } else {
                                    if (rows.length <= 0) {
                                        return res.status(200).send({
                                            message: "Sorry, data empty!",
                                            error: null,
                                            data: rows
                                        })
                                    } else {
                                        return res.status(200).send({
                                            message: "Done!, data has fetched!",
                                            error: null,
                                            data: rows
                                        })
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
            })
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
 *                  url_web:
 *                      type: string
 *                      description: untuk menyimpan alamat url jika diperlukan oleh user
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

/**
 * NOTE!
 * * [1] 03 Des 2021 add firebase notification {s}
 * * [2] 04 Des 2021 memberikan nama penambah permintaan pada notifikasi {s}
 * * [3] 14 Des 2021 add field url_web
 * * [4] 15 Des 2021 Dihapus karena agar flutter bisa mengirim tambah ubah dalam 1 model
 */

async function addPermintaan(req, res) {
    var keterangan = req.body.keterangan
    var kategori = req.body.kategori
    var due_date = req.body.due_date
    var flag_selesai = req.body.flag_selesai
    var url_web = req.body.url_permintaan //[3]
    const token = req.headers.authorization
    // if (Object.keys(req.body).length != 5) { // [4] -->
    //     return res.status(405).send({
    //         message: "Sorry,  parameters not match",
    //         error: null,
    //         data: null
    //     })
    // } else { //[4] <-- 
        try {
            jwt.verify(token.split(' ')[1], process.env.ACCESS_SECRET, (jwterror, jwtresult) => {
                if (!jwtresult) {
                    return res.status(401).send({
                        message: "Sorry,  Your token has expired!",
                        error: jwterror,
                        data: null
                    })
                } else {
                    pool.getConnection(function (error, database) {
                        if (error) {
                            return res.status(400).send({
                                message: "Sorry,  your connection has refused!",
                                error: error,
                                data: null
                            })
                        } else {
                            let datapermintaan = {
                                keterangan: keterangan,
                                kategori: kategori,
                                due_date: due_date,
                                flag_selesai: flag_selesai,
                                created: nows,
                                url_web: url_web, // [3]
                                idpengguna: jwtresult.idpengguna
                            }
                            var sqlquery = "INSERT INTO permintaan SET ?"
                            database.query(sqlquery, datapermintaan, (error, result) => {
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
                                                    message: "Sorry,  fail to store data!",
                                                    error: errcommit,
                                                    data: null
                                                })
                                            })
                                        } else {
                                            var getnameuser = "SELECT nama FROM pengguna WHERE idpengguna = ?"
                                            database.query(getnameuser, jwtresult.idpengguna, (error, result) => {
                                                database.release()
                                                // * set firebase notification message 
                                                let notificationMessage = {
                                                    notification: {
                                                        title: `Permintaan baru dari ${result[0].nama}`,
                                                        body: keterangan,
                                                        sound: 'default',
                                                        'click_action': 'FCM_PLUGIN_ACTIVITY'
                                                    },
                                                    data: {
                                                        "judul": `Permintaan baru dari ${result[0].nama}`,
                                                        "isi": keterangan
                                                    }
                                                }
                                                // * sending notification topic RMSPERMINTAAN
                                                fcmadmin.messaging().sendToTopic("RMSPERMINTAANdebug", notificationMessage)
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
    // } <-- [4]
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
 *                  url_permintaan:
 *                      type: string
 *                      description: untuk menyimpan alamat url jika diperlukan oleh user
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

/**
 * *[1] 11 Des 2021 tidak perlu update id pengguna {pj}
 * *[2] 14 Des 2021 add field url_web {s}
 * *[3] 11 Des 2012 hanya pengguna yang buat permintaan yang bisa update permintaannya sendiri {pj}
 */

async function ubahPermintaan(req, res) {
    var keterangan = req.body.keterangan
    var kategori = req.body.kategori
    var due_date = req.body.due_date
    var flag_selesai = req.body.flag_selesai
    var keterangan_selesai = req.body.keterangan_selesai
    var url_web = req.body.url_permintaan
    var idpermintaan = req.params.idpermintaan
    const token = req.headers.authorization
    // if (Object.keys(req.body).length != 7) { // [4] -->
    //     return res.status(405).send({
    //         message: "Sorry,  parameters not match",
    //         error: null,
    //         data: null
    //     })
    // } else { <-- [4]
        try {
            jwt.verify(token.split(' ')[1], process.env.ACCESS_SECRET, (jwterror, jwtresult) => {
                if (!jwtresult) {
                    return res.status(401).send({
                        message: "Sorry,  Your token has expired!",
                        error: jwterror,
                        data: null
                    })
                } else {
                    pool.getConnection(function (error, database) {
                        if (error) {
                            return res.status(400).send({
                                message: "Sorry,  your connection has refused!",
                                error: error,
                                data: null
                            })
                        } else {
                            database.beginTransaction(function (error) {
                                let updatedatapermintaan = {
                                    keterangan: keterangan,
                                    kategori: kategori,
                                    due_date: due_date,
                                    flag_selesai: flag_selesai,
                                    keterangan_selesai: keterangan_selesai,
                                    edited: nows,
                                    url_web: url_web // [2]
                                    // idpengguna: jwtresult.idpengguna // [1]
                                }
                                let selesaidatapermintaan = {
                                    keterangan: keterangan,
                                    kategori: kategori,
                                    due_date: due_date,
                                    flag_selesai: flag_selesai,
                                    keterangan_selesai: keterangan_selesai,
                                    date_selesai: nows,
                                    url_web: url_web // [2]
                                    // idpengguna: jwtresult.idpengguna // [1]
                                }
                                var sqlquery = "UPDATE permintaan SET ? WHERE idpengguna=? and idpermintaan = ?" // [3]
                                database.query(sqlquery, [flag_selesai == 1 ? selesaidatapermintaan : updatedatapermintaan, jwtresult.idpengguna, idpermintaan], (error, result) => {
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
                                                        message: "Sorry,  fail to change data permintaan",
                                                        error: errcommit,
                                                        data: null
                                                    })
                                                })
                                            } else {
                                                return res.status(200).send({
                                                    message: "Done!,  Data has changed! "+result,
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
    // } <-- [4]
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
                })
            } else {
                pool.getConnection(function (error, database) {
                    if (error) {
                        return res.status(400).send({
                            message: "Sorry,  your connection has refused!",
                            error: error,
                            data: null
                        })
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
