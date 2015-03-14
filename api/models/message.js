var mongoose = require('mongoose'),
    Schema = mongoose.Schema,
    autoIncrement = require('mongoose-auto-increment');

autoIncrement.initialize(mongoose);

var messageSchema = new Schema({
  id: String,
  content: {type: String, required: true },
  author: {type: String, required: true },
  recipients: {type: [String], required: true },
  creationDate: { type: Date, required: true, default: Date.now },
  deliveryDate: { type: Date, required: true, default: Date.now }
});

messageSchema.plugin(autoIncrement.plugin, 'Message');
var Message = mongoose.model('Message', messageSchema, 'Messages');

exports.Message = Message;