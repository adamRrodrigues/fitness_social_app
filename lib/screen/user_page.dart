import 'package:fitness_social_app/models/user_model.dart';
import 'package:fitness_social_app/widgets/user_profile.dart';
import 'package:flutter/material.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key, required this.user}) : super(key: key);

  @override
  final UserModel user;

  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverAppBar(
                  title: Text(
                    widget.user.username,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  backgroundColor: Theme.of(context).colorScheme.background,
                  // snap: true,
                  floating: true,
                )
              ],
          body: Column(
            children: [UserProfile(thisUser: widget.user)],
          )),
    );
  }
}
