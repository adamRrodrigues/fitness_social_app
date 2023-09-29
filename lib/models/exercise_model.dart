class ExerciseModel {
  final String name;
  final String description;
  final String toolName = '';
  final double weight;
  final String imageUrl = '';
  final int reps = 0;
  final int time = 0;
  final int sets;

  ExerciseModel(
      {required this.name,
      required this.description,
      required this.weight,
      required this.sets});
}
