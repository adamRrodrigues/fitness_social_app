import 'package:fitness_social_app/main.dart';
import 'package:fitness_social_app/models/routine_model.dart';
import 'package:fitness_social_app/routing/route_constants.dart';
import 'package:fitness_social_app/widgets/custom_button.dart';
import 'package:fitness_social_app/widgets/custom_calender.dart';
import 'package:fitness_social_app/widgets/workout_widgets/workout_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ViewRoutine extends ConsumerStatefulWidget {
  const ViewRoutine({Key? key}) : super(key: key);

  @override
  _ViewRoutineState createState() => _ViewRoutineState();
}

class _ViewRoutineState extends ConsumerState<ViewRoutine> {
  DateTime now = DateTime.now();
  int currentDay = 2;
  List<DateTime> dates = [];
  List<String> days = ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', "SAT"];

  Routine routine = Routine();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentDay = now.weekday;
    print(currentDay);
    DateTime firstDayOfWeek = now.subtract(Duration(days: currentDay));
    routine = ref.read(routineProvider);
    for (int i = 0; i < 7; i++) {
      final day = firstDayOfWeek.add(Duration(days: i));
      dates.add(day);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('My Routine'),
      ),
      body: Column(
        children: [
          CustomCalender(
            days: days,
            currentDay: currentDay,
            dates: dates,
            today: now,
            func: (data) {
              setState(() {
                currentDay = data;
              });
            },
          ),
          Text(days[currentDay]),
          routine.routines[currentDay].workouts.isNotEmpty
              ? Expanded(
                  child: ListView.builder(
                    itemCount: routine.routines[currentDay].workouts.length,
                    itemBuilder: (context, index) {
                      return WorkoutWidget(
                          workoutModel:
                              routine.routines[currentDay].workouts[index],
                          postId: 'EsK28pi6RlyIvLw73j6Y');
                    },
                  ),
                )
              : Text('Add some workouts to your routine')
          // Expanded(
          //     child: WorkoutFeed(
          //         uid: FirebaseAuth.instance.currentUser!.uid,
          //         postQuery: FeedServices()
          //             .fetchWorkouts(FirebaseAuth.instance.currentUser!.uid)))
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        height: 60,
        padding: EdgeInsets.all(8),
        color: Colors.transparent,
        elevation: 0,
        child: GestureDetector(
            onTap: () {
              context.pushNamed(RouteConstants.searchWorkoutScreen,
                  extra: currentDay);
            },
            child: CustomButton(buttonText: 'Add A Workout')),
      ),
    );
  }
}
