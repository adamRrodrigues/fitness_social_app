import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FitnesstrackerPage extends StatefulWidget {
  const FitnesstrackerPage({Key? key}) : super(key: key);
  @override
  _FitnesstrackerPageState createState() => _FitnesstrackerPageState();
}

class _FitnesstrackerPageState extends State<FitnesstrackerPage> {
  DateTime now = DateTime.now();
  int currentDay = 3;
  DateTime today = DateTime.now();
  List<DateTime> dates = [];
  List<String> days = ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', "SAT"];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentDay = now.weekday;
    DateTime firstDayOfWeek = now.subtract(Duration(days: currentDay));
    today = now;

    for (int i = 0; i < 7; i++) {
      final day = firstDayOfWeek.add(Duration(days: i));
      dates.add(day);
    }
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
                height: 90,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  width: double.infinity,
                  child: Center(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: days.length,
                      itemBuilder: (context, index) {
                        print(currentDay);
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                days[index],
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              Text(
                                dates[index].day.toString(),
                                style: dates[index].day == today.day
                                    ? Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            fontSize: 36)
                                    : Theme.of(context).textTheme.titleLarge,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                )),
          )
        ],
      ),
    );
  }
}
