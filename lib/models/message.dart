import 'package:cloud_firestore/cloud_firestore.dart';

abstract class Message {
  Message({
    required this.from,
    required this.createdAt,
  });

  final String from;
  final Timestamp createdAt;

  Map<String, Object?> toJson();
}
