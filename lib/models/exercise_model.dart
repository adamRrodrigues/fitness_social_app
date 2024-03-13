// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ExerciseModel {
  final String name;
  final String description;
  final String toolName = '';
  final String imageUrl = '';
  final double weight;
  final int reps;
  final int sets;
  final int time;
  final String type;
  ExerciseModel({
    required this.name,
    required this.description,
    this.weight = 0.0,
    this.reps = 0,
    this.sets = 0,
    this.time = 0,
    required this.type,
  });

  ExerciseModel copyWith(
      {String? name,
      String? description,
      double? weight,
      int? reps,
      int? sets,
      int? time,
      String? type}) {
    return ExerciseModel(
        name: name ?? this.name,
        description: description ?? this.description,
        weight: weight ?? this.weight,
        reps: reps ?? this.reps,
        sets: sets ?? this.sets,
        time: time ?? this.time,
        type: type ?? this.type);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'description': description,
      'weight': weight,
      'reps': reps,
      'sets': sets,
      'time': time,
      'type': type
    };
  }

  factory ExerciseModel.fromMap(Map<String, dynamic> map) {
    return ExerciseModel(
      name: map['name'] as String,
      description: map['description'] as String,
      weight: map['weight'] as double,
      reps: map['reps'] as int,
      sets: map['sets'] as int,
      time: map['time'] as int,
      type: map['type'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ExerciseModel.fromJson(String source) =>
      ExerciseModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ExerciseModel(name: $name, description: $description, weight: $weight, reps: $reps, sets: $sets)';
  }

  @override
  bool operator ==(covariant ExerciseModel other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.description == description &&
        other.weight == weight &&
        other.reps == reps &&
        other.sets == sets;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        description.hashCode ^
        weight.hashCode ^
        reps.hashCode ^
        sets.hashCode;
  }
}
