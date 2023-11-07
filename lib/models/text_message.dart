import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttersimplon/models/message.dart';

class TextMessage extends Message {
  final String text;

  // ignore: use_super_parameters
  TextMessage({
    required this.text,
    required from,
    required createdAt,
  }) : super(createdAt: createdAt, from: from);

  TextMessage.fromJson(Map<String, Object?> json)
      : this(
          text: json['text'].toString(),
          from: json['from'].toString(),
          createdAt: json['createdAt'] as Timestamp,
        );

  @override
  Map<String, Object?> toJson() {
    return {
      'text': text,
      'from': from,
      'createdAt': createdAt,
    };
  }
}
