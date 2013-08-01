module.exports = {
  action: 'createTable',
  tableName: 'navigations',
  fields: [
    {
      name: "title",
      type: "string"
    },
    {
      name: "permalink",
      type: "string"
    },
    {
      name: "position",
      type: "integer"
    },
    {
      name: "active",
      type: "boolean"
    }
  ]
}