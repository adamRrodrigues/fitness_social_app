// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class WorkoutModel {
  final String workoutName;
  final List<String> categories;
  final List<dynamic> exercises;
  final String uid;
  final String postId;
  final String templateId;
  final String privacy;
  final String imageUrl;
  final List<String> likes;
  final int likeCount;
  final Timestamp createdAt;
  WorkoutModel({
    required this.workoutName,
    required this.categories,
    required this.exercises,
    required this.uid,
    required this.postId,
    required this.templateId,
    required this.privacy,
    required this.imageUrl,
    required this.likeCount,
    required this.likes,
    required this.createdAt,
  });

  WorkoutModel copyWith({
    String? workoutName,
    List<String>? categories,
    List<dynamic>? exercises,
    String? uid,
    String? postId,
    String? templateId,
    String? privacy,
    String? imageUrl,
    int? likeCount,
    List<String>? likes,
    Timestamp? createdAt,
  }) {
    return WorkoutModel(
        workoutName: workoutName ?? this.workoutName,
        categories: categories ?? this.categories,
        exercises: exercises ?? this.exercises,
        uid: uid ?? this.uid,
        postId: postId ?? this.postId,
        templateId: templateId ?? this.templateId,
        privacy: privacy ?? this.privacy,
        imageUrl: imageUrl ?? this.imageUrl,
        createdAt: createdAt ?? this.createdAt,
        likeCount: likeCount ?? this.likeCount,
        likes: likes ?? this.likes);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'workoutName': workoutName,
      'categories': categories,
      'exercises': exercises,
      'uid': uid,
      'postId': postId,
      'templateId': templateId,
      'privacy': privacy,
      'imageUrl': imageUrl,
      'likeCount': likeCount,
      'likes': likes,
      'createdAt': createdAt,
    };
  }

  factory WorkoutModel.fromMap(Map<String, dynamic> map) {
    return WorkoutModel(
      workoutName: map['workoutName'] as String,
      categories: List<String>.from((map['categories'] as List<dynamic>)),
      exercises: List<dynamic>.from((map['exercises'] as List<dynamic>)),
      uid: map['uid'] as String,
      postId: map['postId'] as String,
      templateId: map['templateId'] as String,
      privacy: map['privacy'] as String,
      imageUrl: map['imageUrl'] as String,
      likeCount: map['likeCount'] as int,
      likes: List<String>.from((map['likes'] as List<dynamic>)),
      createdAt: map['createdAt'],
    );
  }

  String toJson() => json.encode(toMap());

  factory WorkoutModel.fromJson(String source) =>
      WorkoutModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'WorkoutModel(workoutName: $workoutName, categories: $categories, exercises: $exercises, uid: $uid , postId: $postId, postId: $postId, privacy: $privacy, imageUrl: $imageUrl, likeCount: $likeCount, likes: $likes , createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant WorkoutModel other) {
    if (identical(this, other)) return true;

    return other.workoutName == workoutName &&
        listEquals(other.categories, categories) &&
        listEquals(other.exercises, exercises) &&
        other.uid == uid &&
        other.privacy == privacy &&
        other.imageUrl == imageUrl &&
        other.likeCount == likeCount &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return workoutName.hashCode ^
        categories.hashCode ^
        exercises.hashCode ^
        uid.hashCode ^
        privacy.hashCode ^
        imageUrl.hashCode ^
        likeCount.hashCode ^
        createdAt.hashCode;
  }
}
