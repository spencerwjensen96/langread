/// <reference path="../pb_data/types.d.ts" />
migrate((db) => {
  const collection = new Collection({
    "id": "bjcw0ru97wxtvt3",
    "created": "2024-10-14 14:36:34.257Z",
    "updated": "2024-10-14 14:36:34.257Z",
    "name": "dictionaries",
    "type": "base",
    "system": false,
    "schema": [
      {
        "system": false,
        "id": "vc3pclhk",
        "name": "name",
        "type": "text",
        "required": false,
        "presentable": false,
        "unique": false,
        "options": {
          "min": null,
          "max": null,
          "pattern": ""
        }
      },
      {
        "system": false,
        "id": "wv8xmduv",
        "name": "dictionary_file",
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
    "listRule": "",
    "viewRule": "",
    "createRule": null,
    "updateRule": null,
    "deleteRule": null,
    "options": {}
  });

  return Dao(db).saveCollection(collection);
}, (db) => {
  const dao = new Dao(db);
  const collection = dao.findCollectionByNameOrId("bjcw0ru97wxtvt3");

  return dao.deleteCollection(collection);
})
