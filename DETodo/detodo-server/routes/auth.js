var mongoose = require('mongoose'),
    sync = require('synchronize');

exports.start = function(app) {

  var User = mongoose.model('User');


  sync(User, 'findByUserId', 'createUser');
  app.post('/auth/login', function(req, res, next) {
    var userId = req.param('user_id');
    if (!userId || (userId && userId.length <= 0)) return res.json(400,{});
    var user = User.findByUserId(userId);
    if (user) {
      req.session.uid = user._id;
      return res.json({_id:user._id, user_id:user.userId});
    } else {
      user = User.createUser(userId);
      req.session.uid = user._id;
      user.user_id = user.userId;
      return res.json({_id:user._id, user_id:user.userId});
    }
  });


  app.all('/api/*', function(req, res, next) {
    if(!req.session.uid) return res.json(403, {});
    next();
  });

};