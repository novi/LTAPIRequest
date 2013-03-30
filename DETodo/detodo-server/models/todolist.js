var mongoose = require('mongoose'),
  Schema = mongoose.Schema,
  ObjectId = Schema.ObjectId;

var TodoList = new Schema({
  user: {type: ObjectId, required:true, ref:'User'},
  title: {type: String, required: true},
  createdAt: {type: Date}
});

TodoList.pre('save', function(next) {
  if(this.isNew) {
    this.createdAt = new Date();
  }
  next();
});

/**
 * 新規リスト
 * @param userId
 * @param title
 * //@param callback
 */
TodoList.statics.createList = function(userId, title, callback) {
  var list = new this({title:title, user:userId});
  list.save(callback);
};


/**
 * リスト一覧
 * @param userId
 * //@param callback
 */
TodoList.statics.findAllList = function(userId, callback) {
  this.find({user:userId}, null, {sort:{createdAt:-1}}, callback);
};

/**
 * リストを削除
 * @param userId
 * @param id
 * //@param callback
 */
TodoList.statics.deleteList = function(userId, id, callback) {
  var TodoItem = this.model('TodoItem'), self = this;
  TodoItem.remove({list:id, user:userId}, function(error) {
    if(error) return callback(error);
    self.count({_id:id, user:userId}, function(error, count) {
      if (error) return callback(error);
      if (count == 0) return callback(null, false);
      self.remove({_id:id, user:userId}, function(error) {
        if (error) return callback(error);
        callback(null, true);
      });
    });
  });
};

/**
 * リストが存在するか?
 * @param userId
 * @param id
 * //@param callback
 */
TodoList.statics.hasList = function(userId, id, callback) {
  this.count({user:userId, _id:id}, callback);
};

mongoose.model('TodoList', TodoList);