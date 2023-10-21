const jwt = require('jsonwebtoken')
require('dotenv').config()

const authToken = (req, res, next) => {
    try {
        const token = req.headers.authorization
        if (!token) {
            return res.status(403).send({ success: false, message: 'Unknown Authorization...' })
        }
        jwt.verify(token.split(' ')[1],
            process.env.ACCESS_SECRET, async (err, decode) => {
                if (err) {
                    return res.status(401).send({ success: false, message: 'Token tidak valid.' })
                }
                req.decode = decode
                next()
            })
    } catch (error) {
        return res.status(500).send({ success: false, message: 'Internal server error.' })
    }
}

module.exports = authToken