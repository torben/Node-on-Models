assert = require("assert")
db = require("#{__dirname}/../db/db")('test')
Model = require("#{__dirname}/../app/models/model")
should = require('should')

migration = {
  action: 'createTable',
  tableName: 'articles',
  fields: [
    {
      name: "author_id",
      type: "integer"
    },
    {
      name: "title",
      type: "string"
    },
    {
      name: "body",
      type: "text"
    }
  ]
}

class Article extends Model
  @className: 'Article'


describe 'Model', ->
  article = null

  before (done) ->
    db.executeMigration migration, ->
      article = new Article()
      Article.fields -> done()


  describe 'classMethods', ->
    describe '#tableName', ->
      it 'should return the pluralized class name in lowercase', ->
        assert.equal "Article", Article.className
        assert.equal "articles", Article.tableName()


      it 'should have fields from migration', ->
        fields = migration.fields.map (field) ->
          Article.fields().should.include(field.name)


      it 'should have getter and setter methods for model', ->
        for field in Article.fields()
          value = Math.random()
          eval("article.#{field} = #{value}")
          eval("article.#{field}").should.equal value


  describe 'New objects and save them', ->
    article1 = null
    id = null

    beforeEach ->
      article1 = new Article(author_id: 1, title: 'title', body: 'Hey test')


    it 'should initialize a new object', ->
      article1.author_id.should.equal 1
      article1.title.should.equal 'title'
      article1.body.should.equal 'Hey test'


    it 'should initialize a new object and updates changed attributes field', ->
      article1.changedAttributes.should.include('author_id')
      article1.changedAttributes.should.include('title')
      article1.changedAttributes.should.include('body')


    it 'should save the record', (done) ->
      article1.save (err) ->
        should.not.exist(err)

        article1.id.should.equal 1
        article1.author_id.should.equal 1
        article1.title.should.equal 'title'
        article1.body.should.equal 'Hey test'

        article1.changedAttributes.should.be.empty

        id = article1.id

        done()


    it 'should save a second record with create call', (done) ->
      article2 = Article.create author_id: 2, title: 'Damn right', body: 'Sometimes!', (err) ->
        should.not.exist(err)

        article2.id.should.equal 2
        article2.author_id.should.equal 2
        article2.title.should.equal 'Damn right'
        article2.body.should.equal 'Sometimes!'

        article2.changedAttributes.should.be.empty

        done()


    it 'should load the correct saved model', (done) ->
      article2 = Article.find id, (err) ->
        should.not.exist(err)

        article2.author_id.should.equal 1
        article2.title.should.equal 'title'
        article2.body.should.equal 'Hey test'

        done()


    it 'should not save a unchanged model', (done) ->
      article2 = Article.find id, (err) ->
        should.not.exist(err)

        article2.save (saveErr, changedFields) ->
          should.not.exist(saveErr)
          changedFields.should.be.empty

          done()


    it 'should not find a non existing record', (done) ->
      article2 = Article.find 999, (err) ->
        should.exist(err)

        done()


    it 'should find two records', (done) ->
      articles = Article.all (err, records) ->
        should.not.exist(err)

        articles.should.have.length(2)
        articles[0].should.be.an.instanceOf(Article)

        done()


# TODO close db?



