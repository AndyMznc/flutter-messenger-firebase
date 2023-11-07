import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttersimplon/models/conversation.dart';
// ignore: depend_on_referenced_packages
import 'package:firebase_auth/firebase_auth.dart';

class ConversationsServices {
  ///Retourne les conversations
  static CollectionReference<Conversation> getAll() {
    final collectionRef =
        FirebaseFirestore.instance.collection('conversations');
    return collectionRef.withConverter<Conversation>(
      fromFirestore: (snapshot, _) =>
          Conversation.fromJson(snapshot.id, snapshot.data()!),
      toFirestore: (conversation, _) => conversation.toJson(),
    );
  }

  ///Retourne une conversation
  static Future<Conversation> get(String id) async {
    final docSnapshot = await FirebaseFirestore.instance
        .collection('conversations')
        .doc(id)
        .get();
    return Conversation.fromJson(docSnapshot.id, docSnapshot.data()!);
  }

  ///Met à jour la date/heure du dernier message de la conversation
  static Future<void> updateLastMessageAt(
    String conversationId,
    Timestamp lastMessageAt,
  ) async {
    final docRef = FirebaseFirestore.instance
        .collection('conversations')
        .doc(conversationId);
    return docRef.set(
      {'lastMessageAt': lastMessageAt},
      SetOptions(merge: true),
    );
  }

  ///Ajoute une nouvelle conversation et retourne son id
  static Future<String> add(String toUserEmail) async {
    final docRef =
        await FirebaseFirestore.instance.collection('conversations').add(
      {
        'between': [toUserEmail, FirebaseAuth.instance.currentUser!.email!],
        //Met une date/heure du dernier message à maintenant pour afficher
        //correctement la conversation dans la liste.
        'lastMessageAt': Timestamp.now(),
      },
    );
    return docRef.id;
  }
}
