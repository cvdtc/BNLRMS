const express = require('express');
const app = express();
const cors = require('cors');
const router = require('./utils/router');
const docAuth = require('express-basic-auth');
const swaggerUI = require('swagger-ui-express');
const swaggerJS = require('swagger-jsdoc');
const path = require('path');
const fs = require('fs');
const cron = require('node-cron');
const mysql = require('mysql2');
var fcmadmin = require('./utils//firebaseconfiguration');
const pool = mysql.createPool({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME,
    port: process.env.DB_PORT,
    connectionLimit: 10,
    queueLimit: 25,
    timezone: 'utc-8',
});

// * ADDING GRAPHQL CONFIGURATION
// const { ApolloServer, gql } = require('apollo-server')
// const gqlresolver = require('./graphql/resolvers')
// const gqltypeDefs = gql(fs.readFileSync('./graphql/typeDefs.graphql', { encoding: 'utf-8' }))
// const gqlserver = new ApolloServer({gqltypeDefs, gqlresolver})
// gqlserver.listen(process.env.GQL_API_PORT).then(({url})=>{console.log('Api is reade to use...', url)})

// * ADDING FIREBASE CONFIGURATION
// var admin = require("firebase-admin")
// var serviceAccount = require("./utils/bnlrms-firebase-token.json")
// * ADDING CREDENTIAL FIREBASE ACCOUNT
// admin.initializeApp({
//   credential: admin.credential.cert(serviceAccount)
// })

// * setting up express or api to json type
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cors());
// * allow image access for public
app.use('/images', express.static(path.join(__dirname, '/images')));
// * base url for api
app.use('/api/v1', router);
// * swagger documentation
const swaggerDOC = {
    definition: {
        openapi: '3.0.3',
        info: {
            title: 'Documentation page of api RMS BNL Patent',
            version: '1.0.0',
            description: 'This is documentation for RMS apps',
            contact: {
                email: 'info.cvdtc@gmail.com',
                url: 'cvdtc.com',
            },
        },
        server: [
            {
                url: process.env.DB_HOST,
                description: 'LOCAL',
            },
        ],
    },
    apis: ['./controllers/*.js'],
};
const specs = swaggerJS(swaggerDOC);
app.use(
    '/secret-docs-api',
    docAuth({
        users: {
            admindoc: 'hanyaadmindocyangtau',
        },
        challenge: true,
    }),
    swaggerUI.serve,
    swaggerUI.setup(specs)
);
// ! starting node with port
app.listen(process.env.API_PORT, () =>
    console.log(
        'Success running api CMMS on ',
        process.env.TYPE_OF_DEPLOYMENT,
        'in PORT ',
        process.env.API_PORT,
        'Version',
        process.env.API_VERSION
    )
);

// ! make cron to close overdue request
cron.schedule('1 0 * * *', (req, res) => {
    try {
        pool.getConnection(function (error, database) {
            if (error) {
                console.log('Connection cron set overdue refuse', error);
            } else {
                var sqlquery =
                    'update permintaan set flag_selesai=2 where flag_selesai=0 and due_date<date(now())';
                database.query(sqlquery, (error, rows) => {
                    database.release();
                    if (error) {
                        console.log(
                            'Query error cron set overdue refuse',
                            error
                        );
                    } else {
                        database.commit(function (err) {
                            if (err) {
                                console.log(
                                    'Error commit cron set overdue refuse',
                                    error
                                );
                            } else {
                                console.log('Close permintaan overdue success');
                                database.release();
                            }
                        });
                    }
                });
            }
        });
    } catch (err) {
        console.log('Error: ' + err);
    }
});

// ! make cron to send notif every 7 am to user with due date -1 day
cron.schedule('0 4,12,20 * * *', () => {
    console.log('cron has started 1');
    try {
        pool.getConnection(function (error, database) {
            if (error) {
                console.log('Connection cron refuse', error);
            } else {
                console.log('cron has started 2');
                var sqlquery =
                    'select a.*, b.nama from permintaan a, pengguna b where a.idpengguna=b.idpengguna and flag_selesai=0 and (DATEDIFF(due_date,now())=0 or DATEDIFF(due_date,now())=1);';
                database.query(sqlquery, (error, result) => {
                    database.release();
                    if (error) {
                        console.log('error cron query ', error);
                    } else {
                        result.forEach((element) => {
                            // * send notif
                            let notificationMessage = {
                                notification: {
                                    title: `Hi, ada permintaan ${element.nama}} yang akan expired.`,
                                    body: `Perpanjang atau Selesaikan permintaan : ${element.keterangan}`,
                                    sound: 'default',
                                    click_action: 'FCM_PLUGIN_ACTIVITY',
                                },
                                data: {
                                    title: `Hi, ada permintaan ${element.nama}} yang akan expired.`,
                                    body: `Perpanjang atau Selesaikan permintaan : ${element.keterangan}`,
                                },
                            };
                            fcmadmin
                                .messaging()
                                .sendToTopic(
                                    'RMSPERMINTAAN',
                                    notificationMessage
                                )
                                .then(function (response) {
                                    console.log('cron has started 3');
                                    console.log(
                                        'Notifikasi cron permintaan expired berhasil dikirim',
                                        response
                                    );
                                })
                                .catch(function (error) {
                                    console.log(
                                        'Notifikasi gagal dikirim : ',
                                        error
                                    );
                                });
                        });
                    }
                });
            }
        });
    } catch (err) {
        console.log('Error: ' + err);
    }
});
