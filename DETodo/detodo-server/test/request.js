var request_ = require('supertest'),
    utils = require('./utils/utils'),
    clearSession = utils.clearSession;
/*
var spawn = require('child_process').spawn;
var child = spawn('/usr/local/bin/node', ['app.js'], {env:{NODE_ENV:'test'}, cwd:'.'})
child.stderr.setEncoding('utf8');
child.stderr.on('data', function(data) {
  //console.log(data)
})
*/

var request = function() {
  return request_('http://localhost:3000');
}

function CleanDB (done){
  utils.cleanDB("mongodb://localhost:27017/forAPITesting?w=1", function(err) {
    if (err) return err;
    done()
    //setTimeout(done, 500)
  })
}


describe('User API', function() {

  // DBを削除
  before(CleanDB)

  it('should return 400 when requested with no body', function(done) {
    request().post('/auth/login').expect(400, done)
  })

  var t_id;
  it('should return 200 when requested with valid post body', function(done) {
    request().post('/auth/login').send({user_id:'test user'})
      .expect(200, function(error, res) {
        if (error) return done(error);
        //console.log(res.body);
        t_id = res.body._id;
        res.body._id.should.be.ok
        res.body.user_id.should.equal('test user')
        done()
      })
  })
  it('should return 200 with same _id before when requested with same user name', function(done) {
    request().post('/auth/login').send({user_id:'test user'})
      .expect(200).end(function(error, res) {
        if (error) return done(error);
        res.body._id.should.equal(t_id)
        res.body.user_id.should.equal('test user')
        done()
      })
  })
})

var TEST_USER_ID1 = 'test user',
    TEST_USER_ID2 = 'test user2';

var TEST_Login = function(user, callback) {
   request().post('/auth/login').send({user_id:user}).withSession(user).expect(200,callback)
}

describe('Todo List GET API', function() {

  before(function(done) {
    TEST_Login(TEST_USER_ID1, done)
  })

  after(function(done) {
    clearSession(TEST_USER_ID1, done)
  })

  it('should return 403 if not logged in', function(done) {
    request().get('/api/list').expect(403, done)
  })

  it('should return empty List with 200', function(done) {
    request().get('/api/list').withSession(TEST_USER_ID1).expect(200, function(err, res) {
      if (err) return done(err);
      res.body.lists.should.have.length(0);
      done()
    })
  })

})

describe('Todo List POST and DELETE API', function() {

  before(function(done) {
    TEST_Login(TEST_USER_ID1, function(err) {
      if(err) return done(err);
      TEST_Login(TEST_USER_ID2, done)
    })
  })

  after(function(done) {
    clearSession(TEST_USER_ID1, function() {
      clearSession(TEST_USER_ID2, done)
    })
  })

  it('should return 403 if not logged in', function(done) {
    request().post('/api/list').expect(403, done)
  })

  it('should return 400 when requested with no post body', function(done) {
    request().post('/api/list').withSession(TEST_USER_ID1).expect(400, done)
  })

  var TEST_list_id;
  it('creates List and return 200 with created data', function(done) {
    request().post('/api/list').send({title:'hoge'}).withSession(TEST_USER_ID1).expect(200, function(err, res) {
      if (err) return done(err);
      res.body._id.should.be.ok
      res.body.title.should.equal('hoge')
      TEST_list_id = res.body._id;
      // 作成されたか確認
      request().get('/api/list').withSession(TEST_USER_ID1).expect(200, function(err, res) {
        if (err) return done(err);
        res.body.lists.should.have.length(1)
        res.body.lists[0]._id.should.equal(TEST_list_id)
        res.body.lists[0].title.should.equal('hoge')
        done()
      })
    })
  })

  it('should not delete another users list', function(done) {
    request().del('/api/list/' + TEST_list_id).withSession(TEST_USER_ID2).expect(404, done)
  })

  it('deletes created List', function(done) {
    request().del('/api/list/' + TEST_list_id).withSession(TEST_USER_ID1).expect(200, function(err) {
      if (err) return done(err)
      request().get('/api/list').withSession(TEST_USER_ID1).expect(200, function(err, res) {
        if (err) return done(err)
        res.body.lists.should.have.length(0)
        done()
      })
    })
  })

  it('deletes created List one more and should returns 404', function(done) {
    request().del('/api/list/' + TEST_list_id).withSession(TEST_USER_ID1).expect(404, done)
  })

})



