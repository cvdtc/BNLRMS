const mysql = require('mysql');
const { saveAsJpg } = require('../utils/blobtojpg');
const fs = require('fs');
const path = require('path');

/**
 * ! Pool setting up
 * * pool connection limit 10
 * * queue limit 25
 */

const pool = mysql.createPool({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME1,
    port: process.env.DB_PORT,
    connectionLimit: 10,
    queueLimit: 25,
    timezone: 'utc-8',
});

 async function statusPermohonan  (req, res){
    const { kodePermohonan } = req.params;
    try {
        pool.getConnection((err, connection) => {
            if (err) {
                return res
                    .status(500)
                    .send({
                        success: false,
                        message: 'Database connection error.',
                    });
            } else {
                const sqlQuery = `select IF(JENIS=2, 'PERMOHONAN', IF(JENIS=4, 'USUL TOLAK', IF(JENIS=5, 'PUBLIKASI', IF(JENIS=6, 'SERTIFIKAT', IF(JENIS=21, 'TOLAK DEFINITIF', 'OTHER'))))) as tipe,KODE1 as NOMOR, DATE_FORMAT(TANGGAL,'%Y-%m-%d') as TANGGAL,  DATE_FORMAT(TANGGAL1,'%Y-%m-%d') AS TANGGAL1, m.DESKRIPSI as NamaMerek, m.KELAS as Kelas, m.KET_KELAS as DeskripsiKelas, m.CUS_NAMA as Customer, f.FILE as Logo, m.KODE as KODE_MEREK from dokumenmerek dm, merek m, files f where dm.MEREK=m.KODE and m.KODE = f.kode and dm.MEREK in (select MEREK from dokumenmerek where KODE1='${kodePermohonan}') and JENIS in (2,4,5,6,21);`;
                connection.query(sqlQuery, (err, rows) => {
                    if (err) {
                        return res
                            .status(500)
                            .send({
                                success: false,
                                message: 'Database query error.',
                            });
                    }

                    // convert blob to jpg file
                    rows.forEach((row) => {
                        if (row.Logo) {
                            // check file is exist
                            const filenameCheck = `${row.KODE_MEREK.replace(/[^a-zA-Z0-9]/g, '_')}.jpg`;
                            const filePathCheck = path.join(__dirname, '..', 'public', filenameCheck);
                            if (fs.existsSync(filePathCheck)) {
                                row.logoUrl = process.env.LOGOURL+':'+process.env.API_PORT+'/public/'+filenameCheck;
                                delete row.Logo;
                                delete row.KODE_MEREK;
                                console.log('File already exists, skipping creation:', filenameCheck);  
                                return;
                            }
                            // filename without space oror special characters
                            const filename = `${row.KODE_MEREK.replace(/[^a-zA-Z0-9]/g, '_')}.jpg`;
                            row.logoUrl = process.env.LOGOURL+':'+process.env.API_PORT+'/public/'+filename;
                            saveAsJpg(row.Logo, filename);
                            delete row.KODE_MEREK;
                            delete row.Logo;
                        }
                    });

                    return res.status(200).send({ success: true, data: rows });
                });
            }
            // close connection
            connection.release();
        });
    } catch (error) {
        console.log(error);
        return res
            .status(500)
            .send({ success: false, message: 'Internal server error.' });
    }
};

module.exports = {
    statusPermohonan,
};