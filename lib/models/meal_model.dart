// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class MealModel {
  final String mealName;
  final String description;
  final String uid;
  final String postId;
  final List<dynamic> ingredients;
  final List<String> tags;
  MealModel({
    required this.mealName,
    required this.description,
    required this.uid,
    required this.postId,
    required this.ingredients,
    required this.tags,
  });

  MealModel copyWith({
    String? mealName,
    String? description,
    String? uid,
    String? postId,
    List<dynamic>? ingredients,
    List<String>? tags,
  }) {
    return MealModel(
      mealName: mealName ?? this.mealName,
      description: description ?? this.description,
      uid: uid ?? this.uid,
      postId: postId ?? this.postId,
      ingredients: ingredients ?? this.ingredients,
      tags: tags ?? this.tags,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'mealName': mealName,
      'description': description,
      'uid': uid,
      'postId': postId,
      'ingredients': ingredients,
      'tags': tags,
    };
  }

  factory MealModel.fromMap(Map<String, dynamic> map) {
    return MealModel(
        mealName: map['mealName'] as String,
        description: map['description'] as String,
        uid: map['uid'] as String,
        postId: map['postId'] as String,
        ingredients: List<dynamic>.from((map['ingredients'] as List<dynamic>)),
        tags: List<String>.from(
          (map['tags'] as List<String>),
        ));
  }

  String toJson() => json.encode(toMap());

  factory MealModel.fromJson(String source) =>
      MealModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MealModel(mealName: $mealName, description: $description, uid: $uid, postId: $postId, ingredients: $ingredients, tags: $tags)';
  }

  @override
  bool operator ==(covariant MealModel other) {
    if (identical(this, other)) return true;

    return other.mealName == mealName &&
        other.description == description &&
        other.uid == uid &&
        other.postId == postId &&
        listEquals(other.ingredients, ingredients) &&
        listEquals(other.tags, tags);
  }

  @override
  int get hashCode {
    return mealName.hashCode ^
        description.hashCode ^
        uid.hashCode ^
        postId.hashCode ^
        ingredients.hashCode ^
        tags.hashCode;
  }
}
