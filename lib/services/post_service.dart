import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_social_app/models/comment_model.dart';
import 'package:fitness_social_app/models/exercise_model.dart';
import 'package:fitness_social_app/models/generic_post_model.dart';
import 'package:fitness_social_app/models/workout_post_model.dart';
import 'package:fitness_social_app/services/drafts.dart';
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
      List<LocalExerciseModel> exercises) async {
    await workoutPosts.add(workoutModel.toMap()).then((value) async {
      List<String> videoUrls = [];

      await users.doc(thisUser!.uid).update({
        'posts': FieldValue.arrayUnion([value.id]),
      });

      String thumbnail = await StorageServices()
          .postThumbnail('workoutPostImages', value.id, image);

      await workoutPosts.doc(value.id).update({'imageUrl': thumbnail});

      for (int i = 0; i < exercises.length; i++) {
        Map<String, dynamic> exercise = exercises[i].toMap();
        try {
          String exerciseVideo = await StorageServices().storeVideo(
              'workoutPostImages',
              exercises[i].video!,
              value.id,
              "exercise${i.toString()}");
          exercise['imageUrl'] = exerciseVideo;
          videoUrls.add(exerciseVideo);
        } catch (e) {
          exercise['imageUrl'] = "";
          videoUrls.add("");
        }
        await workoutPosts.doc(value.id).update({
          'postId': value.id,
          'templateId': value.id,
          'exercises': FieldValue.arrayUnion([exercise])
        });
      }

      await workoutTemplates
          .doc(value.id)
          .set(workoutModel.toMap())
          .then((e) async {
        for (int i = 0; i < exercises.length; i++) {
          Map<String, dynamic> exercise = exercises[i].toMap();

          try {
            exercise['imageUrl'] = videoUrls[i];
          } catch (e) {
            exercise['imageUrl'] = "";
          }
          await workoutTemplates.doc(value.id).update({
            'postId': value.id,
            'templateId': value.id,
            'isTemplate': true,
            'exercises': FieldValue.arrayUnion([exercise])
          });
        }
      });

      await workoutTemplates.doc(value.id).update({'imageUrl': thumbnail});
    });
  }

  WorkoutModel mapDocPost(QueryDocumentSnapshot<Object?> data) {
    final thisPost = WorkoutModel(
        workoutName: data['workoutName'],
        categories: List.from(data['categories']),
        isTemplate: data['isTemplate'],
        exercises: List.from(data['exercises']),
        uid: data['uid'],
        postId: data['postId'],
        templateId: data['templateId'],
        privacy: data['privacy'],
        imageUrl: data['imageUrl'],
        likeCount: data['likeCount'],
        likes: List.from(data['likes']),
        createdAt: data['createdAt']);
    return thisPost;
  }

  WorkoutModel mapDocPostFuture(Map<String, dynamic> data) {
    final thisPost = WorkoutModel(
        workoutName: data['workoutName'],
        categories: List.from(data['categories']),
        isTemplate: data['isTemplate'],
        exercises: List.from(data['exercises']),
        uid: data['uid'],
        postId: data['postId'],
        templateId: data['templateId'],
        privacy: data['privacy'],
        imageUrl: data['imageUrl'],
        likeCount: data['likeCount'],
        likes: List.from(data['likes']),
        createdAt: data['createdAt']);
    return thisPost;
  }

  ExerciseModel mapExercise(dynamic exerciseModel) {
    final exercise = ExerciseModel(
        name: exerciseModel['name'],
        description: exerciseModel['description'],
        type: exerciseModel['type'],
        time: exerciseModel['time'],
        imageUrl: exerciseModel['imageUrl'],
        toolName: exerciseModel['toolName'],
        weight: exerciseModel['weight'],
        reps: exerciseModel['reps'],
        sets: exerciseModel['sets']);

    return exercise;
  }

  Future editWorkout(WorkoutModel workoutModel, List<dynamic> exercises,
      String editId, bool isTemplate) async {
    try {
      if (isTemplate) {
        await workoutTemplates
            .doc(editId)
            .set(workoutModel.toMap())
            .then((value) async {
          for (int i = 0; i < exercises.length; i++) {
            if (exercises.runtimeType == ExerciseModel) {
              Map<String, dynamic> exercise = exercises[i].toMap();
              await workoutTemplates.doc(editId).update({
                'postId': editId,
                'exercises': FieldValue.arrayUnion([exercise]),
              });
            } else {
              Map<String, dynamic> exercise = exercises[i].toMap();
              try {
                String exerciseVideo = await StorageServices().storeVideo(
                    'workoutPostImages',
                    exercises[i].video!,
                    editId,
                    "exercise${i.toString()}");
                exercise['imageUrl'] = exerciseVideo;
              } catch (e) {
                // exercise['imageUrl'] = "";
              }
              await workoutTemplates.doc(editId).update({
                'postId': workoutModel.templateId,
                "isTemplate": true,
                'exercises': FieldValue.arrayUnion([exercise])
              });
              print(exercise);
            }
          }
        });
      } else {
        await workoutPosts
            .doc(editId)
            .set(workoutModel.toMap())
            .then((value) async {
          for (int i = 0; i < exercises.length; i++) {
            if (exercises.runtimeType == ExerciseModel) {
              Map<String, dynamic> exercise = exercises[i].toMap();
              await workoutPosts.doc(editId).update({
                'postId': editId,
                'exercises': FieldValue.arrayUnion([exercise]),
              });
            } else {
              Map<String, dynamic> exercise = exercises[i].toMap();
              try {
                String exerciseVideo = await StorageServices().storeVideo(
                    'workoutPostImages',
                    exercises[i].video!,
                    editId,
                    "exercise${i.toString()}");
                exercise['imageUrl'] = exerciseVideo;
              } catch (e) {
                // exercise['imageUrl'] = "";
              }
              await workoutPosts.doc(editId).update({
                'postId': editId,
                'exercises': FieldValue.arrayUnion([exercise])
              });
              print(exercise);
            }
          }
        });
      }
    } catch (e) {}
  }

  Future<String> templateToWorkout(
      WorkoutModel workoutModel, List<dynamic> exercises) async {
    String id = "";
    await workoutPosts.add(workoutModel.toMap()).then((value) async {
      id = value.id;
      for (int i = 0; i < exercises.length; i++) {
        if (exercises.runtimeType == ExerciseModel) {
          Map<String, dynamic> exercise = exercises[i].toMap();
          await workoutPosts.doc(value.id).update({
            'postId': value.id,
            'exercises': FieldValue.arrayUnion([exercise]),
          });
          print(exercise);
        } else {
          Map<String, dynamic> exercise = exercises[i].toMap();
          try {
            String exerciseVideo = await StorageServices().storeVideo(
                'workoutPostImages',
                exercises[i].video!,
                value.id,
                "exercise${i.toString()}");
            exercise['imageUrl'] = exerciseVideo;
          } catch (e) {
            // exercise['imageUrl'] = "";
          }
          await workoutPosts.doc(value.id).update({
            'postId': value.id,
            'exercises': FieldValue.arrayUnion([exercise])
          });
          print(exercise);
        }
      }
    });
    return id;
  }

  Future newImage(Uint8List image, String id) async {
    String thumbnail =
        await StorageServices().postThumbnail('workoutPostImages', id, image);

    await workoutPosts.doc(id).update({'imageUrl': thumbnail});
  }

  Future deletePost(id, bool isTemplate) async {
    await StorageServices().deleteImages('workoutPostImages', id);
    if (isTemplate) {
      await workoutTemplates.doc(id).delete();
    } else {
      await FirebaseFirestore.instance
          .collection('user_workouts_demo')
          .doc(id)
          .delete();
    }

    await FirebaseFirestore.instance
        .collection('users')
        .doc(thisUser!.uid)
        .update({
      'posts': FieldValue.arrayRemove([id])
    });
  }

  Future addToSavedWorkouts(String uid, String templateId, bool liked) async {
    if (!liked) {
      await workoutTemplates.doc(templateId).update({
        "likes": FieldValue.arrayUnion([uid]),
        "likeCount": FieldValue.increment(1)
      });
      await FirebaseFirestore.instance.collection('saved').doc(uid).update({
        "posts": FieldValue.arrayUnion([templateId])
      });
    } else {
      await workoutTemplates.doc(templateId).update({
        "likes": FieldValue.arrayRemove([uid]),
        "likeCount": FieldValue.increment(-1)
      });
      await FirebaseFirestore.instance.collection('saved').doc(uid).update({
        "posts": FieldValue.arrayRemove([templateId])
      });
    }
  }

  Future removeFromSavedWorkouts(String templateId, String uid) async {
    await FirebaseFirestore.instance.collection('saved').doc(uid).update({
      "posts": FieldValue.arrayRemove([templateId])
    });
  }
}
