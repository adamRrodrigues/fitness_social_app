import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_social_app/main.dart';
import 'package:fitness_social_app/models/user_stats.dart';
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
  final result = w / ((h / 100) * (h / 100));
  return result;
}

class _UserStatsScreenState extends ConsumerState<UserStatsScreen> {
  @override
  @override
  Widget build(BuildContext context) {
    User? user = ref.read(userProvider);
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
                          userHeight: data['userHeight'],
                          steps: data['steps'],
                          workoutStreak: data['workoutStreak'],
                          achievements: List.from(data['achievements']));

                      weightController.text =
                          thisUserStat.userWeight.toString();
                      heightController.text =
                          thisUserStat.userHeight.toString();

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
                                        child: Column(
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
                                                value: thisUserStat.steps
                                                    .toDouble(),
                                                color: const Color(0xffFF8080)),
                                          ],
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
                                                  color:
                                                      const Color(0xffFF8080)),
                                            ],
                                          ),
                                        ),
                                      )),
                                ],
                              ),
                            ),
                          ),
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
