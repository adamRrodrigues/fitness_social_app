import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_social_app/main.dart';
import 'package:fitness_social_app/models/user_model.dart';
import 'package:fitness_social_app/services/feed_services.dart';
import 'package:fitness_social_app/services/post_service.dart';
import 'package:fitness_social_app/services/storage_services.dart';
import 'package:fitness_social_app/services/user_services.dart';
import 'package:fitness_social_app/utlis/utils.dart';
import 'package:fitness_social_app/widgets/count_widget.dart';
import 'package:fitness_social_app/widgets/custom_button.dart';
import 'package:fitness_social_app/widgets/post_feed_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  CollectionReference posts =
      FirebaseFirestore.instance.collection('generic_posts');

  @override
  void initState() {
    super.initState();
    user = ref.read(userProvider);
    userServices = ref.read(userServicesProvider);
    genericPostServices = ref.read(genericPostServicesProvider);
    feedServices = ref.read(feedServicesProvider);
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

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: RefreshIndicator(
          onRefresh: () async {
            Future(
              () {
                setState(() {});
              },
            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
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
                        if (snapshot.connectionState ==
                            ConnectionState.active) {
                          if (snapshot.data!.exists) {
                            return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    userServices!
                                        .unfollowUser(widget.thisUser.uid);
                                  });
                                },
                                child:
                                    const CustomButton(buttonText: "Unfollow"));
                          } else {
                            return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    print(followers);
                                    userServices!
                                        .followUser(widget.thisUser.uid);
                                  });
                                },
                                child:
                                    const CustomButton(buttonText: "Follow"));
                          }
                        } else {
                          return const CircularProgressIndicator();
                        }
                      });
                }
              }),
              Divider(
                color: Theme.of(context).colorScheme.primary,
              ),
              Center(
                child: StreamBuilder(
                    stream: getFollowage(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            CountWidget(
                                amount: widget.thisUser.posts.length.toString(),
                                type: 'posts'),
                            CountWidget(
                                amount: followers.toString(),
                                type: 'followers'),
                            CountWidget(
                                amount: following.toString(),
                                type: 'following'),
                          ],
                        );
                      } else {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            CountWidget(
                                amount: widget.thisUser.posts.length.toString(),
                                type: 'posts'),
                            CountWidget(amount: 'xx', type: 'followers'),
                            CountWidget(amount: 'xx', type: 'following'),
                          ],
                        );
                      }
                    }),
              ),
              Expanded(
                  child: PostFeedWidget(
                      postQuery:
                          feedServices!.fetchUserPosts(widget.thisUser.uid)))
            ],
          ),
        ),
      ),
    );
  }
}
