import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_social_app/models/exercise_model.dart';
import 'package:fitness_social_app/models/generic_post_model.dart';
import 'package:fitness_social_app/models/workout_post_model.dart';
import 'package:fitness_social_app/services/storage_services.dart';

class GenericPostServices {
  final thisUser = FirebaseAuth.instance.currentUser;

  CollectionReference genPosts =
      FirebaseFirestore.instance.collection('generic_posts');
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference posts =
      FirebaseFirestore.instance.collection('generic_posts');

  Future publishPost(String postName, Uint8List image) async {
    await genPosts
        .add(GenericPost(
                postName: postName,
                uid: thisUser!.uid,
                likes: List.empty(),
                comments: List.empty(),
                image: '',
                createdAt: Timestamp.now())
            .toMap())
        .then((value) async {
      await users.doc(thisUser!.uid).update({
        'posts': FieldValue.arrayUnion([value.id])
      });

      String thumbnail = await StorageServices()
          .postThumbnail('genericPostImages', value.id, image);

      await posts.doc(value.id).update({'image': thumbnail});
    });
  }

  GenericPost mapDocPost(QueryDocumentSnapshot<Object?> data) {
    final thisPost = GenericPost(
        postName: data['postName'],
        uid: data['uid'],
        comments: List.from(data['comments']),
        likes: List.from(data['likes']),
        image: data['image'],
        createdAt: data['createdAt']);
    print(thisPost);
    return thisPost;
  }

  Future deletePost(id, userId) async {
    await StorageServices().deleteImages('genericPostImages', id);
    await FirebaseFirestore.instance
        .collection('generic_posts')
        .doc(id)
        .delete();
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'posts': FieldValue.arrayRemove([id])
    });
  }

  Future likePost(postId, uid, liked) async {
    if (liked) {
      await FirebaseFirestore.instance
          .collection('generic_posts')
          .doc(postId)
          .update({
        'likes': FieldValue.arrayRemove([uid])
      });
    } else {
      await FirebaseFirestore.instance
          .collection('generic_posts')
          .doc(postId)
          .update({
        'likes': FieldValue.arrayUnion([uid])
      });
    }
  }

  Future comment(String postId, String uid, String comment) async {
    await genPosts.doc(postId).update({
      'comments': FieldValue.arrayUnion([
        {'uid': uid, 'comment': comment}
      ])
    });
  }
}

class WorkoutPostServices {
  final thisUser = FirebaseAuth.instance.currentUser;

  CollectionReference workoutPosts =
      FirebaseFirestore.instance.collection('workout_posts');
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future postWorkout(WorkoutModel workoutModel, Uint8List image,
      List<ExerciseModel> exercises) async {
    await workoutPosts.add(workoutModel.toMap()).then((value) async {
      await users.doc(thisUser!.uid).update({
        'posts': FieldValue.arrayUnion([value.id])
      });

      for (int i = 0; i < exercises.length; i++) {
        Map<String, dynamic> exercise = exercises[i].toMap();
        await workoutPosts.doc(value.id).update({
          'exercises': FieldValue.arrayUnion([exercise])
        });
      }

      String thumbnail = await StorageServices()
          .postThumbnail('workoutPostImages', value.id, image);

      await workoutPosts.doc(value.id).update({'imageUrl': thumbnail});
    });
  }

  Future deletePost(id, userId) async {
    await StorageServices().deleteImages('workoutPostImages', id);
    await FirebaseFirestore.instance
        .collection('workout_posts')
        .doc(id)
        .delete();
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'posts': FieldValue.arrayRemove([id])
    });
  }
}
