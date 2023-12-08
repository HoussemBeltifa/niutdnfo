const mongoose = require("mongoose");
const sources=['google','facebook','phone','local'];

let dataSchema = new mongoose.Schema({
    
    user: {
        type : mongoose.Types.ObjectId , ref:'User',unique :true
    },
    code: 
       {type: String,required:true}
    }
    ,{timestamp: true
   
    }


)


module.exports = mongoose.model("PhoneUser", dataSchema)