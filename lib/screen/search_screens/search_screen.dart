import 'package:fitness_social_app/screen/search_screens/search_meals.dart';
import 'package:fitness_social_app/screen/search_screens/user_search.dart';
import 'package:fitness_social_app/screen/search_screens/workout_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchScreen extends ConsumerWidget {
  const SearchScreen(
      {Key? key, required this.searchType, required this.currentDay})
      : super(key: key);
  final String searchType;
  final int currentDay;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(searchType),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: SafeArea(
        child: Builder(
          builder: (context) {
            if (searchType == "Users") {
              return const UserSearch();
            } else if (searchType == "Workouts") {
              return const WorkoutSearch();
            } else if (searchType == "Add To Routine") {
              return WorkoutSearch(
                selection: true,
                day: currentDay,
              );
            } else if (searchType == "Add To Meal Plan") {
              return SearchMeals(
                selection: true,
                day: currentDay,
              );
            } else {
              return const SearchMeals();
            }
          },
        ),
      ),
    );
  }
}
