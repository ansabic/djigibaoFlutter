import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

part 'song.g.dart';

@HiveType(typeId: 2)
class Song {
  @HiveField(0)
  final String title;
  @HiveField(1)
  final String body;
  @HiveField(2)
  final String author;
  @HiveField(3)
  final DateTime created;
  @HiveField(4)
  final DateTime lastModified;

  Song(
      {required this.title,
      required this.body,
      required this.author,
      required this.created,
      required this.lastModified});

  Song.fromJson(Map<String, dynamic> json)
      : title = json["title"],
        body = json["body"],
        author = json["author"],
        created = (json["created"] as Timestamp).toDate(),
        lastModified = (json["lastModified"] as Timestamp).toDate();

  Map<String, dynamic> toJson() => {
        "title": title,
        "body": body,
        "author": author,
        "created": created,
        "lastModified": lastModified
      };
}
