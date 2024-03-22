import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_social_app/main.dart';
import 'package:fitness_social_app/pages/chat_page.dart';
import 'package:fitness_social_app/routing/route_constants.dart';
import 'package:fitness_social_app/services/auth_service.dart';
import 'package:fitness_social_app/services/user_services.dart';
import 'package:fitness_social_app/widgets/bottom_modal_item_widget.dart';
import 'package:fitness_social_app/widgets/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  User? user;

  @override
  void initState() {
    user = ref.read(userProvider);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    return Scaffold(
      body: RefreshIndicator(
        notificationPredicate: (notification) {
          // with NestedScrollView local(depth == 2) OverscrollNotification are not sent
          return notification.depth == 2;
        },
        onRefresh: () async {
          Future.delayed(
            Duration(seconds: 0),
            () {
              setState(() {});
            },
          );
        },
        child: FutureBuilder(
          future: users.doc(user!.uid).get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              Map<String, dynamic> data =
                  snapshot.data!.data() as Map<String, dynamic>;

              final thisUser = UserServices().mapSingleUser(data);

              return NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) => [
                  SliverAppBar(
                    title: Text(
                      thisUser.username,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),

                    actions: [
                      Padding(
                        padding: const EdgeInsets.only(right: 21.4),
                        child: GestureDetector(
                          onTap: () {
                            Auth().signOut();
                            ref.invalidate(userProvider);
                            ref.invalidate(genericPostServicesProvider);
                            ref.invalidate(feedServicesProvider);
                            ref.invalidate(userServicesProvider);
                            ref.invalidate(utilProvider);
                            ref.invalidate(draftProvider);
                          },
                          child: const Icon(Icons.logout_outlined),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 5.0,
                          right: 21.0,
                          top: 8.0,
                          bottom: 8.0,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            // print("object");
                            // Navigator.of(context).push(
                            //   MaterialPageRoute(
                            //     builder: (context) => const Chat(),
                            //   ),
                            // );
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Chat(),
                              ),
                            );
                          },
                          child: const Icon(Icons.chat),
                        ),
                      )
                    ],
                    backgroundColor: Theme.of(context).colorScheme.background,
                    // snap: true,
                    floating: true,
                  )
                ],
                body: Column(
                  children: [
                    Expanded(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          UserProfile(thisUser: thisUser),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: FloatingActionButton.small(
                                backgroundColor:
                                    Theme.of(context).colorScheme.secondary,
                                onPressed: () {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    showDragHandle: true,
                                    useSafeArea: true,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(20))),
                                    builder: (context) {
                                      return Padding(
                                        padding: EdgeInsets.only(
                                            bottom: MediaQuery.of(context)
                                                .viewInsets
                                                .bottom),
                                        child: ListView(
                                          shrinkWrap: true,
                                          children: [
                                            GestureDetector(
                                                onTap: () {
                                                  context.pop();
                                                  context.pushNamed(
                                                      RouteConstants
                                                          .createPost);
                                                },
                                                child: const BottomModalItem(
                                                  text: "Create a Post",
                                                  iconRequired: false,
                                                )),
                                            Divider(),
                                            GestureDetector(
                                                onTap: () {
                                                  context.pop();

                                                  context.pushNamed(
                                                      RouteConstants
                                                          .createWorkout);
                                                },
                                                child: const BottomModalItem(
                                                  text: "Create a Workout",
                                                  iconRequired: false,
                                                )),
                                            Divider(),
                                            GestureDetector(
                                                onTap: () {
                                                  context.pop();

                                                  context.pushNamed(
                                                      RouteConstants
                                                          .createMeal);
                                                },
                                                child: const BottomModalItem(
                                                  text: "Create a Meal",
                                                  iconRequired: false,
                                                ))
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: Icon(
                                  (Icons.add),
                                  color:
                                      Theme.of(context).colorScheme.background,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
