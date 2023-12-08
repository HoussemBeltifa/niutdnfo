const mongoose = require("mongoose");

const discussionschema = new mongoose.Schema({
 disliker:{
    type:mongoose.Types.ObjectId,ref:'user'
 },
 disliked:{ type:mongoose.Types.ObjectId,ref:'user'},
  lastmessage:{type:mongoose.Types.ObjectId,ref:'Message'},

},{timestamp: true
   
});

const DisLike = mongoose.model("dislike", discussionschema);

module.exports = {DisLike};
