import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_social_app/models/user_model.dart';

class UserServices {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  final user = FirebaseAuth.instance.currentUser;
  Future fetchSpecificUser(String id) async {
   await users.doc(id).get();
  }

  UserModel mapSingleUser(Map<String, dynamic> data) {
    final thisUser = UserModel(
        username: data['username'],
        uid: data['uid'],
        posts: data['posts'],
        profileUrl: data['profileUrl']);

    return thisUser;
  }

  UserModel mapDocUser(QueryDocumentSnapshot<Object?> data) {
    final thisUser = UserModel(
        username: data['username'],
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
}
