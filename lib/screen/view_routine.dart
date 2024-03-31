import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_social_app/main.dart';
import 'package:fitness_social_app/models/routine_model.dart';
import 'package:fitness_social_app/routing/route_constants.dart';
import 'package:fitness_social_app/screen/view_meal_plan.dart';
import 'package:fitness_social_app/services/routine_services.dart';
import 'package:fitness_social_app/widgets/bottom_modal_item_widget.dart';
import 'package:fitness_social_app/widgets/custom_button.dart';
import 'package:fitness_social_app/widgets/custom_calender.dart';
import 'package:fitness_social_app/widgets/workout_widgets/online_routine_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ViewRoutine extends ConsumerStatefulWidget {
  const ViewRoutine({
    Key? key,
    required this.uid,
    required this.currentDay,
  }) : super(key: key);
  final String uid;
  final int currentDay;
  @override
  _ViewRoutineState createState() => _ViewRoutineState();
}

class _ViewRoutineState extends ConsumerState<ViewRoutine>
    with SingleTickerProviderStateMixin {
  DateTime now = DateTime.now();
  DateTime today = DateTime.now();
  int currentDay = 0;
  List<DateTime> dates = [];

  Routine routine = Routine();
  late TabController tabController;

  @override
  void initState() {
    super.initState();
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

    routine = ref.read(routineProvider);
    tabController = TabController(length: 2, vsync: this, initialIndex: 0);
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text('My Routine'),
        ),
        body: ListView(
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
            TabBar(
                onTap: (value) {
                  setState(() {});
                },
                controller: tabController,
                tabs: const [
                  Tab(
                    icon: Icon(Icons.fitness_center_rounded),
                  ),
                  Tab(
                    icon: Icon(Icons.food_bank),
                  ),
                ]),
            SizedBox(
              height: 600,
              child: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: tabController,
                  children: [
                    OnlineRoutineWidget(
                        uid: widget.uid, currentDay: currentDay),
                    MealPlan(user: user, currentDay: currentDay),
                  ]),
            )
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          height: 60,
          padding: const EdgeInsets.all(8),
          color: Colors.transparent,
          elevation: 0,
          child: user!.uid == widget.uid
              ? Builder(builder: (context) {
                  if (tabController.index == 0) {
                    return GestureDetector(
                        onTap: () {
                          context.pushNamed(RouteConstants.searchWorkoutScreen,
                              extra: currentDay);
                        },
                        child: const CustomButton(buttonText: 'Add Workout'));
                  } else {
                    return GestureDetector(
                        onTap: () {
                          context.pushNamed(RouteConstants.searchMealsScreen,
                              extra: currentDay);
                        },
                        child: const CustomButton(buttonText: 'Add Meal'));
                  }
                })
              : Builder(builder: (context) {
                  if (tabController.index == 0) {
                    return GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            showDragHandle: true,
                            useSafeArea: true,
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20))),
                            builder: (context) {
                              return Container(
                                padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom),
                                height: 550,
                                child: Column(
                                  children: [
                                    Text("Save Routine"),
                                    ListView.builder(
                                      physics: BouncingScrollPhysics(),
                                      itemCount: 7,
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () async {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                );
                                              },
                                            );
                                            await RoutineServices().saveRoutine(
                                                user.uid,
                                                widget.uid,
                                                currentDay,
                                                index);
                                            if (context.mounted) {
                                              context.pop();
                                              context.pop();
                                            }
                                          },
                                          child: BottomModalItem(
                                              text: "Day ${index + 1}"),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        child: const CustomButton(buttonText: 'Save Routine'));
                  } else {
                    return GestureDetector(
                        onTap: () async {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            showDragHandle: true,
                            useSafeArea: true,
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20))),
                            builder: (context) {
                              return Container(
                                padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom),
                                height: 550,
                                child: Column(
                                  children: [
                                    Text("Save To Meal Plan"),
                                    ListView.builder(
                                      physics: BouncingScrollPhysics(),
                                      itemCount: 7,
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () async {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                );
                                              },
                                            );
                                            await RoutineServices()
                                                .saveMealPlan(
                                                    user.uid,
                                                    widget.uid,
                                                    currentDay,
                                                    index);
                                            if (context.mounted) {
                                              context.pop();
                                              context.pop();
                                            }
                                          },
                                          child: BottomModalItem(
                                              text: "Day ${index + 1}"),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        child:
                            const CustomButton(buttonText: 'Save Meal Plan'));
                  }
                }),
        ));
  }
}
