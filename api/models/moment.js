var mongoose = require('mongoose'),
    Schema = mongoose.Schema,
    autoIncrement = require('mongoose-auto-increment');

autoIncrement.initialize(mongoose);

var momentSchema = new Schema({
  id: String,
  content: {type: String, required: true },
  author: {type: String, required: false },
  recipients: {type: [String], required: true },
  creationDate: { type: Date, required: true, default: Date.now },
  deliveryDate: { type: Date, required: true }
});

momentSchema.plugin(autoIncrement.plugin, 'Moment');
var Moment = mongoose.model('Moment', momentSchema, 'Moments');

exports.Moment = Moment;