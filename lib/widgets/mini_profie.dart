import 'package:fitness_social_app/models/user_model.dart';
import 'package:flutter/material.dart';

class MiniProfie extends StatelessWidget {
  const MiniProfie({Key? key, required this.user}) : super(key: key);
  final UserModel user;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(user.profileUrl),
          ),
          Text('  ${user.username}'),
        ],
      ),
    );
  }
}
