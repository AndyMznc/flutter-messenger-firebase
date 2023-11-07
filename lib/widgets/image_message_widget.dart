// ignore: depend_on_referenced_packages
// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'package:fluttersimplon/models/image_message.dart';
import 'package:fluttersimplon/widgets/message_widget.dart';

class ImageMessageWidget extends MessageWidget {
  ImageMessageWidget({
    key,
    required message,
  }) : super(key: key, message: message) {
    if (message is! ImageMessage) {
      throw Exception("Le message doit être de type ImageMessage");
    }
  }

  @override
  Widget getBody() {
    if ((message as ImageMessage).imageUrl != null) {
      return Image.network((message as ImageMessage).imageUrl!);
    }
    return const SizedBox();
  }
}
