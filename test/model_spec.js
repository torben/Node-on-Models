// Generated by CoffeeScript 1.6.3
var Article, Model, assert, db, migration, should, _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

assert = require("assert");

db = require("" + __dirname + "/../db/db")('test');

Model = require("" + __dirname + "/../app/models/model");

should = require('should');

migration = {
  action: 'createTable',
  tableName: 'articles',
  fields: [
    {
      name: "author_id",
      type: "integer"
    }, {
      name: "title",
      type: "string"
    }, {
      name: "body",
      type: "text"
    }
  ]
};

Article = (function(_super) {
  __extends(Article, _super);

  function Article() {
    _ref = Article.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  Article.className = 'Article';

  return Article;

})(Model);

describe('Model', function() {
  var article;
  article = null;
  before(function(done) {
    return db.executeMigration(migration, function() {
      article = new Article();
      return Article.fields(function() {
        return done();
      });
    });
  });
  describe('classMethods', function() {
    return describe('#tableName', function() {
      it('should return the pluralized class name in lowercase', function() {
        assert.equal("Article", Article.className);
        return assert.equal("articles", Article.tableName());
      });
      it('should have fields from migration', function() {
        var fields;
        return fields = migration.fields.map(function(field) {
          return Article.fields().should.include(field.name);
        });
      });
      return it('should have getter and setter methods for model', function() {
        var field, value, _i, _len, _ref1, _results;
        _ref1 = Article.fields();
        _results = [];
        for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
          field = _ref1[_i];
          value = Math.random();
          eval("article." + field + " = " + value);
          _results.push(eval("article." + field).should.equal(value));
        }
        return _results;
      });
    });
  });
  return describe('New objects and save them', function() {
    var article1, id;
    article1 = null;
    id = null;
    beforeEach(function() {
      return article1 = new Article({
        author_id: 1,
        title: 'title',
        body: 'Hey test'
      });
    });
    it('should initialize a new object', function() {
      article1.author_id.should.equal(1);
      article1.title.should.equal('title');
      return article1.body.should.equal('Hey test');
    });
    it('should initialize a new object and updates changed attributes field', function() {
      article1.changedAttributes.should.include('author_id');
      article1.changedAttributes.should.include('title');
      return article1.changedAttributes.should.include('body');
    });
    it('should save the record', function(done) {
      return article1.save(function(err) {
        should.not.exist(err);
        article1.id.should.equal(1);
        article1.author_id.should.equal(1);
        article1.title.should.equal('title');
        article1.body.should.equal('Hey test');
        article1.changedAttributes.should.be.empty;
        id = article1.id;
        return done();
      });
    });
    it('should save a second record with create call', function(done) {
      var article2;
      return article2 = Article.create({
        author_id: 2,
        title: 'Damn right',
        body: 'Sometimes!'
      }, function(err) {
        should.not.exist(err);
        article2.id.should.equal(2);
        article2.author_id.should.equal(2);
        article2.title.should.equal('Damn right');
        article2.body.should.equal('Sometimes!');
        article2.changedAttributes.should.be.empty;
        return done();
      });
    });
    it('should load the correct saved model', function(done) {
      var article2;
      return article2 = Article.find(id, function(err) {
        should.not.exist(err);
        article2.author_id.should.equal(1);
        article2.title.should.equal('title');
        article2.body.should.equal('Hey test');
        return done();
      });
    });
    it('should not save a unchanged model', function(done) {
      var article2;
      return article2 = Article.find(id, function(err) {
        should.not.exist(err);
        return article2.save(function(saveErr, changedFields) {
          should.not.exist(saveErr);
          changedFields.should.be.empty;
          return done();
        });
      });
    });
    it('should not find a non existing record', function(done) {
      var article2;
      return article2 = Article.find(999, function(err) {
        should.exist(err);
        return done();
      });
    });
    return it('should find two records', function(done) {
      var articles;
      return articles = Article.all(function(err, records) {
        should.not.exist(err);
        articles.should.have.length(2);
        articles[0].should.be.an.instanceOf(Article);
        return done();
      });
    });
  });
});
