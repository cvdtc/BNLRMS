//Plugin
require('dotenv').config()
const jwt = require('jsonwebtoken')
const bcrypt = require('bcrypt')
const { PenggunaModel } = require('../models/index.js')

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
    const { username, password, tipe } = req.body
    try {
        await PenggunaModel.findOne({ where: { username } }).then((result) => {
            if (!result) {
                throw new Error(`Could not find ${username}`)
            }
            if (result.dataValues.aktif == 0) {
                throw new Error(`your account has disabled administrator`)
            }
            bcrypt.compare(password, result.dataValues.password, (error, resultPassword) => {
                if (!resultPassword) {
                    return res.status(401).send({ success: false, message: "Your password is incorrect" })
                }
                const user = {
                    idpengguna: result.idpengguna,
                    username: result.username,
                    jabatan: result.jabatan,
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
                    user
                })
            })
        }).catch((err) => {
            return res.status(400).send({ success: false, message: err.message })
        });
    } catch (error) {
        res.status(500).send({
            message: "Internal Server Error",
            error: error
        })
    }
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