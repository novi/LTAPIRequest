var mongoose = require('mongoose'),
    Schema = mongoose.Schema,
    ObjectId = Schema.ObjectId;

var User = new Schema({
  userId: {type: String, required: true, index: {unique:true}}
});

/**
 * 新規ユーザー
 * @param userId
 * //@param callback
 */
User.statics.createUser = function(userId, callback) {
  var user = new this({userId:userId});
  user.save(callback);
};

/**
 * ユーザーを取得
 * @param userId
 * //@param callback
 */
User.statics.findByUserId = function(userId, callback) {
  this.findOne({userId:userId}, callback);
};

mongoose.model('User', User);