Article = require("./app/models/article");

Article.fields(function() {
  article = new Article();
  article.id = 6
  console.log(article.id);
});