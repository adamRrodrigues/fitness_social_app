import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_social_app/models/generic_post_model.dart';
import 'package:fitness_social_app/models/meal_model.dart';
import 'package:fitness_social_app/models/user_model.dart';
import 'package:fitness_social_app/models/workout_post_model.dart';
import 'package:fitness_social_app/services/user_services.dart';

class FeedServices {
  List<String> following = [];
  User user = FirebaseAuth.instance.currentUser!;

  Query<GenericPost> fetchPosts(uid) {
    final Query<GenericPost> postQuery;
    postQuery = FirebaseFirestore.instance
        .collection('generic_posts')
        .where('uid', whereIn: following)
        .orderBy('createdAt', descending: true)
        .withConverter(
          fromFirestore: (snapshot, _) => GenericPost.fromMap(snapshot.data()!),
          toFirestore: (post, _) => post.toMap(),
        );
    return postQuery;
  }

  Query<UserModel> fetchNonFollowedUsers(String uid) {
    final Query<UserModel> postQuery;

    postQuery = FirebaseFirestore.instance
        .collection('users')
        .where('uid', whereNotIn: following)
        .withConverter(
          fromFirestore: (snapshot, _) => UserModel.fromMap(snapshot.data()!),
          toFirestore: (value, options) => value.toMap(),
        );
    return postQuery;
  }

  Query<GenericPost> fetchUserPosts(uid) {
    final postQuery = FirebaseFirestore.instance
        .collection('generic_posts')
        .where('uid', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .withConverter(
          fromFirestore: (snapshot, _) => GenericPost.fromMap(snapshot.data()!),
          toFirestore: (post, _) => post.toMap(),
        );

    return postQuery;
  }

  Query<WorkoutModel> fetchWorkouts(String uid) {
    final Query<WorkoutModel> postQuery;
    postQuery = FirebaseFirestore.instance
        .collection('workout_templates_demo')
        .where("uid", isNotEqualTo: uid)
        .withConverter(
          fromFirestore: (snapshot, _) =>
              WorkoutModel.fromMap(snapshot.data()!),
          toFirestore: (post, _) => post.toMap(),
        );
    return postQuery;
  }

  Query<MealModel> fetchMeals() {
    final CollectionReference<MealModel> postQuery;
    postQuery = FirebaseFirestore.instance
        .collection('meals_demo')
        .withConverter(
          fromFirestore: (snapshot, _) => MealModel.fromMap(snapshot.data()!),
          toFirestore: (post, _) => post.toMap(),
        );
    return postQuery;
  }

  Query<WorkoutModel> fetchUserWorkouts(uid) {
    final postQuery = FirebaseFirestore.instance
        .collection(
            user.uid == uid ? 'user_workouts_demo' : 'workout_templates_demo')
        .where('uid', isEqualTo: uid)
        .withConverter(
          fromFirestore: (snapshot, _) =>
              WorkoutModel.fromMap(snapshot.data()!),
          toFirestore: (post, _) => post.toMap(),
        );

    return postQuery;
  }

  WorkoutModel mapSingleWorkout(
      DocumentSnapshot<Map<String, dynamic>> workoutData) {
    WorkoutModel thisWorkout = WorkoutModel(
        workoutName: workoutData['workoutName'],
        categories: List.from(workoutData['categories']),
        exercises: workoutData["exercises"],
        uid: workoutData['uid'],
        postId: workoutData['postId'],
        templateId: workoutData['templateId'],
        privacy: workoutData['privacy'],
        imageUrl: workoutData['imageUrl'],
        likeCount: workoutData['likeCount'],
        likes: List.from(workoutData['likes']),
        createdAt: workoutData['createdAt']);
    return thisWorkout;
  }

  Stream fetchFollowing(uid) async* {
    following = await UserServices().fetchFollowing(uid);
  }

  Stream fetchUserRoutine(String uid, int day) async* {
    FirebaseFirestore.instance
        .collection('routines')
        .doc(uid)
        .collection('day $day')
        .doc('workouts')
        .snapshots();
  }
}
