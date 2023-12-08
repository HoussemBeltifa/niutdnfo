const mongoose = require("mongoose");

const MatchSchema = new mongoose.Schema({

 users:[{ type:mongoose.Types.ObjectId,ref:'user'}],

 
},{timestamp: true
   
});

const Match = mongoose.model("match", MatchSchema);

module.exports = {Match};
