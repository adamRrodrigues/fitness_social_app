import 'package:fitness_social_app/auth/auth_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

final GoRouter appRouter = GoRouter(routes: <GoRoute>[
  GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const AuthState();
      },
      routes: <GoRoute>[])
]);
