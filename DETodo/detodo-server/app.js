var express = require('express'),
    http = require('http'),
    path = require('path'),
    sync = require('synchronize');

var app = express();
    models = require('./models'),
    mongoose = require('mongoose');

app.configure(function(){
  app.set('port', process.env.PORT || 3000);
  app.set('views', __dirname + '/views');
  app.set('view engine', 'jade');
  app.use(express.favicon());
  app.use(express.logger('dev'));
  app.use(express.bodyParser());
  app.use(express.methodOverride());
  app.use(express.cookieParser('your secret here'));
  app.use(express.session());
  app.use(function(req, res, next){
    sync.fiber(next);
  })
  app.use(app.router);
  app.use(express.static(path.join(__dirname, 'public')));
});

app.configure('development', function(){
  mongoose.set('debug', true);
  app.set('dbname', 'detodo');
  app.use(express.errorHandler());
});

app.configure('test', function(){
  console.warn('test env');
  mongoose.set('debug', true);
  app.set('dbname', 'forAPITesting');
  app.use(express.errorHandler());
});

mongoose.connect('localhost', app.get('dbname'));

var routes = require('./routes');
routes.start(app);


http.createServer(app).listen(app.get('port'), function(){
  console.log("Express server listening on port " + app.get('port'));
});