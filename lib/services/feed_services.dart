import 'package:cloud_firestore/cloud_firestore.dart';

class FeedServices {
  CollectionReference posts =
      FirebaseFirestore.instance.collection('generic_posts');
  List<QuerySnapshot> postList = [];
  Stream fetchFirstBatch() async* {
    var list =  posts.limit(5).get();


  }
}
