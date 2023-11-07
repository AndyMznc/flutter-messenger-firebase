import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttersimplon/models/message.dart';

class ImageMessage extends Message {
  String? imageUrl;

  // ignore: use_super_parameters
  ImageMessage({
    required this.imageUrl,
    required from,
    required createdAt,
  }) : super(createdAt: createdAt, from: from);

  ImageMessage.fromJson(Map<String, Object?> json)
      : this(
          imageUrl: json.containsKey('imageUrl') && json['imageUrl'] != null
              ? json['imageUrl'].toString()
              : null,
          from: json['from'].toString(),
          createdAt: json['createdAt'] as Timestamp,
        );

  @override
  Map<String, Object?> toJson() {
    return {
      'imageUrl': imageUrl,
      'from': from,
      'createdAt': createdAt,
    };
  }
}
