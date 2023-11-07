import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttersimplon/colors.dart';
import 'package:fluttersimplon/models/conversation.dart';
import 'package:fluttersimplon/models/image_message.dart';
import 'package:fluttersimplon/models/message.dart';
import 'package:fluttersimplon/models/text_message.dart';
import 'package:fluttersimplon/pages/list_page.dart';
import 'package:fluttersimplon/services/images_service.dart';
import 'package:fluttersimplon/services/messages_service.dart';
import 'package:fluttersimplon/styles.dart';
import 'package:fluttersimplon/widgets/image_message_widget.dart';
import 'package:fluttersimplon/widgets/text_message_widget.dart';
// ignore: depend_on_referenced_packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class MessagesPage extends ListPage {
  final Conversation conversation;

  const MessagesPage({
    super.key,
    required this.conversation,
  });

  @override
  Widget getTitle() {
    return Text(
      conversation.displayName,
      style: appBarTitle,
    );
  }

  @override
  Widget getBody() {
    return Column(
      children: [
        Expanded(
          child: FirestoreListView<Message>(
            reverse: true,
            query: MessagesServices.getAll(conversation.id).orderBy(
              'createdAt',
              descending: true,
            ),
            padding: const EdgeInsets.all(8.0),
            itemBuilder: (context, snapshot) {
              final message = snapshot.data();
              if (message is TextMessage) {
                return TextMessageWidget(message: message);
              }
              if (message is ImageMessage && message.imageUrl != null) {
                return ImageMessageWidget(message: message);
              }
              return const SizedBox();
            },
          ),
        ),
        InputBottomAppBar(conversation: conversation),
      ],
    );
  }
}

class InputBottomAppBar extends StatefulWidget {
  final Conversation conversation;

  const InputBottomAppBar({
    super.key,
    required this.conversation,
  });

  @override
  State<InputBottomAppBar> createState() => _InputBottomAppBarState();
}

class _InputBottomAppBarState extends State<InputBottomAppBar> {
  final _textMessageController = TextEditingController();

  @override
  void dispose() {
    _textMessageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      surfaceTintColor: Colors.white,
      child: Container(
        padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
        color: Colors.white,
        child: Row(
          children: [
            //Bouton "+" pour ajouter du contenu au message
            GestureDetector(
              onTap: _addImage,
              child: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: TextField(
                controller: _textMessageController,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 5,
                    horizontal: 5,
                  ),
                  hintText: "Taper votre message...",
                  hintStyle: const TextStyle(color: kGrey),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                textCapitalization: TextCapitalization.sentences,
                keyboardType: TextInputType.multiline,
                maxLines: null,
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            //Bouton envoi du message
            FloatingActionButton(
              backgroundColor: Theme.of(context).primaryColor,
              mini: true,
              onPressed: _sendMessage,
              child: const Icon(
                Icons.send,
                color: Colors.white,
                size: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///Ajoute une image à la conversation
  void _addImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      //Si on n'a pas chargé d'image, on en reste là
      if (image == null) {
        debugPrint("Pas de photo sélectionnée");
        return;
      }
      //On upload les fichiers sur Firebase storage
      //Pour l'instant on laisse l'URL de l'image à null
      ImageMessage message = ImageMessage(
        imageUrl: null,
        from: FirebaseAuth.instance.currentUser!.email!,
        createdAt: Timestamp.now(),
      );
      //Créé le message et récupère son id
      final messageId = await MessagesServices.add(
        widget.conversation.id,
        message,
      );
      //Upload la photo et retourne son URL
      final downloadUrl = await ImagesService.upload(messageId, image);
      message.imageUrl = downloadUrl;
      //Met à jour le message avec l'URL de l'image
      await MessagesServices.update(
        widget.conversation.id,
        messageId,
        message,
      );
    } on PlatformException catch (e) {
      String errorText;
      switch (e.code) {
        case 'photo_access_denied':
          errorText = "Veuillez autoriser l'application à accéder à vos photos";
          break;
        default:
          errorText = "Impossible d'accéder à vos photos";
      }
      if (context.mounted) {
        showTopSnackBar(
          Overlay.of(context),
          CustomSnackBar.error(
            message: errorText,
          ),
        );
      }
    }
  }

  ///Envoi le message
  void _sendMessage() {
    String textMessage = _textMessageController.text.trim();
    if (textMessage.isNotEmpty) {
      //Créer le message
      final message = TextMessage(
        text: textMessage,
        from: FirebaseAuth.instance.currentUser!.email!,
        createdAt: Timestamp.now(),
      );
      //Enregistre en base
      MessagesServices.add(widget.conversation.id, message).then(
        (_) => _textMessageController.clear(),
      );
    }
  }
}
