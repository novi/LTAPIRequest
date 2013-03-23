var api = require('./api'),
  auth = require('./auth');

exports.start = function(app) {
  auth.start.apply(this, arguments);
  api.start.apply(this, arguments);
};