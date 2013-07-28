module.exports = {
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