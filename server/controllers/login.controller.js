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
 *  name: LOGIN
 *  description: API for login endpoint
 */

// * LOGIN FUNCTION 

/**
 * @swagger
 * /login:
 *  post:
 *      summary: api untuk akses login kedalam aplikasi BNLRMS
 *      parameters:
 *          - name: username
 *            in: body
 *            schema:
 *              type: string
 *              description: >
 *                  parameter `username` dikirim di body, sesuai dengan username pengguna yang sudah terdaftar di database.
 *          - name: password
 *            in: body
 *            schema:
 *              type: string
 *              description: >
 *                  parameter `password` dikirim di body, sesuai dengan password username.
 *          - name: tipe
 *            in: body
 *            schema:
 *              type: string
 *              description: >
 *                  parameter `tipe` dikirim di body, parameter ini menyesuaikan platform yang dipakai, misal `mobile` atau `web`.
 *      tags: [LOGIN]
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
 *              description: parameter yang dikirim tidak sesuai.
 *          500:
 *              description: kesalahan pada query sql.
 *          501:
 *              description: Pool connection refused.
 */

async function Login(req, res) {
    var username = req.body.username
    var password = req.body.password
    var tipe = req.body.tipe
    // console.log('Ada yang mencoba masuk')
    // if (Object.keys(req.body).length != 3) {
    //     return res.status(405).send({
    //         message: "Sorry,  parameters not match!",
    //         error: jwtresult,
    //         data: null
    //     })
    // } else {
        console.log("Ada yang mencoba masuk...")
        try {
            pool.getConnection(function (error, database) {
                console.log("🚀 ~ file: login.controller.js:90 ~ error, database", error, database)
                if (error) {
                    return res.status(501).send({
                        message: "Sorry, your connection has refused",
                        error: error,
                        data: null
                    })
                } else {
                    var sqlquery = "SELECT * FROM pengguna WHERE username = ?"
                    database.query(sqlquery, [username], function (error, rows) {
                        database.release()
                        console.log(error, rows);
                        if (error) {
                            return res.status(407).send({
                                message: "Sorry, sql query have a problem",
                                error: error,
                                data: null
                            })
                        } else {
                            if (!rows.length) {
                                return res.status(400).send({
                                    message: "Username anda tidak ditemukan!",
                                    error: null,
                                    data: null
                                })
                            } else {
                                if (rows[0].aktif == 0) {
                                    return res.status(200).send({
                                        message: "Akun anda tidak aktif",
                                        error: null,
                                        data: null
                                    })
                                } else {
                                    // * checking password from database rows with bcrypt encryption
                                    bcrypt.compare(
                                        password,
                                        rows[0]['password'],
                                        (eErr, eResult) => {
                                            console.log(eResult)
                                            if (eErr) {
                                                console.log(eErr)
                                                return res.status(401).send({
                                                    message: 'Password anda Salah!'
                                                })
                                            } else if (eResult) {
                                                console.log("Login Berhasil")
                                                const user = {
                                                    idpengguna: rows[0].idpengguna,
                                                    username: rows[0].username,
                                                    jabatan: rows[0].jabatan,
                                                    tipe: tipe
                                                }
                                                const access_token = jwt.sign(user, process.env.ACCESS_SECRET, {
                                                    expiresIn: process.env.ACCESS_EXPIRED
                                                })
                                                const refresh_token = jwt.sign(user, process.env.REFRESH_SECRET, {
                                                    expiresIn: process.env.REFRESH_EXPIRED
                                                })
                                                refreshTokens.push(refresh_token)
                                                return res.status(200).send({
                                                    message: 'Selamat, Anda Berhasil Login',
                                                    access_token: access_token,
                                                    refresh_token: refresh_token,
                                                    nama: rows[0].nama,
                                                    username: rows[0].username,
                                                    jabatan: rows[0].jabatan
                                                })
                                            } else {
                                                return res.status(401).send({
                                                    message: 'Username atau Password salah',
                                                    error: null,
                                                    data: null
                                                })
                                            }
                                        })
                                }
                            }
                        }
                    })
                }
            })
        } catch (error) {
            res.status(403).send({
                message: "Forbidden",
                error: error
            })
        }
    // }
}

/**
 * @swagger
 * tags:
 *  name: NEWTOKEN
 *  description: API for login endpoint
 */

// * NEWTOKEN FUNCTION 

/**
 * @swagger
 * /newtoken:
 *  post:
 *      summary: api untuk regenerate token
 *      tags: [NEWTOKEN]
 *      parameters:
 *          - name: refresh_token
 *            in: body
 *            schema:
 *              type: string
 *              description: >
 *                  parameter `refresh_token` dikirim di body, refresh token didapatkan dari endpoint login pada pertama kali login
 *      responses:
 *          200:
 *              description: jika data berhasil di fetch
 *          400:
 *              description: kendala koneksi pool database
 *          405:
 *              description: parameter yang dikirim tidak sesuai.
 */

async function GenerateNewToken(req, res) {
    const refreshToken = req.body.refresh_token
    console.log("refresh token di fungsi newtoken : " + refreshTokens)
    if (refreshToken == null) {
        return res.status(405).send({
            message: "Refresh token tidak kosong!",
            error: null,
            data: null
        })
    } else {
        try {
            jwt.verify(refreshToken, process.env.ACCESS_SECRET, (jwterror, jwtresult) => {
                if (jwtresult) {
                    const user = {
                        idpengguna: decoded.idpengguna,
                        jabatan: decoded.jabatan,
                        tipe: decode.tipe
                    }
                    const accessToken = jwt.sign(user, process.env.ACCESS_SECRET, {
                        expiresIn: process.env.ACCESS_EXPIRED
                    })
                    return res.status(200).send({
                        message: 'Refresh token berhasil digenerate!',
                        error: null,
                        data: accessToken
                    })
                } else {
                    return res.status(401).send({
                        message: 'refresh token tidak valid!',
                        error: error,
                        data: null
                    })
                }
            })
        } catch (error) {
            return res.status(403).send({
                message: "Forbidden",
                error: error,
                data: null
            })
        }
    }
}

module.exports = {
    Login,
    GenerateNewToken
}