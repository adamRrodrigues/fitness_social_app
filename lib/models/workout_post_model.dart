// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class WorkoutModel {
  final String workoutName;
  final List<String> categories;
  final List<dynamic> exercises;
  final String uid;
  final String privacy;
  final String imageUrl;
  WorkoutModel({
    required this.workoutName,
    required this.categories,
    required this.exercises,
    required this.uid,
    required this.privacy,
    required this.imageUrl,
  });

  WorkoutModel copyWith({
    String? workoutName,
    List<String>? categories,
    List<dynamic>? exercises,
    String? uid,
    String? privacy,
    String? imageUrl,
  }) {
    return WorkoutModel(
      workoutName: workoutName ?? this.workoutName,
      categories: categories ?? this.categories,
      exercises: exercises ?? this.exercises,
      uid: uid ?? this.uid,
      privacy: privacy ?? this.privacy,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'workoutName': workoutName,
      'categories': categories,
      'exercises': exercises,
      'uid': uid,
      'privacy': privacy,
      'imageUrl': imageUrl,
    };
  }

  factory WorkoutModel.fromMap(Map<String, dynamic> map) {
    return WorkoutModel(
      workoutName: map['workoutName'] as String,
      categories: List<String>.from((map['categories'] as List<dynamic>)),
      exercises: List<dynamic>.from((map['exercises'] as List<dynamic>)),
      uid: map['uid'] as String,
      privacy: map['privacy'] as String,
      imageUrl: map['imageUrl'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory WorkoutModel.fromJson(String source) =>
      WorkoutModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'WorkoutModel(workoutName: $workoutName, categories: $categories, exercises: $exercises, uid: $uid, privacy: $privacy, imageUrl: $imageUrl)';
  }

  @override
  bool operator ==(covariant WorkoutModel other) {
    if (identical(this, other)) return true;

    return other.workoutName == workoutName &&
        listEquals(other.categories, categories) &&
        listEquals(other.exercises, exercises) &&
        other.uid == uid &&
        other.privacy == privacy &&
        other.imageUrl == imageUrl;
  }

  @override
  int get hashCode {
    return workoutName.hashCode ^
        categories.hashCode ^
        exercises.hashCode ^
        uid.hashCode ^
        privacy.hashCode ^
        imageUrl.hashCode;
  }
}
