import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_social_app/main.dart';
import 'package:fitness_social_app/models/routine_model.dart';
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

class _FitnesstrackerPageState extends ConsumerState<FitnesstrackerPage> {
  DateTime now = DateTime.now();
  int currentDay = 0;
  DateTime today = DateTime.now();
  List<DateTime> dates = [];
  Routine routine = Routine();

  @override
  void initState() {
    super.initState();
    currentDay = now.weekday;
    DateTime firstDayOfWeek = now.subtract(Duration(days: currentDay));
    today = now;
    routine = ref.read(routineProvider);

    for (int i = 0; i < 7; i++) {
      final day = firstDayOfWeek.add(Duration(days: i));
      dates.add(day);
    }
  }

  @override
  Widget build(BuildContext context) {
    User user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
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
                              color: Theme.of(context).colorScheme.secondary,
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
                                  type: 'steps',
                                  value: 2000,
                                  color: Color(0xffCDFAD5)),
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
                              color: Theme.of(context).colorScheme.secondary,
                              borderRadius: BorderRadius.circular(20)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Calories",
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              const ProgressWidget(
                                  type: 'kcal',
                                  value: 1300,
                                  maxValue: 1500,
                                  color: Color(0xffFF8080)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                context.pushNamed(RouteConstants.viewRoutinePage,
                    pathParameters: {'id': user.uid});
              },
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: CustomButton(buttonText: 'My Routine'),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Today's Routine",
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: Colors.grey[400]),
            ),
            OnlineRoutineWidget(uid: user.uid, currentDay: currentDay)
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 60,
        padding: const EdgeInsets.all(8),
        color: Colors.transparent,
        elevation: 0,
        child: GestureDetector(
            onTap: () {
              context.pushNamed(RouteConstants.viewRoutinePage,
                  pathParameters: {'id': user.uid});
            },
            child: const CustomButton(buttonText: 'Begin Routine')),
      ),
    );
  }
}
