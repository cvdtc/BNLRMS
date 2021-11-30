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
 *  name: REPORT
 *  description: endpoint API for rms report.
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

// * FUNCTION GET LIST REPORT

/**
 * @swagger
 * /timeline/:idpermintaan:
 *  get:
 *      summary: untuk menampilkan data timeline berdasarkan idpermintaan yang dikirim di path, [header token]
 *      tags: [REPORT]
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

async function getTimeline(req, res) {
    const token = req.headers.authorization
    const idpermintaan = req.params.idpermintaan
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
                        var sqlquery = "SELECT 1 AS tipe, pe.keterangan, pe.kategori, pe.due_date, pe.created, pe.edited, pe.flag_selesai, pe.keterangan_selesai, pe.idpengguna_close_permintaan, '-' AS prg_keterangan, '-' AS prg_created, '-' AS prg_edited, '-' AS prg_flag_selesai FROM permintaan pe WHERE pe.idpermintaan=? UNION SELECT 2 AS tipe, '-' as keterangan, '-' as kategori, '-' as due_date, '-' as created, '-' as edited, '-' as flag_selesai, '-' as keterangan_selesai, '-' as idpengguna_close_permintaan, prg.keterangan AS prg_keterangan, prg.created AS prg_created, prg.edited AS prg_edited, prg.flag_selesai AS prg_flag_selesai FROM progress prg WHERE prg.idpermintaan=?;"
                        database.query(sqlquery,[idpermintaan, idpermintaan], (error, rows) => {
                            database.release()
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
module.exports = {
    getTimeline
}