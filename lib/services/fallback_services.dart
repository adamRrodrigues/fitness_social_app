import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_social_app/models/routine_model.dart';

class FallbackService {
  //update post model
  CollectionReference posts =
      FirebaseFirestore.instance.collection('generic_posts');

  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference routines =
      FirebaseFirestore.instance.collection('routines');

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

  Future addRoutines() async {
    var querySnapshots = await users.get();
    // var routinesSnaps = await routines.get();
    for (var doc in querySnapshots.docs) {
      await routines.doc(doc.id).set(OnlineRoutine(uid: doc.id).toMap());
      for (int i = 0; i < 7; i++) {
        await routines.doc(doc.id).collection('day $i').add({});
        await routines
            .doc(doc.id)
            .collection('day $i')
            .doc('workouts')
            .set({'workouts': List.empty()});
      }
    }
  }
}
