// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:fitness_social_app/models/meal_model.dart';
import 'package:fitness_social_app/models/workout_post_model.dart';

class RoutineModel {
  final int day;
  final List<WorkoutModel> workouts;
  final List<MealModel> meals;

  RoutineModel(
      {required this.day, required this.workouts, required this.meals});
}

class Routine {
  List<RoutineModel> routines = [
    RoutineModel(day: 0, workouts: [], meals: []),
    RoutineModel(day: 1, workouts: [], meals: []),
    RoutineModel(day: 2, workouts: [], meals: []),
    RoutineModel(day: 3, workouts: [], meals: []),
    RoutineModel(day: 4, workouts: [], meals: []),
    RoutineModel(day: 5, workouts: [], meals: []),
    RoutineModel(day: 6, workouts: [], meals: []),
  ];

  void addToRoutine(int day, WorkoutModel workout) {
    routines[day].workouts.add(workout);
  }

  void removeToRoutine(int day, int index) {
    routines[day].workouts.removeAt(index);
  }

  void clearRoutine(int day) {
    routines[day].workouts.clear();
  }

  List<WorkoutModel> workoutSession = [];
}

class OnlineRoutineModel {
  final int day;
  final List<String> workouts;
  final List<String> meals;
  OnlineRoutineModel({
    required this.day,
    required this.workouts,
    required this.meals,
  });

  OnlineRoutineModel copyWith({
    int? day,
    List<String>? workouts,
    List<String>? meals,
  }) {
    return OnlineRoutineModel(
      day: day ?? this.day,
      workouts: workouts ?? this.workouts,
      meals: meals ?? this.meals,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'day': day,
      'workouts': workouts,
      'meals': meals,
    };
  }

  factory OnlineRoutineModel.fromMap(Map<String, dynamic> map) {
    return OnlineRoutineModel(
      day: map['day'] as int,
      workouts: List<String>.from((map['workouts'] as List<String>)),
      meals: List<String>.from((map['meals'] as List<String>)),
    );
  }

  String toJson() => json.encode(toMap());

  factory OnlineRoutineModel.fromJson(String source) =>
      OnlineRoutineModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'OnlineRoutineModel(day: $day, workouts: $workouts, meals: $meals)';

  @override
  bool operator ==(covariant OnlineRoutineModel other) {
    if (identical(this, other)) return true;

    return other.day == day &&
        listEquals(other.workouts, workouts) &&
        listEquals(other.meals, meals);
  }

  @override
  int get hashCode => day.hashCode ^ workouts.hashCode ^ meals.hashCode;
}

class OnlineRoutine {
  final String uid;

  // void addToRoutine(int day, String workout) {
  //   routines[day].workouts.add(workout);
  // }

  OnlineRoutine({
    required this.uid,
  });

  OnlineRoutine copyWith({
    String? uid,
  }) {
    return OnlineRoutine(
      uid: uid ?? this.uid,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
    };
  }

  factory OnlineRoutine.fromMap(Map<String, dynamic> map) {
    return OnlineRoutine(
      uid: map['uid'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory OnlineRoutine.fromJson(String source) =>
      OnlineRoutine.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'OnlineRoutine(uid: $uid)';

  @override
  bool operator ==(covariant OnlineRoutine other) {
    if (identical(this, other)) return true;

    return other.uid == uid;
  }

  @override
  int get hashCode => uid.hashCode;
}
