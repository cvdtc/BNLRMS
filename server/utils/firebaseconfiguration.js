var fcmadmin = require('firebase-admin')
var serverKey = require('./bnlrms-firebase-token.json')
fcmadmin.initializeApp({
    credential: fcmadmin.credential.cert(serverKey)
})

module.exports = fcmadmin