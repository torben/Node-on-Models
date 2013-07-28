Model = require('./model')

class Article extends Model
  @className: 'Article'

Article.fields()

module.exports = Article