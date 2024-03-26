import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_social_app/main.dart';
import 'package:fitness_social_app/screen/search_screens/search_meals.dart';
import 'package:fitness_social_app/screen/search_screens/user_search.dart';
import 'package:fitness_social_app/screen/search_screens/workout_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchScreen extends ConsumerWidget {
  const SearchScreen({Key? key, required this.searchType}) : super(key: key);
  final String searchType;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    User? user = ref.read(userProvider);
    return Scaffold(
      body: NestedScrollView(
        // physics: NeverScrollableScrollPhysics(),
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            title: Text(searchType),
            elevation: 0,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            floating: true,
            snap: true,
          )
        ],
        body: SafeArea(
          child: Builder(
            builder: (context) {
              if (searchType == "Users") {
                return UserSearch();
              } else if (searchType == "Workouts") {
                return WorkoutSearch();
              } else {
                return SearchMeals();
              }
            },
          ),
        ),
      ),
    );
  }
}
