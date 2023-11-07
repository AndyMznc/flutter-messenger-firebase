// ignore: depend_on_referenced_packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttersimplon/models/message.dart';
import 'package:jiffy/jiffy.dart';

abstract class MessageWidget extends StatelessWidget {
  final Message message;

  const MessageWidget({
    super.key,
    required this.message,
  });

  ///Vérifie si le message a été écrit par nous
  bool _isMessageFromMe() {
    return FirebaseAuth.instance.currentUser!.email == message.from;
  }

  ///Retourne le padding qui va bien selon l'alignement du message
  EdgeInsets _getMessagePadding() {
    if (_isMessageFromMe()) {
      return const EdgeInsets.only(left: 40, right: 15, top: 0, bottom: 10);
    } else {
      return const EdgeInsets.only(left: 15, right: 40, top: 0, bottom: 10);
    }
  }

  ///Retourne le borderRadius du message
  BorderRadius _getBorderRadius() {
    if (_isMessageFromMe()) {
      return const BorderRadius.only(
        topLeft: Radius.circular(12),
        topRight: Radius.circular(12),
        bottomLeft: Radius.circular(12),
      );
    } else {
      return const BorderRadius.only(
        topLeft: Radius.circular(12),
        topRight: Radius.circular(12),
        bottomRight: Radius.circular(12),
      );
    }
  }

  ///Retourne les couleurs du message
  List<Color> _getColors() {
    if (_isMessageFromMe()) {
      return ([
        Colors.blueAccent.withOpacity(0.7),
        Colors.blueAccent.withOpacity(0.3),
      ]);
    } else {
      return ([
        Colors.grey.shade200,
        Colors.grey.shade200.withOpacity(0.7),
      ]);
    }
  }

  ///Affiche le contenu du message
  Widget getBody();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: _getMessagePadding(),
      child: Align(
        alignment:
            (_isMessageFromMe()) ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: _getBorderRadius(),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: _getColors(),
            ),
          ),
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!_isMessageFromMe())
                Text(
                  message.from,
                  style: const TextStyle(fontSize: 10),
                ),
              getBody(),
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  Jiffy.parseFromDateTime(
                    message.createdAt.toDate(),
                  ).yMMMMEEEEdjm,
                  style: const TextStyle(fontSize: 10),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
