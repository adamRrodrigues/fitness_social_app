import 'package:fitness_social_app/models/user_model.dart';
import 'package:fitness_social_app/routing/route_constants.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MiniProfie extends StatelessWidget {
  const MiniProfie({Key? key, required this.user, this.optionalSubText})
      : super(key: key);
  final UserModel user;
  final String? optionalSubText;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(RouteConstants.userPage, extra: user);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            foregroundImage: NetworkImage(user.profileUrl),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '@${user.username}',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                optionalSubText != null
                    ? Text(
                        optionalSubText!,
                      )
                    : Text(''),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
