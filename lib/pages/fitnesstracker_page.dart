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
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';

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
  late Stream<StepCount> _stepCountStream;
  double _steps = 0;

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

    // initliazlie the pedometer
    initPedometer();
  }

  void initPedometer() async {
    if (await Permission.activityRecognition.request().isGranted) {
      _stepCountStream = Pedometer.stepCountStream;

      _stepCountStream.listen(onStepCount).onError(onStepCountError);
    } else {
      print("testo");
    }

    if (!mounted) return;
  }

  void onStepCount(StepCount event) {
    setState(() {
      _steps = event.steps.toDouble();
    });
  }

  void onStepCountError(error) {
    print('onStepCountErro : $error');
    setState(() {
      _steps = -66;
    });
  }

  @override
  Widget build(BuildContext context) {
    User user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            title: Text("My Fitness"),
            elevation: 0,
            backgroundColor: Theme.of(context).colorScheme.background,
            floating: true,
            actionsIconTheme: IconThemeData(size: 28),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: GestureDetector(
                  onTap: () {},
                  child: Icon(Icons.bookmark_rounded),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: GestureDetector(
                  onTap: () {
                    context.pushNamed(RouteConstants.viewUserStatsScreen,
                        pathParameters: {'id': user.uid});
                  },
                  child: Icon(Icons.bar_chart_rounded),
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
                                ProgressWidget(
                                    type: 'steps',
                                    value: _steps,
                                    color: Color(0xffFF8080)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      FutureBuilder(
                        future: FirebaseFirestore.instance
                            .collection('user_stats')
                            .doc(user.uid)
                            .get(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData &&
                              snapshot.connectionState ==
                                  ConnectionState.done) {
                            final workoutStreak =
                                snapshot.data!.get('workoutStreak');
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
                                          type: 'days',
                                          value: workoutStreak.toDouble(),
                                          maxValue: 7,
                                          color: Color(0xffFF8080)),
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
                                      const CircularProgressIndicator()
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
                  return Text('Fetching routine');
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
