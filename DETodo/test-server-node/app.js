
/**
 * Module dependencies.
 */

var express = require('express')
  , routes = require('./routes')
  , user = require('./routes/user')
  , http = require('http')
  , path = require('path');

var app = express();

app.configure(function(){
  app.set('port', process.env.PORT || 3001);
  app.set('views', __dirname + '/views');
  app.set('view engine', 'jade');
  app.use(express.favicon());
  app.use(express.logger('dev'));
  app.use(express.bodyParser());
  app.use(express.methodOverride());
  app.use(express.cookieParser('your secret here'));
  app.use(express.session());
  app.use(app.router);
  app.use(express.static(path.join(__dirname, 'public')));
});

app.configure('development', function(){
  app.use(express.errorHandler());
});

/*app.all('*', function(req, res, next) {
  var j = res.json;
  var statuses = [400, 404, 403, 500, 503];
  res.json = function(data) {
    j.call(this, statuses[Math.floor(Math.random()*statuses.length)], data);
  };
  next();
});
*/

// UIのデバッグ用にリクエストを遅らせる
app.all('*', function(req, res, next) {
  setTimeout(next, 2000);
});

// ログインが必要な API, セッションが無ければ 403
app.all('/api/*', function(req, res, next) {
  if (!req.session.user_id) return res.json(403,{});
  next();
});

app.post('/auth/login', function(req, res) {
  if (req.param('user_id').length <= 0) return res.json(400,{});
  req.session.user_id = "u123abc";
  res.json({user_id:req.param('user_id'), _id:"u123abc"});
});

var API_PATH = '/api';

// Lists

app.get(API_PATH + '/list', function(req, res) {
  // テスト用に _id を l? にする
  res.json({lists:[{_id:"l1", title:'t1'}, {_id:"l2", title:'t2'}, {_id:"l3", title:'t3'}]});
});

app.post(API_PATH + '/list', function(req, res) {
  res.json(201,{_id:"lfffff", title:req.param('title')});
});

// API は DELETE /list/l? という形式のみacceptする, それ以外はiOS側の呼び出しバグなので404が返る
app.del(API_PATH + '/list/l:id', function(req, res) {
  res.json({debug:'l' + req.param('id') + ' deleted'});
});

//
// Items

// 同じく GET /list/l?
app.get(API_PATH + '/list/l:id', function(req, res) {
  // _id の形式を l?_i? にする (l=list, i=item, e.g. l1_i2)
  res.json({items:[{_id:'l'+req.param('id')+'_i1', title:'list '+req.param('id') + " item 1", done:false}, {_id:'l'+req.param('id')+'_i2', title:'list '+req.param('id') + " item 2", done:true}]});
});

// POST /list/l?
app.post(API_PATH + '/list/l:id', function(req, res) {
  res.json(201,{_id:'l'+req.param('id')+'_i3', title:req.param('title'), done:false});
});

// PUT /list/l?/item/l?_i?
app.put(API_PATH + '/list/l:a/item/l:b_i:item', function(req, res) {
  res.json({_id:'i' + req.param('item'), title:'original title', done:req.param('done')});
});

// DELETE /list/l?/item/l?_i?
app.del(API_PATH + '/list/l:a/item/l:b_i:item', function(req, res) {
  res.json({debug:'l'+req.param('b') + '_i' + req.param('item') + ' deleted'});
});

http.createServer(app).listen(app.get('port'), function(){
  console.log("Express server listening on port " + app.get('port'));
});
