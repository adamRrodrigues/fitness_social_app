import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_social_app/models/user_model.dart';
import 'package:fitness_social_app/services/auth_service.dart';
import 'package:fitness_social_app/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    return Scaffold(
      body: FutureBuilder(
        future: users.doc(user.uid).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;

            final thisUser = UserModel(
                username: data['username'],
                uid: user.uid,
                posts: data['posts'],
                profileUrl: data['profileUrl']);

            return NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverAppBar(
                  title: Text(thisUser.username),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () => Auth().signOut(),
                        child: Icon(Icons.logout_outlined),
                      ),
                    )
                  ],
                  backgroundColor: Theme.of(context).colorScheme.background,
                  // snap: true,
                  floating: true,
                )
              ],
              body: SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(thisUser.profileUrl),
                            radius: 48,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Full Name",
                            style: Theme.of(context).textTheme.titleLarge,
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const CustomButton(buttonText: "Edit Profile"),
                      Divider(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                Text(
                                  thisUser.posts.length.toString(),
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                Text(
                                  'posts',
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  '1.4k',
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                Text(
                                  'followers',
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  '133',
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                Text(
                                  'following',
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                              ],
                            ),
                          ])
                    ],
                  ),
                ),
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
