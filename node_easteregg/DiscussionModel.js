const mongoose = require("mongoose");

const discussionschema = new mongoose.Schema({
  users: [{
    type: mongoose.Schema.Types.ObjectId, // Assuming you have a User model
    ref: "User", // Replace with the actual name of your User model

  }],
  lastmessage:{type:mongoose.Types.ObjectId,ref:'Message'},
  timestamp: {
    type: Date,
    default: Date.now,
  },

} ,{
    toJSON: { virtuals: true },
    toObject: { virtuals: true }
});
discussionschema.virtual('messages', {
    ref: 'Messagez',
    localField: '_id',
    foreignField: 'discussion',

  });

const Discussion = mongoose.model("Discussion", discussionschema);

module.exports = {Discussion};
