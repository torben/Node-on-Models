assert = require("assert")
Model = require("#{__dirname}/../app/models/model")
DBCreator = require("#{__dirname}/../db/db")
should = require('should')

# Init the model
dbCreator = new DBCreator('test', true, false)

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

  beforeEach (done) ->
    dbCreator.executeMigration migration, ->
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


      it 'should have getter methods for model', ->
        for field in Article.fields()
          console.log "."
          (typeof eval("article.#{field}")).should.equal "function"


      it 'should have setter methods for model', ->
        for field in Article.fields()
          (typeof eval("article.#{field}")).should.equal "function"



