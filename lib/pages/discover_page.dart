import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_social_app/main.dart';
import 'package:fitness_social_app/routing/route_constants.dart';
import 'package:fitness_social_app/services/meal_service.dart';
import 'package:fitness_social_app/services/post_service.dart';
import 'package:fitness_social_app/services/user_services.dart';
import 'package:fitness_social_app/widgets/meal_widgets/meal_widget.dart';
import 'package:fitness_social_app/widgets/mini_profie.dart';
import 'package:fitness_social_app/widgets/workout_widgets/workout_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
          body: RefreshIndicator(
            onRefresh: () async {
              setState(() {});
            },
            child: StreamBuilder(
                stream:
                    users.doc(user!.uid).collection('following').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData &&
                      snapshot.connectionState == ConnectionState.active) {
                    final docs = snapshot.data!.docs.toList();
                    List<String> ids = [user!.uid];
                    for (var i = 0; i < docs.length; i++) {
                      ids.add(docs[i].id);
                    }
                    return ListView(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      physics: const BouncingScrollPhysics(),
                      children: [
                        section(context, "Users"),
                        StreamBuilder(
                          stream:
                              users.where("uid", whereNotIn: ids).snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.active) {
                              final data = snapshot.data!.docs.toList();

                              return SizedBox(
                                height: 120,
                                child: ListView.builder(
                                  itemCount: data.length,
                                  shrinkWrap: true,
                                  physics: const BouncingScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    final thisUser =
                                        UserServices().mapDocUser(data[index]);
                                    return MiniProfileWidget(thisUser: thisUser)
                                        .animate()
                                        .shimmer();
                                  },
                                ),
                              );
                            } else {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                          },
                        ),
                        section(context, "Workouts"),
                        SizedBox(
                          height: 400,
                          child: StreamBuilder(
                            stream: wokrouts
                                .where('uid', isNotEqualTo: user!.uid)
                                .orderBy('uid')
                                .orderBy('createdAt', descending: true)
                                .limit(5)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData &&
                                  snapshot.connectionState ==
                                      ConnectionState.active) {
                                final data = snapshot.data!.docs.toList();

                                return Builder(builder: (context) {
                                  if (data.isNotEmpty) {
                                    return ListView.builder(
                                      itemCount: data.length,
                                      shrinkWrap: true,
                                      physics: const BouncingScrollPhysics(),
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        final thisWorkout = workoutPostServices
                                            .mapDocPost(data[index]);
                                        try {
                                          return SizedBox(
                                              // height: 330,
                                              width: 370,
                                              child: WorkoutWidget(
                                                workoutModel: thisWorkout,
                                                mini: false,
                                              ));
                                        } catch (e) {
                                          return Container();
                                        }
                                      },
                                    );
                                  } else {
                                    return Center(
                                      child: Text("No Workouts to display"),
                                    );
                                  }
                                });
                              } else {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                            },
                          ),
                        ),
                        section(context, "Meals"),
                        SizedBox(
                            // width: 400,
                            height: 450,
                            child: StreamBuilder(
                              stream: meals
                                  .where('uid', isNotEqualTo: user!.uid)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData &&
                                    snapshot.connectionState ==
                                        ConnectionState.active) {
                                  final data = snapshot.data!.docs.toList();
                                  if (data.isNotEmpty) {
                                    return ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: data.length,
                                      itemBuilder: (context, index) {
                                        final meal = MealServices()
                                            .getMealFromDoc(data[index]);
                                        return MealWidget(meal: meal);
                                      },
                                    );
                                  } else {
                                    return Center(
                                      child: Text(
                                          "No Meals"),
                                    );
                                  }
                                } else {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                              },
                            )),
                      ],
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }),
          )),
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
                pathParameters: {'searchType': sectionName});
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
