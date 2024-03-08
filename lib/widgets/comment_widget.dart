import 'package:fitness_social_app/models/comment_model.dart';
import 'package:fitness_social_app/models/user_model.dart';
import 'package:fitness_social_app/routing/route_constants.dart';
import 'package:fitness_social_app/widgets/mini_profie.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CommentWidget extends StatelessWidget {
  const CommentWidget({Key? key, required this.commentModel}) : super(key: key);
  final CommentModel commentModel;

  @override
  Widget build(BuildContext context) {
    UserModel? user;
    return GestureDetector(
      onTap: () {
        context.pushNamed(RouteConstants.userPage, extra: user);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MiniProfie(
              userId: commentModel.uid, optionalSubText: commentModel.comment),
        ],
      ),
    );
  }
}
