import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_social_app/models/meal_model.dart';
import 'package:fitness_social_app/routing/route_constants.dart';
import 'package:fitness_social_app/services/routine_services.dart';
import 'package:fitness_social_app/widgets/custom_button.dart';
import 'package:fitness_social_app/widgets/custom_calender.dart';
import 'package:fitness_social_app/widgets/meal_widgets/meal_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';

class ViewMealPlanScreen extends StatefulWidget {
  const ViewMealPlanScreen(
      {Key? key, required this.currentDay, required this.uid})
      : super(key: key);

  final int currentDay;
  final String uid;
  @override
  State<ViewMealPlanScreen> createState() => VviewMealPlanScreenState();
}

class VviewMealPlanScreenState extends State<ViewMealPlanScreen> {
  DateTime now = DateTime.now();
  int currentDay = 0;
  List<DateTime> dates = [];

  @override
  void initState() {
    super.initState();
    currentDay = widget.currentDay;
    DateTime firstDayOfWeek = now.subtract(Duration(days: currentDay));
    for (int i = 0; i < 7; i++) {
      final day = firstDayOfWeek.add(Duration(days: i));
      dates.add(day);
    }
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Meal Plan"),
        elevation: 0,
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            CustomCalender(
              currentDay: currentDay,
              dates: dates,
              today: now,
              func: (data) {
                setState(() {
                  currentDay = data;
                });
              },
            ),
            MealPlan(user: user, currentDay: currentDay)
          ],
        ),
      )),
    );
  }
}

class MealPlan extends StatelessWidget {
  const MealPlan({
    super.key,
    required this.user,
    required this.currentDay,
  });

  final User? user;
  final int currentDay;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('routines')
          .doc(user!.uid)
          .collection('day $currentDay')
          .doc('meals')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active &&
            snapshot.hasData) {
          List<String> meals = [];
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;

          if (data['meals'].isNotEmpty) {
            for (int i = 0; i < data['meals'].length; i++) {
              meals.add(data['meals'][i]);
            }
            if (meals.isNotEmpty) {
              return ListView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: meals.length,
                itemBuilder: (context, index) {
                  return Slidable(
                    closeOnScroll: true,
                    startActionPane:
                        ActionPane(motion: const ScrollMotion(), children: [
                      SlidableAction(
                        padding: const EdgeInsets.all(8),
                        autoClose: true,
                        borderRadius: BorderRadius.circular(10),
                        flex: 1,
                        onPressed: (context) {
                          // add to calories
                        },
                        backgroundColor: Colors.greenAccent,
                        foregroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        icon: Icons.delete,
                        label: 'Add Calories To Stats',
                      )
                    ]),
                    endActionPane:
                        ActionPane(motion: const ScrollMotion(), children: [
                      SlidableAction(
                        padding: const EdgeInsets.all(8),
                        autoClose: true,
                        borderRadius: BorderRadius.circular(10),
                        flex: 1,
                        onPressed: (context) {
                          RoutineServices()
                              .removeFromMealPlan(meals[index], currentDay);
                        },
                        backgroundColor: Colors.red,
                        foregroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        icon: Icons.delete,
                        label: 'Remove From Meal Plan',
                      )
                    ]),
                    child: FutureBuilder(
                        future: FirebaseFirestore.instance
                            .collection('meals_demo')
                            .doc(meals[index])
                            .get(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData &&
                              snapshot.connectionState ==
                                  ConnectionState.done) {
                            try {
                              Map<String, dynamic> thisMeal =
                                  snapshot.data!.data() as Map<String, dynamic>;

                              final MealModel mappedMeal = RoutineServices()
                                  .mapSingleRoutineMeal(thisMeal);

                              return MealWidget(meal: mappedMeal);
                            } catch (e) {
                              RoutineServices()
                                  .removeFromMealPlan(meals[index], currentDay);
                              return Container();
                            }
                          } else {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                        }),
                  );
                },
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          } else {
            return const Center(
              child: Text("No meals added to this plan yet"),
            );
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
