import 'package:cloud_firestore/cloud_firestore.dart';

class FallbackService {
  //update post model
  CollectionReference posts =
      FirebaseFirestore.instance.collection('generic_posts');

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future updatePost() async {
    var querySnapshots = await posts.get();
    for (var doc in querySnapshots.docs) {
      await doc.reference.update({
        'comments': List<String>.empty(),
      });
    }
  }

  Future updateUser() async {
    var querySnapshots = await users.get();
    for (var doc in querySnapshots.docs) {
      await doc.reference.update({'firstName': '', 'lastName': ''});
    }
  }
}
