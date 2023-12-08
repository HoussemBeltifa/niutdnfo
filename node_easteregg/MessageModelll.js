const mongoose = require("mongoose");

const messageSchema = new mongoose.Schema({
  senderId: {
    type: mongoose.Schema.Types.ObjectId, // Assuming you have a User model
    ref: "User", // Replace with the actual name of your User model
    required: true,
  },
  discussion:{type:mongoose.Types.ObjectId,ref:'Discussion'},
 


  messageText: {
    type: String,
    required: true,
  }}

 ,{timestamps: true
   
});

const Messaged = mongoose.model("Messages", messageSchema);

module.exports = {Messaged};
