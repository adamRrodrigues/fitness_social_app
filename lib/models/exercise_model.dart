// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ExerciseModel {
  final String name;
  final String description;
  final String toolName = '';
  final double weight;
  final String imageUrl = '';
  final int reps;
  final int time = 0;
  final int sets;
  ExerciseModel({
    required this.name,
    required this.description,
    required this.weight,
    required this.reps,
    required this.sets,
  });

  

  ExerciseModel copyWith({
    String? name,
    String? description,
    double? weight,
    int? reps,
    int? sets,
  }) {
    return ExerciseModel(
      name: name ?? this.name,
      description: description ?? this.description,
      weight: weight ?? this.weight,
      reps: reps ?? this.reps,
      sets: sets ?? this.sets,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'description': description,
      'weight': weight,
      'reps': reps,
      'sets': sets,
    };
  }

  factory ExerciseModel.fromMap(Map<String, dynamic> map) {
    return ExerciseModel(
      name: map['name'] as String,
      description: map['description'] as String,
      weight: map['weight'] as double,
      reps: map['reps'] as int,
      sets: map['sets'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory ExerciseModel.fromJson(String source) => ExerciseModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ExerciseModel(name: $name, description: $description, weight: $weight, reps: $reps, sets: $sets)';
  }

  @override
  bool operator ==(covariant ExerciseModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.name == name &&
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
