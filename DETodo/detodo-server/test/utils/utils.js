var Test = require('supertest/lib/test');

var Cookies = {};

exports.clearSession = function (name, callback) {
  delete Cookies[name];
  callback();
}

Test.prototype.withSession = function(name) {
  this._withSessionName = name;
  return this;
}

var fend = Test.prototype.end;
Test.prototype.end = function(fn) {
  var self = this;
  //console.log(this);
  if(Cookies[self._withSessionName]) {
    //console.log('req', Cookies[self._withSessionName], this._url, this._data);
    this.cookies = Cookies[self._withSessionName];
    this.set('Cookie', Cookies[self._withSessionName])
  } else {
    //throw new Error('no session for ' + self._withSessionName);
  }
  fend.call(this, function(err, res) {
    if (self._withSessionName && res.headers['set-cookie']) {
      Cookies[self._withSessionName] = res.headers['set-cookie'].pop().split(';')[0];
      //console.log('res', Cookies);
    }
    fn.apply(this, arguments);
  })
}


var Db = require('mongodb').Db;
exports.cleanDB = function(dbpath, done) {
  Db.connect(dbpath, function(err, db) {
    if (err) return done(err);
    db.dropDatabase(function(err) {
      if (err) return done(err);
      db.close()
      done()
    })
  })
}