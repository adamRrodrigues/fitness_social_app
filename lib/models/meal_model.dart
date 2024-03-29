// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class MealModel {
  final String mealName;
  final String description;
  final String uid;
  final String postId;
  final String image;
  final List<dynamic> ingredients;
  final double calories;
  final int servings;
  final List<String> likes;
  final List<String> steps;
  final List<String> tags;
  MealModel({
    required this.mealName,
    required this.description,
    required this.uid,
    required this.postId,
    required this.image,
    required this.ingredients,
    required this.calories,
    required this.servings,
    required this.likes,
    required this.steps,
    required this.tags,
  });

  MealModel copyWith({
    String? mealName,
    String? description,
    String? uid,
    String? postId,
    String? image,
    List<dynamic>? ingredients,
    double? calories,
    int? servings,
    List<String>? likes,
    List<String>? steps,
    List<String>? tags,
  }) {
    return MealModel(
      mealName: mealName ?? this.mealName,
      description: description ?? this.description,
      uid: uid ?? this.uid,
      postId: postId ?? this.postId,
      image: image ?? this.image,
      ingredients: ingredients ?? this.ingredients,
      calories: calories ?? this.calories,
      servings: servings ?? this.servings,
      likes: likes ?? this.likes,
      steps: steps ?? this.steps,
      tags: tags ?? this.tags,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'mealName': mealName,
      'description': description,
      'uid': uid,
      'postId': postId,
      'image': image,
      'ingredients': ingredients,
      'calories': calories,
      'servings': servings,
      'likes': likes,
      'steps': steps,
      'tags': tags,
    };
  }

  factory MealModel.fromMap(Map<String, dynamic> map) {
    return MealModel(
      mealName: map['mealName'] as String,
      description: map['description'] as String,
      uid: map['uid'] as String,
      postId: map['postId'] as String,
      image: map['image'] as String,
      ingredients: List<dynamic>.from((map['ingredients'] as List<dynamic>)),
      calories: map['calories'] as double,
      servings: map['servings'] as int,
      likes: List<String>.from((map['likes'] as List<dynamic>)),
      steps: List<String>.from((map['steps'] as List<dynamic>)),
      tags: List<String>.from((map['tags'] as List<dynamic>)),
    );
  }

  String toJson() => json.encode(toMap());

  factory MealModel.fromJson(String source) =>
      MealModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MealModel(mealName: $mealName, description: $description, uid: $uid, postId: $postId, image: $image, ingredients: $ingredients, calories: $calories, servings: $servings, likes: $likes, steps: $steps, tags: $tags)';
  }

  @override
  bool operator ==(covariant MealModel other) {
    if (identical(this, other)) return true;

    return other.mealName == mealName &&
        other.description == description &&
        other.uid == uid &&
        other.postId == postId &&
        other.image == image &&
        listEquals(other.ingredients, ingredients) &&
        other.calories == calories &&
        other.servings == servings &&
        listEquals(other.likes, likes) &&
        listEquals(other.steps, steps) &&
        listEquals(other.tags, tags);
  }

  @override
  int get hashCode {
    return mealName.hashCode ^
        description.hashCode ^
        uid.hashCode ^
        postId.hashCode ^
        image.hashCode ^
        ingredients.hashCode ^
        calories.hashCode ^
        servings.hashCode ^
        likes.hashCode ^
        steps.hashCode ^
        tags.hashCode;
  }
}