describe('Todo Item API', function() {

  var TEST_list_id_1_for_user1,
      TEST_list_id_1_for_user2;
  before(function(done) {
    CleanDB(function(err) {
      if(err) return done(err);
      TEST_Login(TEST_USER_ID1, function(err) {
        if(err) return done(err);
        TEST_Login(TEST_USER_ID2, function(err) {
          request().post('/api/list').send({title:'fuga1'}).withSession(TEST_USER_ID1).expect(200, function(err, res) {
            if(err) return done(err)
            TEST_list_id_1_for_user1 = res.body._id;
            request().post('/api/list').send({title:'fuga2'}).withSession(TEST_USER_ID2).expect(200, function(err, res) {
              if(err) return done(err)
              TEST_list_id_1_for_user2 = res.body._id;
              done()
            })
          })
        })
      })
    })
  })

  after(function(done) {
    clearSession(TEST_USER_ID1, function() {
      clearSession(TEST_USER_ID2, done)
    })
  })


  it('gets empty Item with 200 first', function(done) {
    request().get('/api/list/' + TEST_list_id_1_for_user1 + '/item').withSession(TEST_USER_ID1).expect(200, function(err, res) {
      if (err) return done(err);
      res.body.items.should.have.length(0)
      done()
    })
  })

  var TEST_item_1_for_user1,
      TEST_item_1_for_user2;
  it('creates new Item and returns 200 with created data', function(done) {
    request().post('/api/list/' + TEST_list_id_1_for_user1 + '/item').send({title:'hoge item'}).withSession(TEST_USER_ID1).expect(200, function(err, res) {
      if(err) return done(err);
      res.body._id.should.be.ok
      res.body.title.should.equal('hoge item')
      TEST_item_1_for_user1 = res.body._id;
      request().post('/api/list/' + TEST_list_id_1_for_user1 + '/item').send({title:'hoge item'}).withSession(TEST_USER_ID2).expect(404, done)
    })
  })

  it('should returns 200 with created Item before', function(done) {
    request().get('/api/list/' + TEST_list_id_1_for_user1 + '/item').withSession(TEST_USER_ID1).expect(200, function(err, res) {
      if (err) return done(err);
      res.body.items.should.have.length(1)
      res.body.items[0]._id.should.equal(TEST_item_1_for_user1)
      res.body.items[0].title.should.equal('hoge item')
      res.body.items[0].done.should.be.false
      done()
    })
  })

  it('should returns empty Item when accessing other users List', function(done){
    request().get('/api/list/' + TEST_list_id_1_for_user1 + '/item').withSession(TEST_USER_ID2).expect(404, done)
  })

  it('updates Item and returns updated data', function(done) {
    request().put('/api/list/' + TEST_list_id_1_for_user1 + '/item/' + TEST_item_1_for_user1).send({done:true}).withSession(TEST_USER_ID1).expect(200, function(err, res) {
      if (err) return done(err)
      res.body.done.should.be.true
      res.body._id.should.be.equal(TEST_item_1_for_user1)
      request().get('/api/list/' + TEST_list_id_1_for_user1 + '/item').withSession(TEST_USER_ID1).expect(200, function(err, res) {
        if (err) return done(err);
        res.body.items.should.have.length(1)
        res.body.items[0]._id.should.equal(TEST_item_1_for_user1)
        res.body.items[0].done.should.be.true
        done()
      })
    })
  })

  it('updates other users Item and returns 404', function(done) {
    request().put('/api/list/' + TEST_list_id_1_for_user1 + '/item/' + TEST_item_1_for_user1).send({done:true}).withSession(TEST_USER_ID2).expect(404, done)
  })

  it('deletes other users Item and returns 404', function(done) {
    request().del('/api/list/' + TEST_list_id_1_for_user1 + '/item/' + TEST_item_1_for_user1).withSession(TEST_USER_ID2).expect(404, done)
  })

  it('deletes created Item and returns 200', function(done) {
    request().del('/api/list/' + TEST_list_id_1_for_user1 + '/item/' + TEST_item_1_for_user1).withSession(TEST_USER_ID1).expect(200, function(err, res){
      if(err) return done(err);
      // 削除されたか確認
      request().get('/api/list/' + TEST_list_id_1_for_user1 + '/item').withSession(TEST_USER_ID1).expect(200, function(err, res) {
        if (err) return done(err);
        res.body.items.should.have.length(0)
        done()
      })
    })
  })

})

/*
describe('Kill test node', function() {
  it('should be killed', function(done) {
    child.kill('SIGHUP');
    done()
  })
})*/