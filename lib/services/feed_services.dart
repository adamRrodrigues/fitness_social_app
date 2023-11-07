import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_social_app/models/generic_post_model.dart';
import 'package:fitness_social_app/models/workout_post_model.dart';
import 'package:fitness_social_app/services/user_services.dart';

class FeedServices {
  List<String> following = [];

  Query<GenericPost> fetchPosts(uid) {
    final postQuery;
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

  Query<WorkoutModel> fetchWorkouts(uid) {
    final postQuery;
    postQuery =
        FirebaseFirestore.instance.collection('workout_posts').withConverter(
              fromFirestore: (snapshot, _) =>
                  WorkoutModel.fromMap(snapshot.data()!),
              toFirestore: (post, _) => post.toMap(),
            );
    return postQuery;
  }

  Query<WorkoutModel> fetchUserWorkouts(uid) {
    final postQuery = FirebaseFirestore.instance
        .collection('workout_posts')
        .where('uid', isEqualTo: uid)
        .withConverter(
          fromFirestore: (snapshot, _) =>
              WorkoutModel.fromMap(snapshot.data()!),
          toFirestore: (post, _) => post.toMap(),
        );

    return postQuery;
  }

  Stream fetchFollowing(uid) async* {
    following = await UserServices().fetchFollowing(uid);
  }
}
