// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class UserStats {
  final String uid;
  final double userWeight;
  final double userHeight;
  final List<int> steps;
  final int workoutStreak;
  final List<Achievement> achievements;
  UserStats({
    required this.uid,
    required this.userWeight,
    required this.userHeight,
    required this.steps,
    required this.workoutStreak,
    required this.achievements,
  });

  UserStats copyWith({
    String? uid,
    double? userWeight,
    double? userHeight,
    List<int>? steps,
    int? workoutStreak,
    List<Achievement>? achievements,
  }) {
    return UserStats(
      uid: uid ?? this.uid,
      userWeight: userWeight ?? this.userWeight,
      userHeight: userHeight ?? this.userHeight,
      steps: steps ?? this.steps,
      workoutStreak: workoutStreak ?? this.workoutStreak,
      achievements: achievements ?? this.achievements,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'userWeight': userWeight,
      'userHeight': userHeight,
      'steps': steps,
      'workoutStreak': workoutStreak,
      'achievements': achievements.map((x) => x.toMap()).toList(),
    };
  }

  factory UserStats.fromMap(Map<String, dynamic> map) {
    return UserStats(
      uid: map['uid'] as String,
      userWeight: map['userWeight'] as double,
      userHeight: map['userHeight'] as double,
      steps: map['steps'] as List<int>,
      workoutStreak: map['workoutStreak'] as int,
      achievements: List<Achievement>.from(
        (map['achievements'] as List<int>).map<Achievement>(
          (x) => Achievement.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserStats.fromJson(String source) =>
      UserStats.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserStats(userWeight: $userWeight, userHeight: $userHeight, steps: $steps, workoutStreak: $workoutStreak, achievements: $achievements)';
  }

  @override
  bool operator ==(covariant UserStats other) {
    if (identical(this, other)) return true;

    return other.userWeight == userWeight &&
        other.userHeight == userHeight &&
        other.steps == steps &&
        other.workoutStreak == workoutStreak &&
        listEquals(other.achievements, achievements);
  }

  @override
  int get hashCode {
    return userWeight.hashCode ^
        userHeight.hashCode ^
        steps.hashCode ^
        workoutStreak.hashCode ^
        achievements.hashCode;
  }
}

class Achievement {
  final String achievementName;
  final String achievementDescription;
  Achievement({
    required this.achievementName,
    required this.achievementDescription,
  });

  Achievement copyWith({
    String? achievementName,
    String? achievementDescription,
  }) {
    return Achievement(
      achievementName: achievementName ?? this.achievementName,
      achievementDescription:
          achievementDescription ?? this.achievementDescription,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'achievementName': achievementName,
      'achievementDescription': achievementDescription,
    };
  }

  factory Achievement.fromMap(Map<String, dynamic> map) {
    return Achievement(
      achievementName: map['achievementName'] as String,
      achievementDescription: map['achievementDescription'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Achievement.fromJson(String source) =>
      Achievement.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'Achievement(achievementName: $achievementName, achievementDescription: $achievementDescription)';

  @override
  bool operator ==(covariant Achievement other) {
    if (identical(this, other)) return true;

    return other.achievementName == achievementName &&
        other.achievementDescription == achievementDescription;
  }

  @override
  int get hashCode =>
      achievementName.hashCode ^ achievementDescription.hashCode;
}
