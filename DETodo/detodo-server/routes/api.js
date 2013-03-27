var mongoose = require('mongoose'),
  sync = require('synchronize');

exports.start = function(app) {



  var TodoList = mongoose.model('TodoList'), TodoItem = mongoose.model('TodoItem');

  var API_PATH = '/api';

  /**
   * TodoList API
   */
  sync(TodoList, 'findAllList');
  app.get(API_PATH + '/list', function(req, res, next) {
    var lists = TodoList.findAllList(req.session.uid);
    return res.json({lists:lists});
  });

  sync(TodoList, 'createList');
  app.post(API_PATH + '/list', function(req, res, next) {
    var title = req.param('title');
    if (!title || (title && title.length <= 0)) return res.json(400,{});
    var list = TodoList.createList(req.session.uid, title);
    return res.json(list);
  });

  sync(TodoList, 'deleteList');
  app.del(API_PATH + '/list/:id', function(req, res, next) {
    var success = TodoList.deleteList(req.session.uid, req.param('id'));
    if(success) return res.json({});
    else return res.json(404, {});
  });

  /**
   * TodoItem API
   */
  sync(TodoList, 'hasList');
  var hasList = function(req, res, next) {
    var hasList = TodoList.hasList(req.session.uid, req.param('lid'));
    if(!hasList) {
      return res.json(404, {});
    }
    return next()
  }

  sync(TodoItem, 'findAllItems');
  app.get(API_PATH + '/list/:lid/item', hasList, function(req, res, next) {
    var items = TodoItem.findAllItems(req.session.uid, req.param('lid'));
    return res.json({items:items});
  });

  sync(TodoItem, 'createItem');
  app.post(API_PATH + '/list/:lid/item', hasList, function(req, res, next) {
    var title = req.param('title');
    if (!title || (title && title.length <= 0)) return res.json(400,{});
    var item = TodoItem.createItem(req.session.uid, req.param('lid'), title);
    return res.json(item);
  });

  sync(TodoItem, 'updateDone');
  app.put(API_PATH + '/list/:lid/item/:iid', function(req, res, next) {
    var done = req.param('done');
    if (done == null) return res.json(400,{});
    var item = TodoItem.updateDone(req.session.uid, req.param('iid'), done);
    if (item) return res.json(item);
    else return res.json(404, {});
  });

  sync(TodoItem, 'deleteItem');
  app.del(API_PATH + '/list/:lid/item/:iid', hasList, function(req, res, next) {
    TodoItem.deleteItem(req.session.uid, req.param('iid'));
    return res.json({});
  });
};