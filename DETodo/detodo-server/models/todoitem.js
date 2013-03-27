
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

/**
 * 新規アイテム
 * @param userId
 * @param listId
 * @param title
 * @param callback
 */
TodoItem.statics.createItem = function(userId, listId, title, callback) {
  var list = new this({title:title, user:userId, list:listId});
  list.save(callback);
};

/**
 * アイテムを削除
 * @param userId
 * @param id
 * @param callback
 */
TodoItem.statics.deleteItem = function(userId, id, callback) {
  this.remove({_id:id, user:userId}, callback);
};

/**
 * アイテムをアップデート
 * @param userId
 * @param id
 * @param done
 * @param callback
 */
TodoItem.statics.updateDone = function(userId, id, done, callback) {
  this.findOne({_id:id, user:userId}, function(error, item) {
    if (error) return callback(error);
    if (item) {
      item.done = done;
      return item.save(callback);
    } else {
      return callback(null, null);
    }
  });
};

/**
 * アイテム一覧
 * @param userId
 * @param listId
 * @param callback
 */
TodoItem.statics.findAllItems = function(userId, listId, callback) {
  this.find({user:userId, list:listId}, null, {sort:{createdAt:-1}}, callback);
};


mongoose.model('TodoItem', TodoItem);
