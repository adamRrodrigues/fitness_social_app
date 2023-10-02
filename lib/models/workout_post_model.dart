import 'package:fitness_social_app/models/exercise_model.dart';

class WorkoutModel {
  final String workoutName;
  final List<String> categories;
  final List<ExerciseModel> exercises;
  final String uid;
  final String postId;
  final String privacy;
  WorkoutModel({
    required this.workoutName,
    required this.categories,
    required this.exercises,
    required this.uid,
    required this.postId,
    required this.privacy,
  }
  );

  WorkoutModel copyWith({
    String? workoutName,
    List<String>? categories,
    List<ExerciseModel>? exercises,
    String? uid,
    String? postId,
    String? privacy,
  }) {
    return WorkoutModel(
      workoutName: workoutName ?? this.workoutName,
      categories: categories ?? this.categories,
      exercises: exercises ?? this.exercises,
      uid: uid ?? this.uid,
      postId: postId ?? this.postId,
      privacy: privacy ?? this.privacy,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'workoutName': workoutName,
      'categories': categories,
      'exercises': exercises,
      'uid': uid,
      'postId': postId,
      'privacy': privacy,
    };
  }
}
