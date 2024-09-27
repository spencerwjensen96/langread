import 'package:pocketbase/pocketbase.dart';

import 'file.dart';

class User {
  final String id;
  final String? username;
  final String? email;
  final String? name;
  final PocketBaseFile? avatar;
  final DateTime? created;
  final DateTime? updated;

  User(RecordModel record)
      : id = record.id,
        username = record.data['username'],
        email = record.data['email'],
        name = record.data['name'],
        avatar = record.data['avatar'] != null
            ? PocketBaseFile(id: record.id, collectionId: record.collectionId, fileName: record.data['avatar'])
            : null,
        created = record.data['created'] != null ? DateTime.parse(record.data['created']) : null,
        updated = record.data['updated'] != null ? DateTime.parse(record.data['updated']) : null;

  User.fromJSON(this.id, String collectionId, Map<dynamic, dynamic> json)
      : username = json['username'],
        email = json['email'],
        name = json['name'],
        avatar = json['avatar'] != null
            ? PocketBaseFile(
                id: id, collectionId: collectionId, fileName: json['avatar'])
            : null,
        created =
            json['created'] != null ? DateTime.parse(json['created']) : null,
        updated =
            json['updated'] != null ? DateTime.parse(json['updated']) : null;
}