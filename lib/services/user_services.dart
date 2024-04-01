import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_social_app/models/user_model.dart';
import 'package:fitness_social_app/models/user_stats.dart';

class UserServices {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  final user = FirebaseAuth.instance.currentUser;
  Future fetchSpecificUser(String id) async {
    await users.doc(id).get();
  }

  UserModel mapSingleUser(Map<String, dynamic> data) {
    final thisUser = UserModel(
        username: data['username'],
        firstName: data['firstName'],
        lastName: data['lastName'],
        uid: data['uid'],
        posts: data['posts'],
        profileUrl: data['profileUrl']);

    return thisUser;
  }

  UserModel mapDocUser(QueryDocumentSnapshot<Object?> data) {
    final thisUser = UserModel(
        username: data['username'],
        firstName: data['firstName'],
        lastName: data['lastName'],
        uid: data['uid'],
        posts: data['posts'],
        profileUrl: data['profileUrl']);

    return thisUser;
  }

  Future followUser(String uid) async {
    //follow
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('followers')
        .doc(user!.uid)
        .set({});

    //add to following
    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('following')
        .doc(uid)
        .set({});
  }

  Future unfollowUser(String uid) async {
    //unfollow
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('followers')
        .doc(user!.uid)
        .delete();

    //remove from following
    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('following')
        .doc(uid)
        .delete();
  }

  Future<List<String>> fetchFollowers(uid) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('followers')
        .get();

    List<String> followers = querySnapshot.docs.map((e) => e.id).toList();

    return followers;
  }

  Future<List<String>> fetchFollowing(uid) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('following')
        .get();

    List<String> following = querySnapshot.docs.map((e) => e.id).toList();

    return following;
  }

  Future createUserStats(String uid,
      {List<int>? stepList, String? userId}) async {
    await FirebaseFirestore.instance.collection('user_stats').doc(uid).set(
        UserStats(
                uid: uid,
                userWeight: 0,
                userHeight: 0,
                stepsGoal: 1000,
                steps: stepList ?? List.generate(7, (index) => 0),
                workoutStreak: 0,
                achievements: List.empty())
            .toMap());
  }

  Future getUser(String uid) async {
    // postQuery = FirebaseFirestore.instance
    //     .collection("users")
    //     .doc(uid)
    //    );

    final docRef = FirebaseFirestore.instance.collection('users').doc(uid);

    final snapshot = await docRef.get();

    if (snapshot.exists) {
      return UserModel.fromMap(snapshot.data()!);
    }

    return null;

    // return UserModel.fromMap(docRef.get())

    // final snapshot = await docRef.get();
    // if (snapshot.exists) {
    //   return snapshot.data();
    // }
    // return null; // Handle case where user data doesn't exist
  }
}
