import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttersimplon/models/user.dart';

class UsersServices {
  ///Retourne les utilisateurs
  static CollectionReference<User> getAll() {
    final collectionRef = FirebaseFirestore.instance.collection('users');
    return collectionRef.withConverter<User>(
      fromFirestore: (snapshot, _) =>
          User.fromJson(snapshot.id, snapshot.data()!),
      toFirestore: (user, _) => user.toJson(),
    );
  }

  ///Ajoute ou met à jour un utilisateur
  static set(String uid, String email) {
    FirebaseFirestore.instance.collection("users").doc(uid).set(
      {
        'email': email,
      },
      SetOptions(merge: true),
    );
  }
}
