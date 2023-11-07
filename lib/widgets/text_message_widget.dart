// ignore: depend_on_referenced_packages
// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'package:fluttersimplon/models/text_message.dart';
import 'package:fluttersimplon/widgets/message_widget.dart';

class TextMessageWidget extends MessageWidget {
  TextMessageWidget({
    key,
    required message,
  }) : super(key: key, message: message) {
    if (message is! TextMessage) {
      throw Exception("Le message doit être de type TextMessage");
    }
  }

  @override
  Widget getBody() {
    return Text((message as TextMessage).text);
  }
}
