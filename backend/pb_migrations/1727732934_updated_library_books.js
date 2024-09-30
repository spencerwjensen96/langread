/// <reference path="../pb_data/types.d.ts" />
migrate((db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("leh8ne58bmwejyl")

  // add
  collection.schema.addField(new SchemaField({
    "system": false,
    "id": "3doqv0im",
    "name": "language",
    "type": "text",
    "required": false,
    "presentable": false,
    "unique": false,
    "options": {
      "min": null,
      "max": null,
      "pattern": ""
    }
  }))

  return dao.saveCollection(collection)
}, (db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("leh8ne58bmwejyl")

  // remove
  collection.schema.removeField("3doqv0im")

  return dao.saveCollection(collection)
})
