import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_social_app/models/workout_post_model.dart';

class RoutineServices {
  CollectionReference routines =
      FirebaseFirestore.instance.collection('routines');

  Future updateRoutine(String uid, int day, String workoutId) async {
    routines.doc(uid).collection('day $day').doc('workouts').update({
      'workouts': FieldValue.arrayUnion([workoutId])
    });
  }

  WorkoutModel mapSingleRoutineWorkout(Map<String, dynamic> data) {
    final thisUser = WorkoutModel.fromMap(data);

    return thisUser;
  }
}
