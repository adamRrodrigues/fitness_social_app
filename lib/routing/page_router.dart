import 'package:fitness_social_app/auth/auth_state.dart';
import 'package:fitness_social_app/models/user_model.dart';
import 'package:fitness_social_app/routing/route_constants.dart';
import 'package:fitness_social_app/screen/user_page.dart';
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
        )
      ])
]);
