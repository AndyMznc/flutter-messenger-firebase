import 'package:cloud_firestore/cloud_firestore.dart';
// ignore: depend_on_referenced_packages
import 'package:firebase_auth/firebase_auth.dart';

class Conversation {
  Conversation({
    required this.id,
    required this.name,
    required this.between,
    required this.lastMessageAt,
  });
  Conversation.fromJson(String id, Map<String, Object?> json)
      : this(
          id: id,
          name: json.containsKey('name') ? json['name'] as String : null,
          between: List<String>.from(json['between'] as List),
          lastMessageAt: json['lastMessageAt'] as Timestamp,
        );

  final String id;
  final String? name;
  final List<String> between;
  final Timestamp lastMessageAt;

  Map<String, Object?> toJson() {
    Map<String, Object?> result = {
      'between': between,
      'lastMessageAt': lastMessageAt,
    };
    if (name != null) {
      result['name'] = name;
    }
    return result;
  }

  String get displayName {
    if (name != null) {
      return name!;
    } else {
      //Pour l'instant on prend le 1er email différent du nôtre...
      return between.firstWhere(
        (element) => element != FirebaseAuth.instance.currentUser!.email,
      );
    }
  }
}
