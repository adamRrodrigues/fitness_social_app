import 'package:fitness_social_app/widgets/custom_calender.dart';
import 'package:flutter/material.dart';

class ViewMealPlanScreen extends StatefulWidget {
  const ViewMealPlanScreen({Key? key, required this.currentDay, required this.uid})
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Meal Plan"),
      ),
      body: SafeArea(
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
          )
        ],
      )),
    );
  }
}
