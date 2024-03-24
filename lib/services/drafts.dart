import 'dart:typed_data';

import 'package:fitness_social_app/models/exercise_model.dart';

class WorkoutDraft {
  Uint8List? image;
  String workoutName = '';
  List<ExerciseModel> exercises = [];
  List<String> categories = [];
}

class MealDraft {
  Uint8List? image;
  String mealName = "";
  List<String> categories = [];
  List<String> ingredients = [];
  String description = "";
}

class Workouts{
  
}
