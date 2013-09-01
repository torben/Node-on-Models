require('coffee-script');
fs = require('fs')
assert = require("assert")
should = require('should')

migration = {
  action: 'createTable',
  tableName: 'comments',
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

# removes old database
database = "./db/database_test.sqlite"
fs.unlinkSync(database) if fs.existsSync(database)
db = require("#{__dirname}/../db/db")('test')

describe 'DB', ->
  describe '#methods', ->
    describe '#createDatabase', ->
      #it 'should delete a database', ->
      #  db.unlinkDatabase()
      #  fs.existsSync(db.database).should.be.false


      it 'should create an empty database', ->
        db.createDatabase()

        fs.existsSync(db.database).should.be.true
        fs.readFileSync(db.database, 'utf8').length.should.equal 0


      it 'should open db', ->
        connection = db.openDatabase()
        connection.filename.should.equal db.database


      it 'should migrate db', ->
        # doMigrations
        # todo implement pls


      describe 'Generates data for DB', ->
        err = null
        before (done) ->
          db.executeMigration migration, (_err, index) ->
            err = err
            done()


        describe 'Data migration', ->
          it 'should not have a error', ->
            should.not.exist(err)


          it 'should have the wanted fields', (done) ->
            db.loadFieldsFor 'comments', (err, fields) ->
              should.not.exist(err)
              migration.fields.map (field) ->
                fields.should.include(field.name)

              done()


          # todo test the migration on detail (right field type, etc.)


        describe 'test data manipulation', ->
          it 'should insert a new record', (done) ->
            db.insertRow 'comments', ['author_id', 'title', 'body'], [3, 'testen', 'testet'], (err, row) ->
              should.not.exist(err)

              row.author_id.should.equal 3
              row.title.should.equal 'testen'
              row.body.should.equal 'testet'

              done()


          it 'should insert a second new record', (done) ->
            db.insertRow 'comments', ['author_id', 'title', 'body'], [4, 'record', 'mega toll'], (err, row) ->
              should.not.exist(err)

              row.author_id.should.equal 4
              row.title.should.equal 'record'
              row.body.should.equal 'mega toll'

              done()


          it 'should not be insert a row in a non existing table', (done) ->
            db.insertRow 'non_existing_table', ['author_id', 'title', 'body'], [3, 'testen', 'testet'], (err, row) ->
              should.exist(err)

              done()


          it 'should update an existing record', (done) ->
            db.updateRow 'comments', 1, ['title', 'body'], ['mega', 'bla'], (err, row) ->
              should.not.exist(err)

              row.title.should.equal 'mega'
              row.body.should.equal 'bla'

              done()


        describe 'loading test data', ->
          it 'should have two records in DB', (done) ->
            db.loadAllFor 'comments', (err, row) ->
              should.not.exist(err)
              row.length.should.equal 2

              done()


          it 'should load a record with where call', (done) ->
            db.where title: 'mega', 'comments', (err, records) ->
              should.not.exist(err)
              records.should.have.length(1)

              records[0].id.should.equal 1

              done()




  # describe '#constructor', ->
  #   it 'should initialize an empty database', ->
  #     db = new DB('test', true, false)