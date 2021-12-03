const express = require('express')
const app =  express()
const cors = require('cors')
const router = require('./utils/router')
const docAuth = require('express-basic-auth')
const swaggerUI = require('swagger-ui-express')
const swaggerJS = require('swagger-jsdoc')
const path = require('path')
const fs = require('fs')
// * ADDING GRAPHQL CONFIGURATION
// const { ApolloServer, gql } = require('apollo-server')
// const gqlresolver = require('./graphql/resolvers')
// const gqltypeDefs = gql(fs.readFileSync('./graphql/typeDefs.graphql', { encoding: 'utf-8' }))
// const gqlserver = new ApolloServer({gqltypeDefs, gqlresolver})
// gqlserver.listen(process.env.GQL_API_PORT).then(({url})=>{console.log('Api is reade to use...', url)})

// * ADDING FIREBASE CONFIGURATION
// var admin = require("firebase-admin");
// var serviceAccount = require("./utils/bnlrms-firebase-token.json")
// * ADDING CREDENTIAL FIREBASE ACCOUNT
// admin.initializeApp({
//   credential: admin.credential.cert(serviceAccount)
// });


// * setting up express or api to json type
app.use(express.json())
app.use(express.urlencoded({extended: true}))
app.use(cors())
// * allow image access for public
app.use('/images', express.static(path.join(__dirname, '/images')))
// * base url for api
app.use('/api/v1', router)
// * swagger documentation
const swaggerDOC = {
    definition:{
        openapi: "3.0.3",
        info: {
            title: "Documentation page of api RMS BNL Patent",
            version: "1.0.0",
            description: "This is documentation for RMS apps",
            contact: {
                "email": "info.cvdtc@gmail.com",
                "url": 'cvdtc.com'
            }
        },
        server: [
            {
                url: process.env.DB_HOST,
                description: 'LOCAL'
            }
        ]
    },
    apis: ['./controllers/*.js']
}
const specs = swaggerJS(swaggerDOC)
app.use('/secret-docs-api', docAuth({
    users:{
        'admindoc': 'hanyaadmindocyangtau'
    }, 
    challenge: true
}), swaggerUI.serve, swaggerUI.setup(specs))
// ! starting node with port 
app.listen(process.env.API_PORT, () => console.log('Success running api CMMS on ', process.env.TYPE_OF_DEPLOYMENT, 'in PORT ', process.env.API_PORT, 'Version', process.env.API_VERSION))