import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_social_app/main.dart';
import 'package:fitness_social_app/models/user_stats.dart';
import 'package:fitness_social_app/services/fallback_services.dart';
import 'package:fitness_social_app/widgets/custom_calender.dart';
import 'package:fitness_social_app/widgets/progress_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserStatsScreen extends ConsumerStatefulWidget {
  const UserStatsScreen({Key? key, required this.uid}) : super(key: key);
  final String uid;

  @override
  _UserStatsScreenState createState() => _UserStatsScreenState();
}

CollectionReference userStats =
    FirebaseFirestore.instance.collection('user_stats');

TextEditingController weightController = TextEditingController();
TextEditingController heightController = TextEditingController();

List<String> heights = ['cm', 'ft'];
String currentHeightMeasure = 'cm';

List<String> weights = ['kg', 'lbs'];
String currentWeightMeasure = 'kg';

double bmi = 0.0;

double claclBMI(double w, double h) {
  // fixes the NAN in the BMI
  if (w <= 0 && h <= 0) {
    return 0.0;
  }
  final result = w / ((h / 100) * (h / 100));
  return result;
}

class _UserStatsScreenState extends ConsumerState<UserStatsScreen> {
  DateTime now = DateTime.now();
  int currentDay = FallbackService().getDay();
  DateTime today = DateTime.now();
  List<DateTime> dates = [];
  var tracker = 3;
  List<int> stepList = [];
  ValueNotifier<int> steps = ValueNotifier(0);

  void setStepsFromStepList(int index) {
    steps.value = stepList[index];
  }

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

    for (int i = 0; i < 7; i++) {
      final day = firstDayOfWeek.add(Duration(days: i));
      dates.add(day);
    }
  }

  @override
  Widget build(BuildContext context) {
    User? user = ref.read(userProvider);

    // print(user);

    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
            // physics: BouncingScrollPhysics(),
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
                  SliverAppBar(
                    title: Text(
                        user.uid == widget.uid ? "My Stats" : "username Stats"),
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  )
                ],
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: StreamBuilder(
                  stream: userStats.doc(user!.uid).snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData &&
                        snapshot.connectionState == ConnectionState.active) {
                      final data = snapshot.data!;

                      final thisUserStat = UserStats(
                          uid: widget.uid,
                          userWeight: data['userWeight'],
                          stepsGoal: data["stepsGoal"],
                          userHeight: data['userHeight'],
                          steps: List<int>.from(data['steps']),
                          workoutStreak: data['workoutStreak'],
                          achievements: List.from(data['achievements']));

                      weightController.text =
                          thisUserStat.userWeight.toString();
                      heightController.text =
                          thisUserStat.userHeight.toString();

                      stepList = thisUserStat.steps;

                      bmi = claclBMI(
                          thisUserStat.userWeight, thisUserStat.userHeight);
                      return Column(
                        children: [
                          Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text("Weight"),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextField(
                                        onSubmitted: (value) async {
                                          if (value != "") {
                                            await userStats
                                                .doc(user.uid)
                                                .update({
                                              'userWeight': double.parse(value),
                                            });
                                            setState(() {
                                              bmi = claclBMI(
                                                  double.parse(value),
                                                  thisUserStat.userHeight);
                                            });
                                          }
                                        },
                                        keyboardType: TextInputType.number,
                                        controller: weightController,
                                        decoration: const InputDecoration(
                                            border: OutlineInputBorder()),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 60,
                                    child: DropdownButton<String>(
                                      hint: Text(currentWeightMeasure),
                                      items: weights.map((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          currentWeightMeasure = value!;
                                        });
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text("Height"),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextField(
                                        onSubmitted: (value) async {
                                          if (value != "") {
                                            await userStats
                                                .doc(user.uid)
                                                .update({
                                              'userHeight': double.parse(value),
                                            });
                                            setState(() {
                                              bmi = claclBMI(
                                                  thisUserStat.userWeight,
                                                  double.parse(value));
                                            });
                                          }
                                        },
                                        keyboardType: TextInputType.number,
                                        controller: heightController,
                                        decoration: const InputDecoration(
                                            border: OutlineInputBorder()),
                                      ),
                                    ),
                                  ),
                                  // box for workout streak and steps
                                  SizedBox(
                                    width: 60,
                                    child: DropdownButton<String>(
                                      hint: Text(currentHeightMeasure),
                                      items: heights.map((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          currentHeightMeasure = value!;
                                        });
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("BMI: ${bmi.toStringAsFixed(2)}"),
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
                                            color: Theme.of(context)
                                                .colorScheme
                                                .surface,
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: ValueListenableBuilder(
                                          valueListenable: steps,
                                          builder: (context, int value, child) {
                                            return Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "Steps",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleLarge,
                                                ),
                                                const SizedBox(
                                                  height: 30,
                                                ),
                                                ProgressWidget(
                                                    // value: thisUserStat
                                                    //     .steps[currentDay]
                                                    //     .toDouble(),
                                                    value:
                                                        steps.value.toDouble(),
                                                    color: const Color(
                                                        0xffFF8080)),
                                              ],
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Material(
                                      elevation: 2,
                                      borderRadius: BorderRadius.circular(20),
                                      child: Container(
                                        height: 300,
                                        decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .surface,
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                                                value: thisUserStat
                                                    .workoutStreak
                                                    .toDouble(),
                                                maxValue: 7,
                                                color: const Color(0xffFF8080)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          CustomCalender(
                            currentDay: currentDay,
                            dates: dates,
                            today: today,
                            func: (data) {
                              currentDay = data;

                              steps.value = stepList[data];
                            },
                          ),

                          ValueListenableBuilder(
                            valueListenable: steps,
                            builder: (context, int value, child) {
                              var caloriesBurned =
                                  calculateCaloriesBurned(value);

                              return Container(
                                margin: const EdgeInsets.all(15),
                                padding: const EdgeInsets.all(16.0),
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 32, 33, 33),
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Calories Burned',
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          WidgetSpan(
                                              alignment:
                                                  PlaceholderAlignment.middle,
                                              child: Container(
                                                // color: Colors.red,
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  "$caloriesBurned",
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              )),
                                          WidgetSpan(
                                            alignment:
                                                PlaceholderAlignment.middle,
                                            child: Icon(
                                              Icons.local_fire_department,
                                              color: Colors.orange,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),

                          // oki
                        ],
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }),
            )),
      ),
    );
  }
}

double calculateCaloriesBurned(int steps) {
  // Average person burns 0.04 kcal per step (source: https://www.verywellfit.com/how-many-calories-do-you-burn-walking-3120363)
  final double caloriesPerStep = 0.04;
  return steps * caloriesPerStep;
}


// this is the column for the steps ( without the value listener builder)
//     //hah
//     Column(
//   mainAxisAlignment:
//       MainAxisAlignment.center,
//   children: [
//     Text(
//       "Steps",
//       style: Theme.of(context)
//           .textTheme
//           .titleLarge,
//     ),
//     const SizedBox(
//       height: 30,
//     ),
//     ProgressWidget(
//         // value: thisUserStat
//         //     .steps[currentDay]
//         //     .toDouble(),
//         value: steps.value.toDouble(),
//         color: const Color(0xffFF8080)),
//   ],
// ),
// // hah
