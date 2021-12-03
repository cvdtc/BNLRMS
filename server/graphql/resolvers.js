const { note, pengguna, permintaan, progress } = require('../models')
const Query = {
    // * NOTE
    // ++ get data note by idpengguna
    getNoteByIdPengguna: async (root, {idpengguna}) => {
        try {
            const notes = await note.findOne({where: {idpengguna}})
            return notes
        } catch (error) {
            console.log(error)
        }
    },

    // * PENGGUNA
    // ++ get all data
    getPengguna: async() => {
        try {
            const penggunas = await pengguna.findAll()
            return penggunas
        } catch (error) {
            console.log(error)
        }
    }
}

const Mutation = {
    // * NOTE
    // ++ create note
    createNote: async(root, {keterangan, flag_selesai, idpengguna}) => {
        try{
            await note && note.create({keterangan, flag_selesai, idpengguna})
            return "Note Berhasil dibuat!"
        }catch(error){
            console.log(error)
        }
    }
}

module.exports = (Query, Mutation)