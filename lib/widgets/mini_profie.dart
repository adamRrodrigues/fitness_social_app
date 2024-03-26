import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_social_app/models/user_model.dart';
import 'package:fitness_social_app/routing/route_constants.dart';
import 'package:fitness_social_app/services/user_services.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MiniProfie extends StatefulWidget {
  const MiniProfie({Key? key, this.optionalSubText, required this.userId})
      : super(key: key);
  final String userId;
  final String? optionalSubText;

  @override
  State<MiniProfie> createState() => _MiniProfieState();
}

class _MiniProfieState extends State<MiniProfie> {
  String username = "";
  String profileUrl = "";

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.hasData &&
            snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;

          final thisUser = UserServices().mapSingleUser(data);
          username = thisUser.username;
          profileUrl = thisUser.profileUrl;

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                context.pushNamed(RouteConstants.userPage, extra: thisUser);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 20,
                    foregroundImage: NetworkImage(thisUser.profileUrl),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '@${thisUser.username}',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        widget.optionalSubText != null
                            ? Text(
                                widget.optionalSubText!,
                              )
                            : Text(
                                "${thisUser.firstName} ${thisUser.lastName}"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 20,
                  foregroundImage:
                      profileUrl != "" ? NetworkImage(profileUrl) : null,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '@$username',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      widget.optionalSubText != null
                          ? Text(
                              widget.optionalSubText!,
                            )
                          : const Text(''),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else {
          return const Text('Error Loading');
        }
      },
    );
  }
}

class MiniProfileWidget extends StatelessWidget {
  const MiniProfileWidget({
    super.key,
    required this.thisUser,
  });

  final UserModel thisUser;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.pushNamed(RouteConstants.userPage, extra: thisUser);
      },
      child: Container(
        width: 80,
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            CircleAvatar(
                maxRadius: 30,
                backgroundImage: NetworkImage(thisUser.profileUrl)),
            Text(
              thisUser.username,
              overflow: TextOverflow.ellipsis,
            )
          ],
        ),
      ),
    );
  }
}
