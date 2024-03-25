import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageServices {
  final FirebaseStorage storage = FirebaseStorage.instance;

  final user = FirebaseAuth.instance.currentUser;

  Future<String> postThumbnail(
      String name, String postId, Uint8List file) async {
    Reference ref = storage.ref().child(name).child(postId).child('thumbnail');

    UploadTask uploadTask = ref.putData(file);

    TaskSnapshot snap = await uploadTask;

    String downloadUrl = await snap.ref.getDownloadURL();

    return downloadUrl;
  }

  Future<String> storeImage(String name, Uint8List file) async {
    Reference ref = storage.ref().child(name).child(user!.uid);

    UploadTask uploadTask = ref.putData(file);

    TaskSnapshot snap = await uploadTask;

    String downloadUrl = await snap.ref.getDownloadURL();

    return downloadUrl;
  }

  Future<String> storeVideo(
      String name, File video, String postId, String vidId) async {
    Reference ref = storage.ref().child(name).child(postId).child(vidId);

    UploadTask uploadTask = ref.putFile(video);

    TaskSnapshot snap = await uploadTask;

    String downloadUrl = await snap.ref.getDownloadURL();

    return downloadUrl;
  }

  Future deleteImages(String name, String postId) async {
    await FirebaseStorage.instance
        .ref()
        .child(name)
        .child(postId)
        .listAll()
        .then((value) {
      for (var element in value.items) {
        FirebaseStorage.instance.ref(element.fullPath).delete();
      }
    });
  }
}
