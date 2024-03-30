import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_social_app/feed/meal_feed.dart';
import 'package:fitness_social_app/screen/search_screens/search_meals.dart';
import 'package:fitness_social_app/services/feed_services.dart';
import 'package:flutter/material.dart';

class SearchMealsMain extends StatelessWidget {
  const SearchMealsMain({Key? key, required this.currentDay}) : super(key: key);
  final int currentDay;

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text(
            'Search Meal',
            style: Theme.of(context).textTheme.titleLarge,
          )),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            TabBar(
              indicatorColor: Theme.of(context).colorScheme.primary,
              tabs: [
                Tab(
                    text: "All Meals",
                    icon: Icon(
                      Icons.food_bank_outlined,
                      color: Theme.of(context).colorScheme.secondary,
                    )),
                Tab(
                    text: "My Meals",
                    icon: Icon(
                      Icons.favorite,
                      color: Theme.of(context).colorScheme.secondary,
                    )),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  SearchMeals(
                    day: currentDay,
                    selection: true,
                  ),
                  MealFeed(
                    add: true,
                    currentDay: currentDay,
                    postQuery: FeedServices().fetchMeals(user!.uid),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
