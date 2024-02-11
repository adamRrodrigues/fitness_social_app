import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_social_app/main.dart';
import 'package:fitness_social_app/models/routine_model.dart';
import 'package:fitness_social_app/routing/route_constants.dart';
import 'package:fitness_social_app/widgets/custom_button.dart';
import 'package:fitness_social_app/widgets/custom_calender.dart';
import 'package:fitness_social_app/widgets/workout_widgets/online_routine_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ViewRoutine extends ConsumerStatefulWidget {
  const ViewRoutine({Key? key, required this.uid, required this.currentDay})
      : super(key: key);
  final String uid;
  final int currentDay;
  @override
  _ViewRoutineState createState() => _ViewRoutineState();
}

class _ViewRoutineState extends ConsumerState<ViewRoutine>
    with AutomaticKeepAliveClientMixin {
  DateTime now = DateTime.now();
  int currentDay = 0;
  List<DateTime> dates = [];

  Routine routine = Routine();

  @override
  void initState() {
    super.initState();
    currentDay = widget.currentDay;
    DateTime firstDayOfWeek = now.subtract(Duration(days: currentDay));
    routine = ref.read(routineProvider);
    for (int i = 0; i < 7; i++) {
      final day = firstDayOfWeek.add(Duration(days: i));
      dates.add(day);
    }
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    super.build(context);
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text('My Routine'),
        ),
        body: Column(
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
            OnlineRoutineWidget(uid: widget.uid, currentDay: currentDay)
          ],
        ),
        bottomNavigationBar: BottomAppBar(
            height: 60,
            padding: const EdgeInsets.all(8),
            color: Colors.transparent,
            elevation: 0,
            child: user!.uid == widget.uid
                ? GestureDetector(
                    onTap: () {
                      context.pushNamed(RouteConstants.searchWorkoutScreen,
                          extra: currentDay);
                    },
                    child: const CustomButton(buttonText: 'Add Workout'))
                : GestureDetector(
                    onTap: () {
                      // context.pushNamed(RouteConstants.searchWorkoutScreen,
                      //     extra: currentDay);
                    },
                    child: const CustomButton(buttonText: 'Save Routine'))));
  }

  @override
  bool get wantKeepAlive => true;
}
