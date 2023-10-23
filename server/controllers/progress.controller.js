//Plugin
require('dotenv').config();
const jwt = require('jsonwebtoken');
const mysql = require('mysql2');
var fcmadmin = require('../utils/firebaseconfiguration');
const { ProgressModel, Sequelize } = require('../models/index.js');
const { sequelize } = require('sequelize');

var nows = {
    toSqlString: function () {
        return 'NOW()';
    },
};

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
    const token = req.headers.authorization;
    try {
        await sequelize
            .query(
                `SELECT pr.idprogress, pr.keterangan, DATE_FORMAT(pr.created, "%Y-%m-%d %H:%i") as created, DATE_FORMAT(pr.edited, "%Y-%m-%d %H:%i") as edited, pr.flag_selesai, pr.next_idpengguna as idnextuser, pr.idpengguna, pr.idpermintaan, pe.keterangan as permintaan, pe.kategori, DATE_FORMAT(pe.due_date, "%Y-%m-%d") as due_date, p.nama, pe.url_web as url_permintaan, pr.url_web as url_progress FROM permintaan pe, progress pr, pengguna p WHERE pr.idpermintaan=pe.idpermintaan AND pe.idpengguna=p.idpengguna AND pr.idpengguna = ${req.decode.idpengguna} AND pr.flag_selesai=0`
            )
            .then((result) => {
                if (!result) {
                    throw new Error(`data tidak ditemukan`);
                }
                return res
                    .status(200)
                    .send({
                        success: true,
                        message: `${result.length} data ditemukan`,
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
                message: `Internal Error: ${error.message}`,
            });
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
    const {
        keterangan,
        idpermintaan,
        idnextuser,
        tipe,
        url_web,
        keterangan_selesai,
    } = req.body;
    try {
        let dataprogress = {
            keterangan: keterangan,
            flag_selesai: 0,
            idpermintaan: idpermintaan,
            created: nows,
            url_web: url_web, //[1]
            next_idpengguna: 0,
            idpengguna: req.decode.idpengguna,
        };
        let dataprogressnext = {
            keterangan:
                'from:' + req.decode.username + ' >>' + keterangan_selesai,
            flag_selesai: 0,
            idpermintaan: idpermintaan,
            created: nows,
            url_web: url_web, //[1]
            idpengguna: idnextuser,
        };
        let data = tipe === 'nextuser' ? dataprogressnext : dataprogress
        console.log("🚀 ~ file: progress.controller.js:186 ~ addProgress ~ data:", data)
        await ProgressModel
            .create(
                data
            )
            .then((result) => {
                if (!result) {
                    throw new Error(`data gagal ditambahkan`);
                }
                return res.status(200).send({
                    success: true,
                    message: 'data berhasil ditambahkan',
                });
            })
            .catch((err) => {
                return res
                    .status(400)
                    .send({ success: false, message: err.message });
            });
    } catch (error) {
        return res.status(500).send({
            success: false,
            message: 'Internal Server Error ' + error.message,
        });
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

async function ubahProgress(req, res, next) {
    const { keterangan, flag_selesai, idnextuser, url_web } = req.body;
    const { idprogress } = req.params;
    try {
        await ProgressModel
            .update(
                {
                    keterangan,
                    flag_selesai,
                    next_idpengguna: idnextuser,
                    url_web,
                    idpengguna: req.decode.idpengguna,
                },
                { where: { idprogress: idprogress } }
            )
            .then(async (result) => {
                if (!result) {
                    throw new Error('data gagal diperbarui');
                }
                if (flag_selesai === '1' && idnextuser === '0') {
                    await ProgressModel.create({
                        keterangan: req.decode.username + ' >> ' + keterangan,
                        idpermintaan,
                        flag_selesai,
                        url_web: '',
                        idpengguna: idnextuser,
                    });
                    next();
                }
                return res.status(200).send({
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
        return res.status(500).send({
            success: false,
            message: `Internal server error ` + error.message,
        });
    }
}

// * FUNCTION Delete DATA PROGRESS

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
    const { idprogress } = req.params;
    try {
        await ProgressModel
            .destroy({ where: { idprogress } })
            .then((result) => {
                if (!result) {
                    throw new Error(`data gagal dihapus`);
                }
                return res
                    .status(200)
                    .send({ success: true, message: `data berhasil dihapus` });
            })
            .catch((err) => {
                return res
                    .status(400)
                    .send({ success: false, message: err.message });
            });
    } catch (error) {
        return res.status(500).send({ success: true, message: error.message });
    }
}

module.exports = {
    getAllProgress,
    addProgress,
    ubahProgress,
    deleteProgress,
};
