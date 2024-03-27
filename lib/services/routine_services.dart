import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_social_app/models/meal_model.dart';
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
      await routines
          .doc(user!.uid)
          .collection('day $i')
          .doc('meals')
          .set({'meals': List.empty()});
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

  MealModel mapSingleRoutineMeal(Map<String, dynamic> data) {
    final thisMeal = MealModel.fromMap(data);

    return thisMeal;
  }

  Future removeFromWorkoutRoutine(
      String templateId, String userWorkoutId, int day) async {
    routines.doc(user!.uid).collection('day $day').doc('workouts').update({
      'workouts': FieldValue.arrayRemove([
        {'userWorkoutId': userWorkoutId, 'templateId': templateId}
      ])
    });
  }

  Future removeFromMealPlan(String mealId, int day) async {
    routines.doc(user!.uid).collection('day $day').doc('meals').update({
      'meals': FieldValue.arrayRemove([mealId])
    });
  }
}
