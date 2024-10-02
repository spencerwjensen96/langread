/// <reference path="../pb_data/types.d.ts" />
migrate((db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("igembqwyo31jw6u")

  // update
  collection.schema.addField(new SchemaField({
    "system": false,
    "id": "h5lpxfqo",
    "name": "book",
    "type": "relation",
    "required": false,
    "presentable": false,
    "unique": false,
    "options": {
      "collectionId": "leh8ne58bmwejyl",
      "cascadeDelete": false,
      "minSelect": null,
      "maxSelect": 1,
      "displayFields": null
    }
  }))

  return dao.saveCollection(collection)
}, (db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("igembqwyo31jw6u")

  // update
  collection.schema.addField(new SchemaField({
    "system": false,
    "id": "h5lpxfqo",
    "name": "book_id",
    "type": "relation",
    "required": false,
    "presentable": false,
    "unique": false,
    "options": {
      "collectionId": "leh8ne58bmwejyl",
      "cascadeDelete": false,
      "minSelect": null,
      "maxSelect": 1,
      "displayFields": null
    }
  }))

  return dao.saveCollection(collection)
})
