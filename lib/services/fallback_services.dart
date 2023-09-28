import 'package:cloud_firestore/cloud_firestore.dart';

class FallbackService {
  //update post model
  CollectionReference posts =
      FirebaseFirestore.instance.collection('generic_posts');

  Future updatePost() async {
    var querySnapshots = await posts.get();
    for (var doc in querySnapshots.docs) {
      await doc.reference.update({
        'likes': List<String>.empty(),
      });
    }
  }
}
