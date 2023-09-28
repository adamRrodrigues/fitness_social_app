import 'package:fitness_social_app/models/comment_model.dart';
import 'package:fitness_social_app/models/user_model.dart';
import 'package:fitness_social_app/routing/route_constants.dart';
import 'package:fitness_social_app/widgets/mini_profie.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CommentWidget extends StatelessWidget {
  const CommentWidget(
      {Key? key, required this.commentModel, required this.userModel})
      : super(key: key);
  final CommentModel commentModel;
  final UserModel userModel;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(RouteConstants.userPage, extra: userModel);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [MiniProfie(user: userModel), Text(commentModel.comment)],
      ),
    );
  }
}
