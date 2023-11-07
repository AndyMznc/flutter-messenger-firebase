import 'package:flutter/material.dart';
import 'package:fluttersimplon/colors.dart';
import 'package:fluttersimplon/drawer.dart';
import 'package:fluttersimplon/models/conversation.dart';
import 'package:fluttersimplon/pages/list_page.dart';
import 'package:fluttersimplon/pages/messages_page.dart';
import 'package:fluttersimplon/pages/users_page.dart';
import 'package:fluttersimplon/services/conversations_service.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
// ignore: depend_on_referenced_packages
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends ListPage {
  static String name = "/home";

  const HomePage({super.key});

  @override
  Widget? getDrawer(BuildContext context) {
    return getAppDrawer(context);
  }

  @override
  Widget? getFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      elevation: 10,
      backgroundColor: Colors.white,
      onPressed: () {
        //Affiche les utilisateurs de la base
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const UsersPage(),
          ),
        );
      },
      child: const Icon(
        Icons.add,
        color: kBlue,
        size: 40,
      ),
    );
  }

  @override
  Widget getBody() {
    return FirestoreListView<Conversation>(
      query: ConversationsServices.getAll()
          .where(
            'between',
            arrayContains: FirebaseAuth.instance.currentUser!.email,
          )
          .orderBy(
            'lastMessageAt',
            descending: true,
          ),
      padding: const EdgeInsets.all(8.0),
      errorBuilder: (context, error, stackTrace) {
        debugPrint((error.toString()));
        return Text(error.toString());
      },
      emptyBuilder: (context) {
        return const Text("Aucune conversation...");
      },
      itemBuilder: (context, snapshot) {
        final conversation = snapshot.data();
        return Column(
          children: [
            InkWell(
              splashColor: kGrey,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MessagesPage(
                      conversation: conversation,
                    ),
                  ),
                );
              },
              child: ListTile(
                leading: const Icon(Icons.person),
                title: Text(conversation.displayName),
                trailing: const Icon(
                  Icons.arrow_right,
                  size: 40,
                ),
              ),
            ),
            const Divider(),
          ],
        );
      },
    );
  }
}
