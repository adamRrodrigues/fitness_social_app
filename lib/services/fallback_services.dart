import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_social_app/models/routine_model.dart';
import 'package:fitness_social_app/services/user_services.dart';

class FallbackService {
  //update post model
  CollectionReference posts =
      FirebaseFirestore.instance.collection('generic_posts');

  CollectionReference workoutPostsTemplate =
      FirebaseFirestore.instance.collection('workout_templates_demo');

  CollectionReference workoutPosts =
      FirebaseFirestore.instance.collection('user_workouts_demo');

  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference routines =
      FirebaseFirestore.instance.collection('routines');

  CollectionReference user_stats =
      FirebaseFirestore.instance.collection('user_stats');

  Future updatePost() async {
    var querySnapshots = await posts.get();
    for (var doc in querySnapshots.docs) {
      await doc.reference.update({'likeCount': ''});
    }
  }

  Future updateWorkoutTemplatePosts() async {
    var querySnapshots = await workoutPostsTemplate.get();
    for (var doc in querySnapshots.docs) {
      await doc.reference.update({
        'likeCount': 0,
        'likes': FieldValue.arrayUnion([]),
        'rating': FieldValue.delete()
      });
    }
  }

  Future createUserStats() async {
    var querySnapshots = await users.get();
    for (var doc in querySnapshots.docs) {
      await UserServices().createUserStats(doc.id);
    }
  }

  Future updateWorkoutPosts() async {
    var querySnapshots = await workoutPosts.get();
    for (var doc in querySnapshots.docs) {
      await doc.reference.update({
        'likeCount': 0,
        'likes': FieldValue.arrayUnion([]),
        'rating': FieldValue.delete()
      });
    }
  }

  Future updateUser() async {
    var querySnapshots = await users.get();
    for (var doc in querySnapshots.docs) {
      await doc.reference.update({'firstName': '', 'lastName': ''});
    }
  }

  Future printUserStats() async {
    var querySnapshots = await user_stats.get();

    for (var stats in querySnapshots.docs) {
      print(stats.data());
    }
  }

  Future updateRoutines() async {
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
        await routines
            .doc(doc.id)
            .collection('day $i')
            .doc('meals')
            .set({'meals': List.empty()});
      }
    }
  }

  Future createSaved() async {
    var querySnapshots = await users.get();
    for (var doc in querySnapshots.docs) {
      await FirebaseFirestore.instance
          .collection("saved")
          .doc(doc.id)
          .set({"posts": List.empty()});
    }
  }
}
