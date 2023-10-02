import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_social_app/models/comment_model.dart';
import 'package:fitness_social_app/routing/route_constants.dart';
import 'package:fitness_social_app/services/user_services.dart';
import 'package:fitness_social_app/widgets/mini_profie.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CommentWidget extends StatelessWidget {
  const CommentWidget(
      {Key? key, required this.commentModel})
      : super(key: key);
  final CommentModel commentModel;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance.collection('users').doc(commentModel.uid).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;

          final thisUser = UserServices().mapSingleUser(data);

          return GestureDetector(
            onTap: () {
              context.pushNamed(RouteConstants.userPage, extra: thisUser);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MiniProfie(user: thisUser),
                Text(commentModel.comment)
              ],
            ),
          );
        } else {
          return const Center(
            child: Text('Loading Comment'),
          );
        }
      },
    );
  }
}
