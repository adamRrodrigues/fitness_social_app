import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_social_app/feed/meal_feed.dart';
import 'package:fitness_social_app/feed/workout_feed.dart';
import 'package:fitness_social_app/main.dart';
import 'package:fitness_social_app/models/user_model.dart';
import 'package:fitness_social_app/routing/route_constants.dart';
import 'package:fitness_social_app/services/feed_services.dart';
import 'package:fitness_social_app/services/user_services.dart';
import 'package:fitness_social_app/widgets/mini_profie.dart';
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
  User? user;

  @override
  void initState() {
    user = ref.read(userProvider);
    super.initState();
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
          body: ListView(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "people",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "See More...",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                ],
              ),
              FutureBuilder(
                future: users.get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return SizedBox(
                      height: 120,
                      child: ListView(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          children: snapshot.data!.docs
                              .where((element) => element.id != user!.uid)
                              .map((e) {
                            UserModel thisUser = UserServices().mapDocUser(e);

                            return InkWell(
                              onTap: () {
                                context.pushNamed(RouteConstants.userPage,
                                    extra: thisUser);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    CircleAvatar(
                                        maxRadius: 40,
                                        backgroundImage:
                                            NetworkImage(thisUser.profileUrl)),
                                    Text(thisUser.username)
                                  ],
                                ),
                              ),
                            );
                          }).toList()),
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Workouts",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "See More...",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                ],
              ),
              SizedBox(
                // width: 200,
                height: 300,
                child: WorkoutFeed(
                    horizontal: true,
                    uid: user!.uid,
                    postQuery: FeedServices().fetchWorkouts()),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Meals",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "See More...",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                ],
              ),
              SizedBox(
                // width: 400,
                height: 450,
                child: MealFeed(
                    horizontal: true, postQuery: FeedServices().fetchMeals()),
              ),
            ],
          )),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
