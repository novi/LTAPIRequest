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

var request = function(agent) {
  return request_('http://localhost:3000');
}

function CleanDB (done){
  utils.cleanDB("mongodb://localhost:27017/forAPITesting?w=1", function(err) {
    if (err) return err;
    setTimeout(done, 500)
  })
}


describe('User API Login', function() {

  // DBを削除
  before(CleanDB)

  it('should return 400 if no body', function(done) {
    request().post('/auth/login').expect(400, done)
  })

  var t_id;
  it('should return 200 if have valid post body', function(done) {
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
  it('should return 200 with same _id before if have valid post body', function(done) {
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

describe('Todo List API GET', function() {

  before(function(done) {
    TEST_Login(TEST_USER_ID1, done)
  })

  after(function(done) {
    clearSession(TEST_USER_ID1, done)
  })

  it('should return 403 if not logged in', function(done) {
    request().get('/api/list').expect(403, done)
  })

  it('should return empty array with 200', function(done) {
    request().get('/api/list').withSession(TEST_USER_ID1).expect(200, function(err, res) {
      if (err) return done(err);
      res.body.lists.should.have.length(0);
      done()
    })
  })

})

describe('Todo List API POST and DELETE', function() {

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

  it('should return 400 if no valid post body', function(done) {
    request().post('/api/list').withSession(TEST_USER_ID1).expect(400, done)
  })

  var TEST_list_id;
  it('should return 200 with created data', function(done) {
    request().post('/api/list').send({title:'hoge'}).withSession(TEST_USER_ID1).expect(200, function(err, res) {
      if (err) return done(err);
      res.body._id.should.be.ok
      res.body.title.should.equal('hoge')
      TEST_list_id = res.body._id;
      done()
    })
  })

  it('should return created List', function(done) {
    request().get('/api/list').withSession(TEST_USER_ID1).expect(200, function(err, res) {
      if (err) return done(err);
      res.body.lists.should.have.length(1)
      res.body.lists[0]._id.should.equal(TEST_list_id)
      res.body.lists[0].title.should.equal('hoge')
      done()
    })
  })

  it('should not delete another user\'s list', function(done) {
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

  it('deletes created List one more should returns 404', function(done) {
    request().del('/api/list/' + TEST_list_id).withSession(TEST_USER_ID1).expect(404, done)
  })

})

/*
describe('Kill test node', function() {
  it('should be killed', function(done) {
    child.kill('SIGHUP');
    done()
  })
})*/