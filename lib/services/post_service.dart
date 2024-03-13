import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_social_app/models/comment_model.dart';
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
                likeCount: 0,
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
        likeCount: data['likeCount'] ?? 0,
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
        'likes': FieldValue.arrayRemove([uid]),
        'likeCount': FieldValue.increment(-1)
      });
    } else {
      await FirebaseFirestore.instance
          .collection('generic_posts')
          .doc(postId)
          .update({
        'likes': FieldValue.arrayUnion([uid]),
        'likeCount': FieldValue.increment(1)
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

  Future deleteComment(String postId, CommentModel comment) async {
    Map<String, dynamic> exerciseDynamic = comment.toMap();
    await FirebaseFirestore.instance
        .collection('generic_posts')
        .doc(postId)
        .update({
      'comments': FieldValue.arrayRemove([exerciseDynamic])
    });
  }
}

class WorkoutPostServices {
  final thisUser = FirebaseAuth.instance.currentUser;

  CollectionReference workoutPosts =
      FirebaseFirestore.instance.collection('user_workouts_demo');
  CollectionReference workoutTemplates =
      FirebaseFirestore.instance.collection('workout_templates_demo');
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  String id = "";

  Future postWorkout(WorkoutModel workoutModel, Uint8List image,
      List<ExerciseModel> exercises) async {
    await workoutPosts.add(workoutModel.toMap()).then((value) async {
      await users.doc(thisUser!.uid).update({
        'posts': FieldValue.arrayUnion([value.id])
      });

      for (int i = 0; i < exercises.length; i++) {
        Map<String, dynamic> exercise = exercises[i].toMap();
        await workoutPosts.doc(value.id).update({
          'postId': value.id,
          'templateId': value.id,
          'exercises': FieldValue.arrayUnion([exercise])
        });
      }

      String thumbnail = await StorageServices()
          .postThumbnail('workoutPostImages', value.id, image);

      await workoutPosts.doc(value.id).update({'imageUrl': thumbnail});

      print(value.id);

      await workoutTemplates
          .doc(value.id)
          .set(workoutModel.toMap())
          .then((e) async {
        for (int i = 0; i < exercises.length; i++) {
          Map<String, dynamic> exercise = exercises[i].toMap();
          await workoutTemplates.doc(value.id).update({
            'postId': value.id,
            'templateId': value.id,
            'exercises': FieldValue.arrayUnion([exercise])
          });
        }
      });

      await workoutTemplates.doc(value.id).update({'imageUrl': thumbnail});
    });
  }

  ExerciseModel mapExercise(dynamic exerciseModel) {
    final exercise = ExerciseModel(
        name: exerciseModel['name'],
        description: exerciseModel['description'],
        type: exerciseModel['type'],
        time: exerciseModel['time'],
        weight: exerciseModel['weight'],
        reps: exerciseModel['reps'],
        sets: exerciseModel['sets']);

    return exercise;
  }

  Future<String> templateToWorkout(
      WorkoutModel workoutModel, List<ExerciseModel> exercises) async {
    String id = "";
    await workoutPosts.add(workoutModel.toMap()).then((value) async {
      id = value.id;
      for (int i = 0; i < exercises.length; i++) {
        Map<String, dynamic> exercise = exercises[i].toMap();
        await workoutPosts.doc(value.id).update({
          'postId': value.id,
          'exercises': FieldValue.arrayUnion([exercise]),
        });
      }
    });
    return id;
  }

  Future newImage(Uint8List image, String id) async {
    String thumbnail =
        await StorageServices().postThumbnail('workoutPostImages', id, image);

    await workoutPosts.doc(id).update({'imageUrl': thumbnail});
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
