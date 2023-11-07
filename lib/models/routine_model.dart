import 'package:fitness_social_app/models/workout_post_model.dart';

class RoutineModel {
  final int day;
  final List<WorkoutModel> workouts;

  RoutineModel({required this.day, required this.workouts});
}

class Routine {
  List<RoutineModel> routines = [
    RoutineModel(day: 0, workouts: []),
    RoutineModel(day: 1, workouts: []),
    RoutineModel(day: 2, workouts: []),
    RoutineModel(day: 3, workouts: []),
    RoutineModel(day: 4, workouts: []),
    RoutineModel(day: 5, workouts: []),
    RoutineModel(day: 6, workouts: []),
  ];

  void addToRoutine(int day, WorkoutModel workout){
    routines[day].workouts.add(workout);
  }
}
