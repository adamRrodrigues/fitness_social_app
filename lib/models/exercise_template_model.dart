// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ExerciseTemplateModel {
  final String name;
  final String description;
  final String toolName = '';
  final String imageUrl = '';
  ExerciseTemplateModel({
    required this.name,
    required this.description,
  });

  

  ExerciseTemplateModel copyWith({
    String? name,
    String? description,
  }) {
    return ExerciseTemplateModel(
      name: name ?? this.name,
      description: description ?? this.description,
    );
  }

  

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'description': description,
    };
  }

  factory ExerciseTemplateModel.fromMap(Map<String, dynamic> map) {
    return ExerciseTemplateModel(
      name: map['name'] as String,
      description: map['description'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ExerciseTemplateModel.fromJson(String source) => ExerciseTemplateModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ExerciseTemplateModel(name: $name, description: $description)';
  }

  @override
  bool operator ==(covariant ExerciseTemplateModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.name == name &&
      other.description == description ;
  }

  @override
  int get hashCode {
    return name.hashCode ^
      description.hashCode ;
  }
}
