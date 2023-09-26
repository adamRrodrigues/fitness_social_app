import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_social_app/models/user_model.dart';
import 'package:fitness_social_app/services/user_services.dart';
import 'package:fitness_social_app/widgets/count_widget.dart';
import 'package:fitness_social_app/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({
    super.key,
    required this.thisUser,
  });

  final UserModel thisUser;

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  int followers = 0;
  int following = 0;

  Stream getFollowage() async* {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.thisUser.uid)
        .collection('followers')
        .count()
        .get()
        .then(
          (value) => followers = value.count,
        );
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.thisUser.uid)
        .collection('following')
        .count()
        .get()
        .then(
          (value) => following = value.count,
        );
    
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.thisUser.profileUrl),
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
            Builder(builder: (context) {
              if (widget.thisUser.uid == currentUser!.uid) {
                return const CustomButton(buttonText: "Edit Profile");
              } else {
                return StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(widget.thisUser.uid)
                        .collection('followers')
                        .doc(currentUser.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.active) {
                        if (snapshot.data!.exists) {
                          return GestureDetector(
                              onTap: () {
                                setState(()  {
                                  UserServices().unfollowUser(widget.thisUser.uid);
                                });
                              },
                              child: const CustomButton(buttonText: "Unfollow"));
                        } else {
                          return GestureDetector(
                              onTap: () {
                                setState(() {
                                  print(followers);
                                  UserServices().followUser(widget.thisUser.uid);
                                });
                              },
                              child: const CustomButton(buttonText: "Follow"));
                        }
                      } else {
                        return CircularProgressIndicator();
                      }
                    });
              }
            }),
            Divider(
              color: Theme.of(context).colorScheme.primary,
            ),
            StreamBuilder(
                stream: getFollowage(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          CountWidget(
                              amount: widget.thisUser.posts.length.toString(),
                              type: 'posts'),
                          CountWidget(
                              amount: followers.toString(), type: 'followers'),
                          CountWidget(
                              amount: following.toString(), type: 'following'),
                        ],
                      ),
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                })
          ],
        ),
      ),
    );
  }
}
