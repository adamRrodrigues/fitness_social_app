import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_social_app/main.dart';
import 'package:fitness_social_app/routing/route_constants.dart';
import 'package:fitness_social_app/services/auth_service.dart';
import 'package:fitness_social_app/services/user_services.dart';
import 'package:fitness_social_app/widgets/custom_button.dart';
import 'package:fitness_social_app/widgets/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:modals/modals.dart';

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
      body: FutureBuilder(
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
                      padding: const EdgeInsets.all(8.0),
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
                              onPressed: () {
                                // context.pushNamed(RouteConstants.createPost);
                                showModal(ModalEntry.aligned(context,
                                    tag: 'containerModal',
                                    barrierDismissible: true,
                                    alignment: Alignment.center,
                                    // removeOnPop: true,

                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .background,
                                          border: Border.all(
                                              width: 2,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      width: 300,
                                      height: 200,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          GestureDetector(
                                              onTap: () {
                                                context.pushNamed(
                                                    RouteConstants.createPost);
                                                // context.pop();
                                                removeAllModals();
                                              },
                                              child: CustomButton(
                                                  buttonText: 'generic post')),
                                          GestureDetector(
                                              onTap: () {
                                                context.pushNamed(RouteConstants
                                                    .createWorkout);
                                                removeAllModals();
                                              },
                                              child: CustomButton(
                                                  buttonText: 'workout post'))
                                        ],
                                      ),
                                    )));
                              },
                              child: const Icon((Icons.add)),
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
    );
  }
}
