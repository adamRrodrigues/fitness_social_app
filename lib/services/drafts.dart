import 'dart:io';
import 'dart:typed_data';


class WorkoutDraft {
  Uint8List? image;
  String workoutName = '';
  List<LocalExerciseModel> exercises = [];
  List<dynamic> fetchedExercises = [];
  List<String> categories = [];
}

class MealDraft {
  Uint8List? image;
  String mealName = "";
  List<String> categories = [];
  List<dynamic> ingredients = [];
  List<String> steps = [];
  String description = "";
}

class LocalExerciseModel {
  final String name;
  final String description;
  final String toolName;
  File? video;
  final double weight;
  final int reps;
  final int sets;
  final int time;
  final String type;

  LocalExerciseModel({
    required this.description,
    required this.toolName,
    required this.weight,
    required this.reps,
    required this.sets,
    required this.time,
    required this.type,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'description': description,
      'video': "",
      'toolName': "",
      'weight': weight,
      'reps': reps,
      'sets': sets,
      'time': time,
      'type': type
    };
  }
}
