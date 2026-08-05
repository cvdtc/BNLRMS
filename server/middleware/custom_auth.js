require('dotenv').config()

const customAuthToken = (req, res, next) => {
    try {
        const token = req.headers.authorization.split(' ')[1]
        if (!token) {
            return res.status(403).send({ success: false, message: 'Unknown Authorization...' })
        }
        if(token !== process.env.INJENCT_ACCESS_SECRET) {
            return res.status(401).send({ success: false, message: 'Invalid Authorization Token...' })
        }
        next()
    } catch (error) {
        return res.status(500).send({ success: false, message: 'Internal server error.' })
    }
}

module.exports = customAuthToken