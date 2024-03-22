import 'package:fitness_social_app/models/user_model.dart';
import 'package:fitness_social_app/widgets/user_profile.dart';
import 'package:flutter/material.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key, required this.user}) : super(key: key);

  final UserModel user;

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          displacement: 70,
          color: Theme.of(context).colorScheme.primary,
          notificationPredicate: (notification) {
            // with NestedScrollView local(depth == 2) OverscrollNotification are not sent
            return notification.depth == 2;
          },
          onRefresh: () => Future(() {
            setState(() {});
          }),
          child: NestedScrollView(
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
              body: Stack(
                children: [
                  RefreshIndicator(
                      onRefresh: () async {},
                      child: UserProfile(thisUser: widget.user))
                ],
              )),
        ),
      ),
    );
  }
}
