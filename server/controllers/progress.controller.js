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
        return "NOW()"
    },
}

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

/**
 * * [1] 14 Des 2021 tambah query untuk menampilkan url_web tabel progress dan tabel permintaan
 */

async function getAllProgress(req, res) {
    const token = req.headers.authorization
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
                            //update 23 Des 2021 : permintaan Pak Benny kalau request sudah selesai maka progress yang sudah selesai tidak perlu ditampilkan lagi di dashboard maupun tab progress (and pe.flag_selesai=0)
                            var sqlquery = `SELECT pr.idprogress, pr.keterangan, DATE_FORMAT(pr.created, "%Y-%m-%d %H:%i") as created, DATE_FORMAT(pr.edited, "%Y-%m-%d %H:%i") as edited, pr.flag_selesai, pr.next_idpengguna as idnextuser, pr.idpengguna, pr.idpermintaan, pe.keterangan as permintaan, pe.kategori, DATE_FORMAT(pe.due_date, "%Y-%m-%d") as due_date, p.nama, pe.url_web as url_permintaan, pr.url_web as url_progress FROM permintaan pe, progress pr, pengguna p WHERE pr.idpermintaan=pe.idpermintaan AND pe.idpengguna=p.idpengguna AND pr.idpengguna = ? AND pr.flag_selesai=0 AND pe.flag_selesai=0` //[1]
                            database.query(sqlquery, [jwtresult.idpengguna], (error, rows) => {
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
 *                  idnextuser:
 *                      type: int
 *                      description: idnextuser digunakan untuk menyimpan idpengguna selanjutnya jika tipenya nextuser jika tipenya tambahprogress maka idnextuser dikirim 0
 *                  tipe:
 *                      type: string
 *                      description: tipe menentukan idpengguna yang akan disimpan di database, tipe hanya ada tambahprogress dan nextuser jika tipe tambahprogress idyang disimpan idpengguna yang membuat progress tapi jika nextuser maka yang di simpan idpengguna user yang dituju
 *                  url_progress:
 *                      type: string
 *                      description: untuk menyimpan alamat url jika diperlukan oleh user
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

/**
 * * [1] 14 Des 2021 add field url_web
 * * [2] 15 Des 2021 Dihapus karena agar flutter bisa mengirim tambah ubah dalam 1 model
 */

async function addProgress(req, res) {
    var keterangan = req.body.keterangan
    var idpermintaan = req.body.idpermintaan
    var idnextuser = req.body.idnextuser
    var tipe = req.body.tipe
    var url_web = req.body.url_progress//[1]
    var keterangan_selesai = req.body.keterangan_selesai
    const token = req.headers.authorization
    // if (Object.keys(req.body).length != 5) { // [2] -->
    //     return res.status(405).send({
    //         message: "Sorry,  parameters not match",
    //         error: null,
    //         data: null
    //     })
    // } else { <-- [2]
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
                        let dataprogress = {
                            keterangan: keterangan,
                            flag_selesai: 0,
                            idpermintaan: idpermintaan,
                            created: nows,
                            url_web: url_web,//[1]
                            next_idpengguna: 0,
                            idpengguna: jwtresult.idpengguna
                        }
                        let dataprogressnext = {
                            keterangan: 'dari: ' + jwtresult.username + ' >> ' + keterangan_selesai,
                            //                            keterangan: keterangan_selesai,
                            flag_selesai: 0,
                            idpermintaan: idpermintaan,
                            created: nows,
                            url_web: url_web,//[1]
                            idpengguna: idnextuser
                        }
                        var sqlquery = "INSERT INTO progress SET ?"
                        // * ketika insert tipe akan menentukan apa yang di insert, ketika tipe next user maka idpengguna akan di insert idnext user selain tipe next user, idpengguna yang di insert berasal dari jwt
                        database.query(sqlquery, tipe == 'nextuser' ? dataprogressnext : dataprogress, (error, result) => {
                            // database.release()
                            if (error) {
                                database.rollback(function () {
                                    console.log(dataprogress, dataprogressnext)
                                    return res.status(407).send({
                                        message: `Sorry,  query tambah progress has error! ${error}`,
                                        error: error,
                                        data: null
                                    })
                                })
                            } else {
                                database.commit(function (errcommit) {
                                    if (errcommit) {
                                        database.rollback(function () {
                                            return res.status(407).send({
                                                message: "Sorry,  fail to store!",
                                                error: errcommit,
                                                data: null
                                            })
                                        })
                                    } else {
                                        var getdatanotif = "SELECT p.keterangan as permintaan FROM permintaan p WHERE p.idpermintaan = ?"
                                        database.query(getdatanotif, idpermintaan, (error, result) => {
                                            console.log('select data notif', getdatanotif)
                                            database.release()
                                            // * set firebase notification message 
                                            let notificationMessage = {
                                                notification: {
                                                    title: `Ada progress untuk ${result[0].permintaan}`,
                                                    body: keterangan,
                                                    sound: 'default',
                                                    'click_action': 'FCM_PLUGIN_ACTIVITY'
                                                },
                                                data: {
                                                    title: `Ada progress untuk ${result[0].permintaan}`,
                                                    body: keterangan,
                                                }
                                            }
                                            // * sending notification topic RMSPERMINTAAN
                                            fcmadmin.messaging().sendToTopic("RMSPROGRESS", notificationMessage)
                                                .then(function (response) {
                                                    return res.status(200).send({
                                                        message: "Done!,  Data has been stored!",
                                                        error: null,
                                                        data: response
                                                    })
                                                }).catch(function (error) {
                                                    return res.status(200).send({
                                                        message: "Done!,  Data has been stored!",
                                                        error: error,
                                                        data: null
                                                    })
                                                })
                                        })
                                        /// ditutup karena sudah dimasukkan di notifikasi
                                        // return res.status(201).send({
                                        //     message: "Done!,  Data has been stored!",
                                        //     error: null,
                                        //     data: null
                                        // })
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
    // } <-- [2]
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
 *                  url_progress:
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
 * * [1] 14 desember add table url_web
 * * [2] 15 Des 2021 Dihapus karena agar flutter bisa mengirim tambah ubah dalam 1 model
 */

async function ubahProgress(req, res) {
    var keterangan = req.body.keterangan
    var flag_selesai = req.body.flag_selesai
    var idnextuser = req.body.idnextuser
    var url_web = req.body.url_progress // [1]
    var idprogress = req.params.idprogress
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
                            let updateprogress = {
                                keterangan: keterangan,
                                flag_selesai: flag_selesai,
                                next_idpengguna: idnextuser,
                                edited: nows,
                                url_web: url_web, // [1]
                                idpengguna: jwtresult.idpengguna
                            }
                            var sqlquery = "UPDATE progress SET ? WHERE idprogress = ?"
                            database.query(sqlquery, [updateprogress, idprogress], (error, result) => {
                                // database.release()
                                if (error) {
                                    database.rollback(function () {
                                        console.log(updateprogress, error);
                                        return res.status(407).send({
                                            message: "Sorry,  query edit progress has error! ",
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
                                            var getdatanotif = "SELECT p.idpermintaan as idpermintaan, p.keterangan as permintaan, pr.keterangan as progress, pe.nama FROM permintaan p, progress pr, pengguna pe WHERE p.idpermintaan=pr.idpermintaan AND pr.idpengguna=pe.idpengguna AND pr.idprogress = ?"
                                            database.query(getdatanotif, idprogress, (error, result) => {
                                                if (flag_selesai === 1 && !idnextuser) {
                                                    let dataprogressnext = {
                                                        keterangan: 'dari: ' + jwtresult.username + ' >> ' + keterangan_selesai,
                                                        //                            keterangan: keterangan_selesai,
                                                        flag_selesai: 0,
                                                        idpermintaan: result[0].idpermintaan,
                                                        created: nows,
                                                        url_web: url_web,//[1]
                                                        idpengguna: idnextuser
                                                    }
                                                    database.query("INSERT INTO progress SET ?", dataprogressnext)
                                                }
                                                database.release()
                                                if (flag_selesai == 1) {
                                                    // database.release()
                                                    // insert into progress when tipe is next user
                                                    // * set firebase notification message 
                                                    let notificationMessage = {
                                                        notification: {
                                                            title: `Update progress dari ${result[0].nama}`,
                                                            body: `Ada progress baru untuk ` + result[0].permintaan,
                                                            sound: 'default',
                                                            'click_action': 'FCM_PLUGIN_ACTIVITY'
                                                        },
                                                        data: {
                                                            title: `Ada Update progress dari ${result[0].nama}`,
                                                            body: `Ada progress baru untuk ${result[0].permintaan}`,
                                                        }
                                                    }
                                                    // * sending notification topic RMSPERMINTAAN
                                                    fcmadmin.messaging().sendToTopic("RMSPROGRESS", notificationMessage)
                                                        .then(function (response) {
                                                            return res.status(200).send({
                                                                message: "Done!,  Data has been stored!",
                                                                error: null,
                                                                data: response
                                                            })
                                                        }).catch(function (error) {
                                                            return res.status(200).send({
                                                                message: "Done!,  Data has been stored!",
                                                                error: error,
                                                                data: null
                                                            })
                                                        })
                                                } else {
                                                    return res.status(200).send({
                                                        message: "Done!, Data has changed!",
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
    //    }// <-- [2]
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
                            var sqlquery = "DELETE FROM progress WHERE idprogress = ?"
                            database.query(sqlquery, [idprogress], (error, result) => {
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
    getAllProgress,
    addProgress,
    ubahProgress,
    deleteProgress
}
