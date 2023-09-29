import 'package:fitness_social_app/models/user_model.dart';
import 'package:fitness_social_app/routing/route_constants.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MiniProfie extends StatelessWidget {
  const MiniProfie({Key? key, required this.user}) : super(key: key);
  final UserModel user;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(RouteConstants.userPage, extra: user);
      },
      child: SizedBox(
        height: 50,
        child: Row(
          children: [
            CircleAvatar(
              foregroundImage: NetworkImage(user.profileUrl),
            ),
            Text('  ${user.username}'),
          ],
        ),
      ),
    );
  }
}
