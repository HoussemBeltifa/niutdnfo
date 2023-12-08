const mongoose = require("mongoose");

const discussionschema = new mongoose.Schema({
 liker:{
    type:mongoose.Types.ObjectId,ref:'user'
 },
 liked:{ type:mongoose.Types.ObjectId,ref:'user'},
  lastmessage:{type:mongoose.Types.ObjectId,ref:'Message'},
 
},{timestamp: true
   
});

const Like = mongoose.model("like", discussionschema);

module.exports = {Like};
