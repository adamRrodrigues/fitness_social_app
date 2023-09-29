// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:fitness_social_app/models/exercise_model.dart';

class WorkoutModel {
  final String workotName;
  final List<ExerciseModel> exercises;
  final String uid;
  final String postId;
  final String privacy;
  WorkoutModel({
    required this.workotName,
    required this.exercises,
    required this.uid,
    required this.postId,
    required this.privacy,
  });

  WorkoutModel copyWith({
    String? workotName,
    List<ExerciseModel>? exercises,
    String? uid,
    String? postId,
    String? privacy,
  }) {
    return WorkoutModel(
      workotName: workotName ?? this.workotName,
      exercises: exercises ?? this.exercises,
      uid: uid ?? this.uid,
      postId: postId ?? this.postId,
      privacy: privacy ?? this.privacy,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'workotName': workotName,
      'exercises': exercises,
      'uid': uid,
      'postId': postId,
      'privacy': privacy,
    };
  }

}
