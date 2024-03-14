import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_social_app/feed/meal_feed.dart';
import 'package:fitness_social_app/services/feed_services.dart';
import 'package:flutter/material.dart';

class SearchMeals extends StatelessWidget {
  const SearchMeals({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
          elevation: 0,
          title: Text(
            'Search Meals',
            style: Theme.of(context).textTheme.titleLarge,
          )),
      body: Column(
        children: [
          Expanded(
              child: MealFeed(
            postQuery: FeedServices().fetchMeals(),
            profileView: false,
          ))
        ],
      ),
    );
  }
}
