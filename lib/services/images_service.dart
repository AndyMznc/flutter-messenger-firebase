import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagesService {
  ///Upload l'image sur Firebase storage et retourne sa download URL
  static Future<String> upload(String messageId, XFile image) async {
    //Créé la référence à l'image allant être uploadée
    final storageRef = FirebaseStorage.instance.ref();
    final imageRef = storageRef.child("images/$messageId/image.jpg");
    final file = File(image.path);
    //Uploade l'image
    return imageRef.putFile(file).then((_) {
      //Récupère sa download URL
      return imageRef.getDownloadURL();
    }, onError: (error) {
      debugPrint(error);
      return;
    });
  }
}
