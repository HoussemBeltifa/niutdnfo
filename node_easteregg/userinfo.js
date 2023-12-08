const mongoose = require("mongoose");
const sources=['google','facebook','phone','local'];

let dataSchema = new mongoose.Schema({

    'email': {
        required: true,
        unique:true,
        type: String
    },
    'password': {
        required: true,
        type: String
    },
    salt:{type:String},
    source:{type:String},
    is_activated:{
        type:Boolean,
        default:true
    },
    is_completed:{
        type:Boolean,
        default:true
    },
    token: String,
},
    {
        timestamp: true,
   
        
        toJSON: { virtuals: true },
        toObject: { virtuals: true }
    }
);
dataSchema.virtual('profile', {
    justOne:true,
    ref: 'profileUser',
    localField: '_id',
    foreignField: 'user',

  });

module.exports = mongoose.model("User", dataSchema)