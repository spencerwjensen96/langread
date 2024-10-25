/// <reference path="../pb_data/types.d.ts" />
migrate((db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("igembqwyo31jw6u")

  collection.name = "book_files"

  // add
  collection.schema.addField(new SchemaField({
    "system": false,
    "id": "a7corwi9",
    "name": "epub_file",
    "type": "file",
    "required": false,
    "presentable": false,
    "unique": false,
    "options": {
      "mimeTypes": [],
      "thumbs": [],
      "maxSelect": 1,
      "maxSize": 5242880,
      "protected": false
    }
  }))

  return dao.saveCollection(collection)
}, (db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("igembqwyo31jw6u")

  collection.name = "book_pages"

  // remove
  collection.schema.removeField("a7corwi9")

  return dao.saveCollection(collection)
})
