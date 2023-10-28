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
    connectionLimit: 50,
    queueLimit: 100,
    timezone: 'utc-8'
})

const pool1 = mysql.createPool({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME1,
    port: process.env.DB_PORT,
    connectionLimit: 50,
    queueLimit: 100,
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
                        // var sqlquery = "SELECT 1 AS tipe, pe.keterangan, pe.kategori, pe.due_date, pe.created, pe.edited, pe.flag_selesai, pe.keterangan_selesai, pe.idpengguna_close_permintaan, '-' AS prg_keterangan, '-' AS prg_created, '-' AS prg_edited, '-' AS prg_flag_selesai, p.nama as nama_request, '-' as nama_progress FROM permintaan pe, pengguna p WHERE p.idpengguna=pe.idpengguna AND pe.idpermintaan=? UNION SELECT 2 AS tipe, '-' as keterangan, '-' as kategori, '-' as due_date, '-' as created, '-' as edited, '-' as flag_selesai, '-' as keterangan_selesai, '-' as idpengguna_close_permintaan, prg.keterangan AS prg_keterangan, prg.created AS prg_created, prg.edited AS prg_edited, prg.flag_selesai AS prg_flag_selesai, '-' as nama_request, p.nama as nama_progress FROM progress prg , pengguna p WHERE p.idpengguna=prg.idpengguna and prg.idpermintaan=?"
                        var sqlquery = "SELECT 1 AS tipe, pe.keterangan, pe.kategori, pe.due_date, pe.created, pe.edited, pe.idpengguna_close_permintaan, '-' AS prg_keterangan, '-' AS prg_created, '-' AS prg_edited, '-' AS prg_flag_selesai, p.nama as nama_request, '-' as nama_progress, '-' AS flag_selesai, '-' AS keterangan_selesai, '-' as nama_close_permintaan,'-' as date_selesai, url_web as url_permintaan, '-' as url_progress FROM permintaan pe, pengguna p WHERE p.idpengguna=pe.idpengguna AND pe.idpermintaan=? UNION SELECT 2 AS tipe, '-' as keterangan, '-' as kategori, '-' as due_date, '-' as created, '-' as edited, '-' as idpengguna_close_permintaan, prg.keterangan AS prg_keterangan, prg.created AS prg_created, prg.edited AS prg_edited, prg.flag_selesai AS prg_flag_selesai, '-' as nama_request, p.nama as nama_progress, '-' AS flag_selesai, '-' AS keterangan_selesai, '-' as nama_close_permintaan, '-' as date_selesai, '-' as url_permintaan, url_web as url_progress FROM progress prg , pengguna p WHERE p.idpengguna=prg.idpengguna and prg.idpermintaan=? UNION SELECT 3 AS tipe, '-' as keterangan, '-' as kategori, '-' as due_date, '-' as created, '-' as edited, '-' as idpengguna_close_permintaan, '-' AS prg_keterangan, '-' AS prg_created, '-' AS prg_edited, '-' AS prg_flag_selesai, '-' as nama_request, '-' as nama_progress, pr.flag_selesai, pr.keterangan_selesai, pe.nama as nama_close_permintaan, pr.date_selesai, '-' as url_permintaan, '-' as url_progress FROM permintaan pr, pengguna pe WHERE pe.idpengguna=pr.idpengguna and flag_selesai=1 and idpermintaan = ?;"
                        database.query(sqlquery,[idpermintaan, idpermintaan, idpermintaan], (error, rows) => {
                            database.release()
                            if (error) {
                                return res.status(500).send({
                                    message: "Sorry, query has error!",
                                    error: error,
                                    data: null
                                })
                            } else {
                                if (rows.length <= 0) {
                                    return res.status(204).send({
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
    } } else {
        res.status(401).send({
            message: "Sorry, Need Token Validation!",
            error: null,
            data: null
        })
    }
}


// * FUNCTION GET DASHBOARD

/**
 * @swagger
 * /dashboard:
 *  get:
 *      summary: untuk menampilkan jumlah data permintaan selesau dan belum selesai, [header token]
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

 async function getDashboard(req, res) {
    const token = req.headers.authorization
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
                        var filter = (jwtresult.jabatan =="Marketing")? (" and idpengguna="+jwtresult.idpengguna) : ("")
                        var sqlquery = "SELECT (SELECT COUNT(idpermintaan) FROM permintaan WHERE flag_selesai<>''"+filter+") AS jumlah, (SELECT COUNT(idpermintaan) FROM permintaan WHERE flag_selesai=1"+filter+") AS sudah_selesai, (SELECT COUNT(idpermintaan) FROM permintaan WHERE flag_selesai=0"+filter+") AS belum_selesai;"
                        database.query(sqlquery, (error, rows) => {
                            database.release()
                            if (error) {
                                return res.status(500).send({
                                    message: "Sorry, query has error!",
                                    error: error,
                                    data: null
                                })
                            } else {
                                if (rows.length <= 0) {
                                    return res.status(204).send({
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
    } } else {
	console.log("Need token");
        res.status(401).send({
            message: "Sorry, Need Token Validation!",
            error: null,
            data: null
        })
    }
}

async function getPerpanjangan(req, res) {
    const token = req.headers.authorization
    if (token != null) {     try {
        jwt.verify(token.split(' ')[1], process.env.ACCESS_SECRET, (jwterror, jwtresult) => {
            if (!jwtresult) {
                res.status(401).send(JSON.stringify({
                    message: "Sorry, Your token has expired!",
                    error: jwterror,
                    data: null
                }))
            } else {
                pool1.getConnection(function (error, database) {
                    if (error) {
                        return res.status(400).send({
                            message: "Sorry, your connection has refused!",
                            error: error,
                            data: null
                        })
                    } else {
                        var filter = (jwtresult.jabatan =="Marketing")? (" and a.SALES='"+jwtresult.sales+"'") : ("")
                        console.log("Kode Sales "+filter);
var sqlquery = "select DATE_FORMAT(b.TANGGALS, '%d %M %Y') as TGLSERTIFIKAT, DATE_FORMAT(a.TANGGALP,'%d %M %Y') as TGLPERPANJANGAN, concat(a.DESKRIPSI, ' (', b.KODE1, ')') as PRODUK, KELAS, NAMA, SALES from (select KODE1, a.MEREK, TANGGAL as TANGGALP, merek.DESKRIPSI, customer.NAMA, merek.KELAS, customer.SALES from dokumenmerek a, merek, customer where a.MEREK=merek.KODE and merek.CUSTOMER=customer.KODE and a.JENIS=2 and DATE_ADD(TANGGAL1, INTERVAL 10 YEAR) between DATE_ADD(NOW(), INTERVAL -6 MONTH) and DATE_ADD(NOW(), INTERVAL 6 MONTH) and a.MEREK not in (select MEREK from dokumenmerek where JENIS=8 or JENIS=-99))a LEFT join (select MEREK, KODE1, TANGGAL1 as TANGGALS from dokumenmerek where JENIS=6)b on a.MEREK=b.MEREK where b.KODE1 is not null "+filter+" ORDER BY a.TANGGALP";
//                        var sqlquery = "SELECT DATE_FORMAT(a.TANGGALS, '%d %M %Y') as TGLSERTIFIKAT, DATE_FORMAT(DATE_ADD(a.TANGGALS, INTERVAL 10 YEAR), '%d %M %Y') as TGLPERPANJANGAN, CONCAT(merek.DESKRIPSI, ' (', a.merek, ')') as PRODUK, merek.KELAS, customer.NAMA, customer.SALES FROM (select * from (select MEREK, MAX(TANGGAL) as TANGGALS, JENIS from dokumenmerek where MEREK NOT IN (select MEREK from dokumenmerek where JENIS=-99) and JENIS in (6,8) GROUP BY MEREK)a where DATE_ADD(TANGGALS, INTERVAL 10 YEAR) between DATE_ADD(NOW(), INTERVAL -6 MONTH) and DATE_ADD(NOW(), INTERVAL 6 MONTH))a, merek, customer where a.MEREK=merek.KODE and merek.CUSTOMER=customer.KODE"+filter+" ORDER BY a.TANGGALS"
                        database.query(sqlquery, (error, rows) => {
                            database.release()
                            if (error) {
                                return res.status(500).send({
                                    message: "Sorry, query has error!",
                                    error: error,
                                    data: null
                                })
                            } else {
                                if (rows.length <= 0) {
                                    return res.status(204).send({
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
    } } else {
        res.status(401).send({
            message: "Sorry, Need Token Validation!",
            error: null,
            data: null
        })
    }
}


async function getMerekInternasionalDashboard(req, res) {
    const token = req.headers.authorization;
    if (!token) {
        return res
            .status(401)
            .send({ message: 'Sorry, Need Token Validation!' });
    }
    try {
        jwt.verify(
            token.split(' ')[1],
            process.env.ACCESS_SECRET,
            (jwterror, jwtresult) => {
                if (!jwtresult) {
                    return res.status(401).send(
                        JSON.stringify({
                            message: 'Sorry, Your token has expired!',
                            error: jwterror,
                            data: null,
                        })
                    );
                } else {
                    pool1.getConnection(function (error, database) {
                        if (error) {
                            return res.status(400).send({
                                message: 'Sorry, your connection has refused!',
                                error: error,
                                data: null,
                            });
                        } else {
                            var sqlquery =
                                'select m.KODE, m.DESKRIPSI, m.kelas, m.KET_KELAS, m.CUS_NAMA, m.CUSTOMER from merek m, merek_ln ml where m.KODE=ml.KODE;';
                            database.query(
                                sqlquery,
                                [jwtresult.idpengguna],
                                (error, rows) => {
                                    database.release();
                                    if (error) {
                                        return res.status(500).send({
                                            message: 'Sorry, query has error!',
                                            error: error,
                                            data: null,
                                        });
                                    } else {
                                        if (rows.length <= 0) {
                                            return res.status(200).send({
                                                message: 'Sorry, data empty!',
                                                error: null,
                                                data: rows,
                                            });
                                        } else {
                                            return res.status(200).send({
                                                message:
                                                    'Done!, data has fetched!',
                                                error: null,
                                                data: rows,
                                            });
                                        }
                                    }
                                }
                            );
                        }
                    });
                }
            }
        );
    } catch (error) {
        return res.status(403).send({
            message: 'Forbidden.',
            data: rows,
        });
    }
}

async function getMerekInternasional(req, res) {
    const token = req.headers.authorization;
    if (!token) {
        return res
            .status(401)
            .send({ message: 'Sorry, Need Token Validation!' });
    }
    try {
        jwt.verify(
            token.split(' ')[1],
            process.env.ACCESS_SECRET,
            (jwterror, jwtresult) => {
                if (!jwtresult) {
                    return res.status(401).send(
                        JSON.stringify({
                            message: 'Sorry, Your token has expired!',
                            error: jwterror,
                            data: null,
                        })
                    );
                } else {
                    pool1.getConnection(function (error, database) {
                        if (error) {
                            return res.status(400).send({
                                message: 'Sorry, your connection has refused!',
                                error: error,
                                data: null,
                            });
                        } else {
                            var sqlquery =
                                'select m.KODE, m.DESKRIPSI, m.kelas, m.KET_KELAS, m.CUS_NAMA, m.CUSTOMER from merek m, merek_ln ml, files f where m.KODE=ml.KODE and m.KODE=f.KODE;';
                            database.query(
                                sqlquery,
                                [jwtresult.idpengguna],
                                (error, rows) => {
                                    database.release();
                                    if (error) {
                                        return res.status(500).send({
                                            message: 'Sorry, query has error!',
                                            error: error,
                                            data: null,
                                        });
                                    } else {
                                        if (rows.length <= 0) {
                                            return res.status(200).send({
                                                message: 'Sorry, data empty!',
                                                error: null,
                                                data: rows,
                                            });
                                        } else {
                                            console.log('Convert BLOB?',rows);
                                            return res.status(200).send({
                                                message:
                                                    'Done!, data has fetched!',
                                                error: null,
                                                data: rows,
                                            });
                                        }
                                    }
                                }
                            );
                        }
                    });
                }
            }
        );
    } catch (error) {
        return res.status(403).send({
            message: 'Forbidden.',
            data: rows,
        });
    }
}


async function getTimelineMerekInternasional(req, res) {
    const token = req.headers.authorization;
    const { kode } = req.params;
    if (!token) {
        return res
            .status(401)
            .send({ message: 'Sorry, Need Token Validation!' });
    }
    try {
        jwt.verify(
            token.split(' ')[1],
            process.env.ACCESS_SECRET,
            (jwterror, jwtresult) => {
                if (!jwtresult) {
                    return res.status(401).send(
                        JSON.stringify({
                            message: 'Sorry, Your token has expired!',
                            error: jwterror,
                            data: null,
                        })
                    );
                } else {
                    pool1.getConnection(function (error, database) {
                        if (error) {
                            return res.status(400).send({
                                message: 'Sorry, your connection has refused!',
                                error: error,
                                data: null,
                            });
                        } else {
                            var sqlquery = `select m.KODE, m.DESKRIPSI, m.kelas, m.KET_KELAS, n.DESKRIPSI as ngr, s.DESKRIPSI as statusd, DATE_FORMAT(dm.TANGGAL, '%d %M %Y') as tgldoc, dm.KODE1 as nodoc, dm.DESKRIPSI as ketd  from merek m, dokumenmerek dm, dokumenmerekln dmln, negara n, status s where m.KODE=dm.MEREK and dm.KODE=dmln.KODE and dmln.NEGARA_KODE=n.KODE and dm.JENIS=s.KODE and m.KODE='${kode}' ORDER BY dm.tanggal ASC;`;
                            database.query(
                                sqlquery,
                                [jwtresult.idpengguna],
                                (error, rows) => {
                                    database.release();
                                    if (error) {
                                        return res.status(500).send({
                                            message: 'Sorry, query has error!',
                                            error: error,
                                            data: null,
                                        });
                                    } else {
                                        if (rows.length <= 0) {
                                            return res.status(200).send({
                                                message: 'Sorry, data empty!',
                                                error: null,
                                                data: rows,
                                            });
                                        } else {
                                            return res.status(200).send({
                                                message:
                                                    'Done!, data has fetched!',
                                                error: null,
                                                data: rows,
                                            });
                                        }
                                    }
                                }
                            );
                        }
                    });
                }
            }
        );
    } catch (error) {
        return res.status(403).send({
            message: 'Forbidden.',
            data: error,
        });
    }
}

module.exports = {
    getTimeline,
    getDashboard,
    getPerpanjangan,
    getMerekInternasionalDashboard,
    getMerekInternasional,
    getTimelineMerekInternasional,
}
