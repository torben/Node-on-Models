module.exports = {
  action: 'createTable',
  tableName: 'articles',
  fields: [
    {
      name: "navigation_id",
      type: "integer"
    },
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