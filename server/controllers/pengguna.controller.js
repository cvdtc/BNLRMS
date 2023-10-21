//Plugin
require('dotenv').config();
const bcrypt = require('bcrypt');
const { PenggunaModel } = require('../models/index.js');

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
  try {
    await PenggunaModel.findAll()
      .then((result) => {
        if (!result) {
          throw new Error(`data tidak ditemukan`);
        }
        return res
          .status(200)
          .send({
            status: true,
            message: `${result.length} data ditemukan`,
            data: result,
          });
      })
      .catch((err) => {
        return res
          .status(400)
          .send({ status: false, message: err.message });
      });
  } catch (error) {
    return res.status(500).send({
      status: false,
      message: 'Internal Server Error : ' + err.message,
    });
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
  const { nama, username, password, jabatan, notification_token, aktif } =
    req.body;
  try {
    await PenggunaModel.create({
      nama,
      username,
      password: await bcrypt.hash(password, 9),
      jabatan,
      notification_token,
      aktif,
      last_login: new Date().toISOString().replace('T', ' '),
    })
      .then((result) => {
        if (!result) {
          throw new Error('Data gagal ditambahkan');
        }
        return res
          .status(201)
          .send({
            success: true,
            message: `Data ${nama} berhasil ditambahkan`,
          });
      })
      .catch((err) => {
        return res
          .status(400)
          .send({ success: false, message: err.message });
      });
  } catch (error) {
    return res
      .status(500)
      .send({
        success: false,
        message: 'Internal server error ' + error.message,
      });
  }
}

// * FUNCTION CHANGE DATA PENGGUNA

/**
 * @swagger
 * /pengguna:
 *  put:
 *      summary: endpoint API mengubah data pengguna.
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

async function ubahPengguna(req, res) {
  const { nama, username, password, jabatan, notification_token, aktif } =
    req.body;
  const { idpengguna } = req.params;
  try {
    await PenggunaModel.update(
      {
        nama,
        username,
        password: await bcrypt.hash(password, 9),
        jabatan,
        notification_token,
        aktif,
      },
      { where: { idpengguna: idpengguna } }
    )
      .then((result) => {
        if (!result) {
          throw new Error(`Data gagal diperbarui`);
        }
        return res
          .status(200)
          .send({
            success: true,
            message: 'data berhasil diperbarui',
          });
      })
      .catch((err) => {
        return res
          .status(400)
          .send({ success: false, message: err.message });
      });
  } catch (error) {
    return res
      .status(500)
      .send({
        success: false,
        message: 'Internal server error ' + error.message,
      });
  }
}

module.exports = {
  getAllPengguna,
  addPengguna,
  ubahPengguna,
};
