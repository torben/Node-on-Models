var Article = require('./app/models/article');
var Navigation = require('./app/models/navigation');


/*
Article.fields(function() {
  article = new Article();
  article.id = 6
  console.log(article.id);
});
*/

Article.fields(function() {
  var index = 1;
  Article.all(function(err, articles) {
    articles.forEach(function(article) {
      console.log("navigationID: "+ article.navigation_id, index)
      article.navigation_id = index;
      
      console.log("changed: ", article.changedAttributes)
      console.log(article.navigation_id)

      article.save(function(err) {
        console.log(arguments)
      });
      index++;
    });
  });
});