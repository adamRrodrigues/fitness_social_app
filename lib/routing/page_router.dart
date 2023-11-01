import 'package:fitness_social_app/auth/auth_state.dart';
import 'package:fitness_social_app/models/generic_post_model.dart';
import 'package:fitness_social_app/models/user_model.dart';
import 'package:fitness_social_app/routing/route_constants.dart';
import 'package:fitness_social_app/screen/create_post.dart';
import 'package:fitness_social_app/screen/create_workout_post.dart';
// import 'package:fitness_social_app/screen/fall_back_screen.dart';
import 'package:fitness_social_app/screen/user_page.dart';
import 'package:fitness_social_app/screen/view_post.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

final GoRouter appRouter = GoRouter(routes: <GoRoute>[
  GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const AuthState();
      },
      routes: <GoRoute>[
        GoRoute(
          path: 'userPage',
          name: RouteConstants.userPage,
          pageBuilder: (context, state) {
            UserModel user = state.extra as UserModel;

            return CupertinoPage(
                child: UserPage(
              user: user,
            ));
          },
        ),
        GoRoute(
          path: 'createPage',
          name: RouteConstants.createPost,
          pageBuilder: (context, state) {
            return const CupertinoPage(child: CreatePost());
          },
        ),
        GoRoute(
          path: 'createWorkoutPage',
          name: RouteConstants.createWorkout,
          pageBuilder: (context, state) {
            return const CupertinoPage(child: CreateWorkoutPost());
          },
        ),
        GoRoute(
          path: 'viewPostScreen/:id',
          name: RouteConstants.viewPostScreen,
          pageBuilder: (context, state) {
            GenericPost post = state.extra as GenericPost;
            final  postId = state.pathParameters['id'];
            return CupertinoPage(
                child: ViewPost(
              post: post,
              postId: postId!,
            ));
          },
        ),
      ])
]);
