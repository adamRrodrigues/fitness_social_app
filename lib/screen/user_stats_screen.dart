import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_social_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserStatsScreen extends ConsumerWidget {
  const UserStatsScreen({Key? key, required this.uid}) : super(key: key);
  final String uid;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    User? user = ref.read(userProvider);
    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
            // physics: BouncingScrollPhysics(),
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
                  SliverAppBar(
                    title:
                        Text(user!.uid == uid ? "My Stats" : "username Stats"),
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  )
                ],
            body: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
            )),
      ),
    );
  }
}
