import 'package:flutter/material.dart';

class CustomCalender extends StatefulWidget {
  const CustomCalender({
    super.key,
    required this.currentDay,
    required this.dates,
    required this.today,
    required this.func(int data),
  });

  final int currentDay;
  final List<DateTime> dates;
  final DateTime today;
  final Function func;

  @override
  State<CustomCalender> createState() => _CustomeCalenderState();
}

class _CustomeCalenderState extends State<CustomCalender> {
  DateTime changeAbleToday = DateTime.now();

  List<String> days = ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', "SAT"];
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        borderRadius: BorderRadius.circular(10),
        elevation: 4,
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          child: SizedBox(
              height: 90,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).colorScheme.surface,
                ),
                width: double.infinity,
                child: Center(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: days.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            changeAbleToday = widget.dates[index];
                            widget.func(index);
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                days[index],
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              Text(
                                widget.dates[index].day.toString(),
                                style: changeAbleToday.day ==
                                        widget.dates[index].day
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
                        ),
                      );
                    },
                  ),
                ),
              )),
        ),
      ),
    );
  }
}
