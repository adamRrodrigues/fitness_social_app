import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_social_app/feed/meal_feed.dart';
import 'package:fitness_social_app/main.dart';
import 'package:fitness_social_app/models/meal_model.dart';
import 'package:fitness_social_app/screen/run_workou.dart';
import 'package:fitness_social_app/screen/search_screens/search_meals.dart';
import 'package:fitness_social_app/services/feed_services.dart';
import 'package:fitness_social_app/services/post_service.dart';
import 'package:fitness_social_app/services/routine_services.dart';
import 'package:fitness_social_app/widgets/meal_widgets/meal_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchMealsMain extends ConsumerStatefulWidget {
  const SearchMealsMain({Key? key, required this.currentDay}) : super(key: key);
  final int currentDay;

  @override
  _SearchMealsMainState createState() => _SearchMealsMainState();
}

class _SearchMealsMainState extends ConsumerState<SearchMealsMain> {
  User? user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = ref.read(userProvider);
  }

  @override
  Widget build(BuildContext context) {
    User user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text(
            'Search Meal',
            style: Theme.of(context).textTheme.titleLarge,
          )),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            TabBar(
              indicatorColor: Theme.of(context).colorScheme.primary,
              tabs: [
                Tab(
                    icon: Icon(
                  Icons.person_rounded,
                  color: Theme.of(context).colorScheme.secondary,
                )),
                Tab(
                    icon: Icon(
                  Icons.bookmark_rounded,
                  color: Theme.of(context).colorScheme.secondary,
                )),
                Tab(
                    icon: Icon(
                  Icons.food_bank_outlined,
                  color: Theme.of(context).colorScheme.secondary,
                )),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  MealFeed(
                    add: true,
                    currentDay: widget.currentDay,
                    postQuery: FeedServices().fetchMeals(user!.uid),
                  ),
                  mealsSaved(),
                  SearchMeals(
                    day: widget.currentDay,
                    selection: true,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  FutureBuilder<DocumentSnapshot<Map<String, dynamic>>> mealsSaved() {
    return FutureBuilder(
        future:
            FirebaseFirestore.instance.collection("saved").doc(user!.uid).get(),
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done) {
            List<dynamic> items = snapshot.data!.get('meals');
            if (items.isNotEmpty) {
              return ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('meals_demo')
                        .doc(items[index])
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData &&
                          snapshot.connectionState == ConnectionState.done) {
                        try {
                          Map<String, dynamic> thisMeal =
                              snapshot.data!.data() as Map<String, dynamic>;

                          final MealModel mappedMeal =
                              RoutineServices().mapSingleRoutineMeal(thisMeal);

                          return MealWidget(meal: mappedMeal);
                        } catch (e) {
                          WorkoutPostServices()
                              .removeFromSavedWorkouts(items[index], user!.uid);
                          return Container();
                        }
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    },
                  );
                },
              );
            } else {
              return Center(
                child: Text("No Meals Saved"),
              );
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
