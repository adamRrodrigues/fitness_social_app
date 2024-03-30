import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_social_app/main.dart';
import 'package:fitness_social_app/routing/route_constants.dart';
import 'package:fitness_social_app/services/feed_services.dart';
import 'package:fitness_social_app/services/meal_service.dart';
import 'package:fitness_social_app/services/post_service.dart';
import 'package:fitness_social_app/widgets/discover_sections/discover_page_meals.dart';
import 'package:fitness_social_app/widgets/discover_sections/discover_page_workouts.dart';
import 'package:fitness_social_app/widgets/discover_sections/discover_page_users.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class DiscoverPage extends ConsumerStatefulWidget {
  const DiscoverPage({Key? key}) : super(key: key);

  @override
  _DiscoverPageState createState() => _DiscoverPageState();
}

class _DiscoverPageState extends ConsumerState<DiscoverPage>
    with AutomaticKeepAliveClientMixin {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference wokrouts =
      FirebaseFirestore.instance.collection('workout_templates_demo');
  CollectionReference meals =
      FirebaseFirestore.instance.collection('meals_demo');
  User? user;
  WorkoutPostServices workoutPostServices = WorkoutPostServices();
  MealServices mealServices = MealServices();
  FeedServices? feedServices;

  @override
  void initState() {
    super.initState();
    user = ref.read(userProvider);
    feedServices = ref.read(feedServicesProvider);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              "Discover",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            backgroundColor: Theme.of(context).colorScheme.background,
            elevation: 0,
          ),
          body: RefreshIndicator(
              onRefresh: () async {
                setState(() {});
              },
              child: ListView(
                shrinkWrap: true,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: section(context, "Users"),
                  ),
                  DiscoverPageUsers(user: user),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: section(context, "Workouts"),
                  ),
                  DiscoverPageWorkouts(user: user),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: section(context, "Meals"),
                  ),
                  DiscoverPageMeals(user: user),
                ],
              ))),
    );
  }

  Row section(BuildContext context, String sectionName) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            sectionName,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        GestureDetector(
          onTap: () {
            context.pushNamed(RouteConstants.searchScreen,
                pathParameters: {'searchType': sectionName}, extra: 0);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "See More...",
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
