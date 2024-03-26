import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_social_app/main.dart';
import 'package:fitness_social_app/models/routine_model.dart';
import 'package:fitness_social_app/models/workout_post_model.dart';
import 'package:fitness_social_app/routing/route_constants.dart';
import 'package:fitness_social_app/widgets/custom_button.dart';
import 'package:fitness_social_app/widgets/custom_calender.dart';
import 'package:fitness_social_app/widgets/progress_widget.dart';
import 'package:fitness_social_app/widgets/workout_widgets/online_routine_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class FitnesstrackerPage extends ConsumerStatefulWidget {
  const FitnesstrackerPage({Key? key}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _FitnesstrackerPageState createState() => _FitnesstrackerPageState();
}

class _FitnesstrackerPageState extends ConsumerState<FitnesstrackerPage>
    with AutomaticKeepAliveClientMixin {
  DateTime now = DateTime.now();
  int currentDay = 0;
  DateTime today = DateTime.now();
  List<DateTime> dates = [];
  List<WorkoutModel> workouts = [];
  Routine routine = Routine();
  bool routineExists = true;

  final user = FirebaseAuth.instance.currentUser;
  CollectionReference routines =
      FirebaseFirestore.instance.collection('routines');

  @override
  void initState() {
    super.initState();
    // checkRoutineExists();
    currentDay = now.weekday;
    if (currentDay == 7) {
      currentDay = 0;
    }
    print("day $currentDay");
    DateTime firstDayOfWeek = now.subtract(Duration(days: currentDay));
    today = now;
    routine = ref.read(routineProvider);

    for (int i = 0; i < 7; i++) {
      final day = firstDayOfWeek.add(Duration(days: i));
      dates.add(day);
    }
    // setState(() {
    //   routineExists = true;
    // });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    User user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            title: const Text("My Fitness"),
            elevation: 0,
            backgroundColor: Theme.of(context).colorScheme.background,
            floating: true,
            actionsIconTheme: const IconThemeData(size: 28),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: GestureDetector(
                  onTap: () {
                    context.pushNamed(RouteConstants.viewUserSavedWorkouts,
                        pathParameters: {"id": user.uid});
                  },
                  child: const Icon(Icons.bookmark_rounded),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: GestureDetector(
                  onTap: () {
                    context.pushNamed(RouteConstants.viewUserStatsScreen,
                        pathParameters: {'id': user.uid});
                  },
                  child: const Icon(Icons.bar_chart_rounded),
                ),
              )
            ],
          )
        ],
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomCalender(
                currentDay: currentDay,
                dates: dates,
                today: today,
                func: (data) {
                  setState(() {
                    currentDay = data;
                  });
                },
              ),
              SizedBox(
                // color: Colors.white,
                height: 275,
                width: double.infinity,
                child: Center(
                  child: GridView.count(
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    scrollDirection: Axis.vertical,
                    childAspectRatio: (1 / 1.3),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Material(
                          elevation: 2,
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            height: 300,
                            decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surface,
                                borderRadius: BorderRadius.circular(20)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Steps",
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                const ProgressWidget(
                                    value: 2500, color: Color(0xffFF8080)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('user_stats')
                            .doc(user.uid)
                            .snapshots(),
                        builder: (context, snapshot) {
                          int workoutStreak = 0;
                          if (snapshot.hasData &&
                              snapshot.connectionState ==
                                  ConnectionState.active) {
                            workoutStreak = snapshot.data!.get('workoutStreak');
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Material(
                                elevation: 2,
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  height: 300,
                                  decoration: BoxDecoration(
                                      color:
                                          Theme.of(context).colorScheme.surface,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Workout Streak",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge,
                                      ),
                                      const SizedBox(
                                        height: 30,
                                      ),
                                      ProgressWidget(
                                          value: workoutStreak.toDouble(),
                                          maxValue: 7,
                                          color: Colors.greenAccent),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Material(
                                elevation: 2,
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  height: 300,
                                  decoration: BoxDecoration(
                                      color:
                                          Theme.of(context).colorScheme.surface,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Workout Streak",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge,
                                      ),
                                      const SizedBox(
                                        height: 30,
                                      ),
                                      ProgressWidget(
                                          value: workoutStreak.toDouble(),
                                          maxValue: 7,
                                          color: Colors.greenAccent),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        context.pushNamed(RouteConstants.viewRoutinePage,
                            pathParameters: {
                              'id': user.uid
                            },
                            extra: {
                              'currentDay': currentDay,
                              'startRoutine': false
                            });
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CustomButton(
                          buttonText: 'Routine',
                          primary: false,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        context.pushNamed(RouteConstants.viewMealPlanScreen,
                            pathParameters: {'id': user.uid},
                            extra: currentDay);
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CustomButton(
                          buttonText: 'Meals',
                          primary: false,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Center(
                child: Text("Workouts: "),
              ),
              const Divider(),
              Builder(builder: (context) {
                if (routineExists) {
                  return OnlineRoutineWidget(
                    uid: user.uid,
                    currentDay: currentDay,
                  );
                } else {
                  return const Text('Fetching routine');
                }
              })
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 60,
        padding: const EdgeInsets.all(8),
        color: Colors.transparent,
        elevation: 0,
        child: GestureDetector(
            onTap: () {
              context.pushNamed(RouteConstants.runRoutineScreen,
                  extra: currentDay);
            },
            child: const CustomButton(buttonText: 'Begin Routine')),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
