
var mongoose = require('mongoose'),
  Schema = mongoose.Schema,
  ObjectId = Schema.ObjectId;

var TodoItem = new Schema({
  user: {type: ObjectId, required:true, ref:'User'},
  list: {type: ObjectId, required:true, ref:'TodoList'},
  title: {type: String, required: true},
  done: {type: Boolean, required:true, default:false},
  createdAt: {type: Date}
});

TodoItem.pre('save', function(next) {
  if(this.isNew) {
    this.createdAt = new Date();
  }
  next();
});

TodoItem.statics.createItem = function(userId, listId, title, callback) {
  var list = new this({title:title, user:userId, list:listId});
  list.save(callback);
};

TodoItem.statics.deleteItem = function(id, callback) {
  this.remove({_id:id}, callback);
};

TodoItem.statics.updateDone = function(id, done, callback) {
  this.findById(id, function(error, item) {
    if (error) return callback(error);
    item.done = done;
    item.save(callback);
  });
};

TodoItem.statics.findAllItems = function(userId, listId, callback) {
  this.find({user:userId, list:listId}, callback);
};


mongoose.model('TodoItem', TodoItem);
