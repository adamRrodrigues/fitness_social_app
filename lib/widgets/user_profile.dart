import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_social_app/feed/meal_feed.dart';
import 'package:fitness_social_app/feed/workout_feed.dart';
import 'package:fitness_social_app/main.dart';
import 'package:fitness_social_app/models/user_model.dart';
import 'package:fitness_social_app/routing/route_constants.dart';
import 'package:fitness_social_app/services/feed_services.dart';
import 'package:fitness_social_app/services/post_service.dart';
import 'package:fitness_social_app/services/storage_services.dart';
import 'package:fitness_social_app/services/user_services.dart';
import 'package:fitness_social_app/utlis/utils.dart';
import 'package:fitness_social_app/widgets/count_widget.dart';
import 'package:fitness_social_app/widgets/custom_button.dart';
import 'package:fitness_social_app/feed/post_feed_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class UserProfile extends ConsumerStatefulWidget {
  const UserProfile({
    super.key,
    required this.thisUser,
  });

  final UserModel thisUser;

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends ConsumerState<UserProfile> {
  int followers = 0;
  int following = 0;
  User? user;
  UserServices? userServices;
  GenericPostServices? genericPostServices;
  FeedServices? feedServices;

  DateTime now = DateTime.now();
  DateTime today = DateTime.now();
  int currentDay = 0;
  List<DateTime> dates = [];

  Future getFollowage() async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.thisUser.uid)
          .collection('followers')
          .count()
          .get()
          .then(
            (value) => followers = value.count - 1,
          );
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.thisUser.uid)
          .collection('following')
          .count()
          .get()
          .then(
            (value) => following = value.count - 1,
          );
    } catch (e) {}
  }

  CollectionReference posts =
      FirebaseFirestore.instance.collection('generic_posts');

  @override
  void initState() {
    super.initState();
    user = ref.read(userProvider);
    userServices = ref.read(userServicesProvider);
    genericPostServices = ref.read(genericPostServicesProvider);
    feedServices = ref.read(feedServicesProvider);
    currentDay = now.weekday;
    if (currentDay == 7) {
      currentDay = 0;
    }
    print("day $currentDay");
    DateTime firstDayOfWeek = now.subtract(Duration(days: currentDay));
    today = now;

    for (int i = 0; i < 7; i++) {
      final day = firstDayOfWeek.add(Duration(days: i));
      dates.add(day);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    ImageProvider profileImage =
        Image.network(widget.thisUser.profileUrl).image;

    Utils imagePicker = Utils();

    void selectImage() async {
      try {
        Uint8List file = await imagePicker.pickImage(ImageSource.gallery);

        String profileUrl =
            await StorageServices().storeImage('profileImage', file);

        await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser!.uid)
            .update({'profileUrl': profileUrl});
      } catch (e) {
        print(e);
      }
    }

    return DefaultTabController(
      length: 3,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  if (widget.thisUser.uid == currentUser!.uid) {
                    selectImage();
                  } else {
                    showImageViewer(context, profileImage);
                  }
                },
                child: CircleAvatar(
                  backgroundImage: NetworkImage(widget.thisUser.profileUrl),
                  radius: 48,
                ),
              ),
              const SizedBox(height: 10),
              Builder(builder: (context) {
                if (widget.thisUser.firstName != "") {
                  return Text(
                    "${widget.thisUser.firstName} ${widget.thisUser.lastName}",
                    style: Theme.of(context).textTheme.titleLarge,
                  );
                } else {
                  return Text(
                    widget.thisUser.username,
                    style: Theme.of(context).textTheme.titleLarge,
                  );
                }
              }),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Builder(builder: (context) {
                        if (widget.thisUser.uid == currentUser!.uid) {
                          return GestureDetector(
                            onTap: () {
                              context.pushNamed(
                                  RouteConstants.editProfileScreen,
                                  extra: widget.thisUser);
                            },
                            child: const SizedBox(
                                width: 150,
                                child:
                                    CustomButton(buttonText: "Edit Profile")),
                          );
                        } else {
                          return StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(widget.thisUser.uid)
                                  .collection('followers')
                                  .doc(currentUser.uid)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.active) {
                                  if (snapshot.data!.exists) {
                                    return GestureDetector(
                                        onTap: () async {
                                          setState(() {
                                            followers--;
                                          });
                                          userServices!.unfollowUser(
                                              widget.thisUser.uid);
                                        },
                                        child: const CustomButton(
                                            buttonText: "Unfollow"));
                                  } else {
                                    return GestureDetector(
                                        onTap: () async {
                                          setState(() {
                                            followers++;
                                          });
                                          userServices!
                                              .followUser(widget.thisUser.uid);
                                        },
                                        child: const CustomButton(
                                            buttonText: "Follow"));
                                  }
                                } else {
                                  return const CustomButton(
                                    buttonText: "Follow",
                                  );
                                }
                              });
                        }
                      }),
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    Expanded(
                      child: GestureDetector(
                          onTap: () {
                            context.pushNamed(RouteConstants.viewRoutinePage,
                                pathParameters: {
                                  'id': widget.thisUser.uid
                                },
                                extra: {
                                  'currentDay': currentDay,
                                  'startRoutine': false
                                });
                          },
                          child: const CustomButton(
                              primary: false, buttonText: 'View Routine')),
                    ),
                  ],
                ),
              ),
              Divider(
                color: Theme.of(context).colorScheme.primary,
              ),
              Center(
                child: FutureBuilder(
                    future: getFollowage(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            CountWidget(
                                amount: widget.thisUser.posts.length.toString(),
                                type: 'posts'),
                            GestureDetector(
                              onTap: () {
                                context.pushNamed(
                                    RouteConstants.followageScreen,
                                    pathParameters: {
                                      "uid": widget.thisUser.uid,
                                      "type": "followers"
                                    });
                              },
                              child: CountWidget(
                                  amount: (followers).toString(),
                                  type: 'followers'),
                            ),
                            GestureDetector(
                              onTap: () {
                                context.pushNamed(
                                    RouteConstants.followageScreen,
                                    pathParameters: {
                                      "uid": widget.thisUser.uid,
                                      "type": "following"
                                    });
                              },
                              child: CountWidget(
                                  amount: (following).toString(),
                                  type: 'following'),
                            ),
                          ],
                        );
                      } else {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            CountWidget(
                                amount: widget.thisUser.posts.length.toString(),
                                type: 'posts'),
                            CountWidget(
                                amount: (followers).toString(),
                                type: 'followers'),
                            CountWidget(
                                amount: (following).toString(),
                                type: 'following'),
                          ],
                        );
                      }
                    }),
              ),
              TabBar(
                indicatorColor: Theme.of(context).colorScheme.primary,
                tabs: [
                  Tab(
                      icon: Icon(
                    Icons.post_add,
                    color: Theme.of(context).colorScheme.secondary,
                  )),
                  Tab(
                      icon: Icon(
                    Icons.fitness_center_rounded,
                    color: Theme.of(context).colorScheme.secondary,
                  )),
                  Tab(
                      icon: Icon(
                    Icons.food_bank_rounded,
                    color: Theme.of(context).colorScheme.secondary,
                  )),
                ],
              ),
              Expanded(
                child: TabBarView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    PostFeedWidget(
                        profileView: true,
                        postQuery:
                            feedServices!.fetchUserPosts(widget.thisUser.uid)),
                    WorkoutFeed(
                      profileView: true,
                      uid: widget.thisUser.uid,
                      postQuery:
                          FeedServices().fetchUserWorkouts(widget.thisUser.uid),
                    ),
                    MealFeed(
                        postQuery:
                            FeedServices().fetchMeals(widget.thisUser.uid))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
