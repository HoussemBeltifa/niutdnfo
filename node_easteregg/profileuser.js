const mongoose = require("mongoose");
const sources=['google','facebook','phone','local'];

let dataSchema = new mongoose.Schema({
    'fname': {
        required: false,
        type: String
    },
    'lname': {
        required: false,
        type: String
    },
    'age': {
        required: false,
        type: String
    },
    'phone': {
        required: false,
        type: String
    },
    user: {
        type : mongoose.Types.ObjectId , ref:'User',unique :true
    },
    image: [
        String
    ]}
)


module.exports = mongoose.model("profileUser", dataSchema)