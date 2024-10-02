/// <reference path="../pb_data/types.d.ts" />
migrate((db) => {
  const collection = new Collection({
    "id": "igembqwyo31jw6u",
    "created": "2024-10-02 14:06:01.047Z",
    "updated": "2024-10-02 14:06:01.047Z",
    "name": "book_pages",
    "type": "base",
    "system": false,
    "schema": [
      {
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
      },
      {
        "system": false,
        "id": "muwtmr4o",
        "name": "pages_file",
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
      }
    ],
    "indexes": [],
    "listRule": null,
    "viewRule": null,
    "createRule": null,
    "updateRule": null,
    "deleteRule": null,
    "options": {}
  });

  return Dao(db).saveCollection(collection);
}, (db) => {
  const dao = new Dao(db);
  const collection = dao.findCollectionByNameOrId("igembqwyo31jw6u");

  return dao.deleteCollection(collection);
})
