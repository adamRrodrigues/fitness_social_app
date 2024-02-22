import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_social_app/models/routine_model.dart';
import 'package:fitness_social_app/models/workout_post_model.dart';

class RoutineServices {
  CollectionReference routines =
      FirebaseFirestore.instance.collection('routines');
  final user = FirebaseAuth.instance.currentUser;
  Future createRoutine() async {
    await routines.doc(user!.uid).set(OnlineRoutine(uid: user!.uid).toMap());
    for (int i = 0; i < 7; i++) {
      await routines.doc(user!.uid).collection('day $i').add({});
      await routines
          .doc(user!.uid)
          .collection('day $i')
          .doc('workouts')
          .set({'workouts': List.empty()});
    }
  }

  Future updateRoutine(
      String uid, int day, String workoutId, String templateId) async {
    routines.doc(uid).collection('day $day').doc('workouts').update({
      'workouts': FieldValue.arrayUnion([
        {'userWorkoutId': workoutId, 'templateId': templateId}
      ])
    });
  }

  WorkoutModel mapSingleRoutineWorkout(Map<String, dynamic> data) {
    final thisUser = WorkoutModel.fromMap(data);

    return thisUser;
  }
}
