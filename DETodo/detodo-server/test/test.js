var sync  = require('synchronize'),
    async = sync.asyncIt;


var mongoose = require('mongoose'),
    model = require('../models'); // Load models

//mongoose.set('debug', true);
var conn = mongoose.connect('localhost', 'forTesting');

describe('User', function() {
  var User = mongoose.model('User');
  sync(User, 'createUser', 'findByUserId', 'remove');

  var TEST_USER_ID = "test user _/_/::**";
  var userid_created = undefined;

  before(async(function(){
    User.remove();
  }))

  // create と read をまとめたほうがいいのか分からんけどとりあえず動く
  it('create user', async(function() {
    var user = User.createUser(TEST_USER_ID);

    user.should.be.ok;
    user.userId.should.equal(TEST_USER_ID);
    userid_created = user._id.toString();
  }))

  it('read user', async(function() {
    var user = User.findByUserId(TEST_USER_ID);

    user.should.be.ok;
    user.userId.should.equal(TEST_USER_ID);
    user._id.toString().should.equal(userid_created);
  }))
})

describe('Todo List', function() {
  var User = mongoose.model('User'), TodoList = mongoose.model('TodoList');
  sync(TodoList, 'createList', 'findAllList', 'deleteList', 'remove');

  var TEST_LIST_TITLE1 = 'list hoge あいう *** ♨',
      TEST_LIST_TITLE2 = 'list 321 漢字 123';
  var uid;

  // User を準備
  before(async(function() {
    User.remove();
    TodoList.remove();
    uid = User.createUser('user id')._id;
  }))

  var list2_id = undefined;
  it('create and get list', async(function() {
    var list1 = TodoList.createList(uid, TEST_LIST_TITLE1);
    var list2 = TodoList.createList(uid, TEST_LIST_TITLE2);

    var lists = TodoList.findAllList(uid);
    lists.should.have.length(2);
    lists[0].user.toString().should.be.ok;
    lists[0].user.toString().should.equal(uid.toString());
    lists[0].title.should.equal(TEST_LIST_TITLE2); // 後に作成したほうが先に
    lists[1].title.should.equal(TEST_LIST_TITLE1);
    list2_id = list2._id;
  }))

  it('remove list', async(function() {
    TodoList.deleteList(uid, list2_id); // 2 を消す
    var lists = TodoList.findAllList(uid);

    lists.should.have.length(1); // 1 だけ残る
    lists[0].title.should.equal(TEST_LIST_TITLE1);
  }))
})


describe('Todo Item', function() {
  var User = mongoose.model('User'), TodoList = mongoose.model('TodoList'), TodoItem = mongoose.model('TodoItem');
  sync(TodoItem, 'createItem', 'findAllItems', 'remove');

  var TEST_ITEM_TITLE1 = 'item hoge あいう *** ♨',
      TEST_ITEM_TITLE2 = 'item 321 漢字 123';
  var uid, lid;

  // User と List を準備
  before(async(function() {
    User.remove();
    TodoList.remove();
    TodoItem.remove();
    uid = User.createUser('user id')._id;
    lid = TodoList.createList(uid, 'list title')._id;
  }))

  var item2_id = undefined;
  it('create and get item', async(function() {
    var item1 = TodoItem.createItem(uid, lid, TEST_ITEM_TITLE1);
    var item2 = TodoItem.createItem(uid, lid, TEST_ITEM_TITLE2);

    var items = TodoItem.findAllItems(uid, lid);
    items[0].user.toString().should.be.ok;
    items[0].user.toString().should.equal(uid.toString());
    items[0].list.toString().should.be.ok;
    items[0].list.toString().should.equal(lid.toString());
    items[0].title.should.equal(TEST_ITEM_TITLE2);
    items[1].title.should.equal(TEST_ITEM_TITLE1);
    item2_id = items[0]._id;
  }))

  sync(TodoItem, 'updateDone', 'deleteItem');
  it('update item', async(function() {
    var item = TodoItem.createItem(uid, lid, 'update test item');

    item.done.should.equal(false); // 初期値 done == false
    var itemUpdated = TodoItem.updateDone(uid, item._id, true);

    itemUpdated.done.should.be.ok; // アップデートして done == true に

    var items = TodoItem.findAllItems(uid, lid);
    var itemIncludes;
    items.forEach(function(i) {
      if (i._id.toString() === itemUpdated._id.toString()) itemIncludes = i;
    })

    // Item リストには 先ほどのものが含まれている
    itemIncludes._id.toString().should.equal(item._id.toString());
    itemIncludes.done.should.be.ok;
    itemIncludes.title.should.equal('update test item');

  }))

  it('delete item', async(function() {
    TodoItem.deleteItem(uid, item2_id);

    var items = TodoItem.findAllItems(uid, lid);
    var itemIncludes = '';
    items.forEach(function(i) {
      if (i._id.toString() === item2_id.toString()) itemIncludes = i;
    })

    items.should.have.length(2);
    itemIncludes.should.not.be.ok;

  }))

})

describe('Permissions', function() {
  var User = mongoose.model('User'), TodoList = mongoose.model('TodoList'), TodoItem = mongoose.model('TodoItem');

  var uid1, lid1, uid2;

  // User と List を準備
  before(async(function() {
    User.remove();
    TodoList.remove();
    TodoItem.remove();
    uid1 = User.createUser('user id 1')._id;
    uid2 = User.createUser('user id 2')._id;
    lid1 = TodoList.createList(uid1, 'list title 1')._id;
  }))

  it('prevent another user from deleting my list', async(function() {
    TodoList.deleteList(uid2, lid1); // user 2 が user 1 のリストを削除
    var lists1 = TodoList.findAllList(uid1);
    var lists2 = TodoList.findAllList(uid2);

    lists1.should.have.length(1);
    lists2.should.have.length(0);

    TodoList.deleteList(uid1, lid1);
    lists1 = TodoList.findAllList(uid1);
    lists1.should.have.length(0);
  }))
})