class TimeBasedExercises {
  final String name;
  final String description;
  final double duration;

  TimeBasedExercises(
      {required this.name, required this.description, required this.duration});
}

class SetBasedExercises {
  final String name;
  final String description;
  final double weight;
  final int sets;
  final int reps;

  SetBasedExercises(
      {required this.name,
      required this.description,
      required this.weight,
      required this.sets,
      required this.reps});
}

List defaultExercises = [
  TimeBasedExercises(name: "Skipping", description: "Skipping", duration: 200),
  SetBasedExercises(
      name: "Bench Press",
      description: "Bench Press",
      weight: 20,
      sets: 3,
      reps: 8)
];
