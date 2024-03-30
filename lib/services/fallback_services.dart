import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_social_app/models/routine_model.dart';
import 'package:fitness_social_app/services/chat_services.dart';
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

  CollectionReference userstats =
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
    var querySnapshots = await userstats.get();

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

  Future populateStepsUserStats(int today, {String? uid}) async {
    // if the user passes userID then consider it or else consider the current user
    var userId = uid ?? ChatService().getCurrentUser()?.uid;

    List<int> stepList = genFakeSteps(today);

    await UserServices().createUserStats("SxPrsR3Ic2hIWfkKJX9SPIzQckm1",
        userId: userId, stepList: stepList);
  }

  Future populateMultipleStepsUserStats(int today) async {
    var querySnapshots = await users.get();
    for (var doc in querySnapshots.docs) {
      await populateStepsUserStats(
        today,
        uid: doc.id,
      );
    }
  }

  int getDay() {
    int dayOfTheWeek = DateTime.now().weekday;
    if (dayOfTheWeek == 7) {
      return 0;
    }
    return dayOfTheWeek;
  }

  Future createSaved() async {
    var querySnapshots = await users.get();
    for (var doc in querySnapshots.docs) {
      await FirebaseFirestore.instance
          .collection("saved")
          .doc(doc.id)
          .update({"meals": List.empty()});
    }
  }
}

int random(int min, int max) {
  return min + Random().nextInt(max - min);
}

List<int> genFakeSteps(int today) {
  List<int> stepList = List.filled(7, 0);

  for (int i = 0; i < today; i++) {
    stepList[i] = random(1500, 3001);
  }

  return stepList;
}
