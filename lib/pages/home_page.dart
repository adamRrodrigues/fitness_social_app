import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_social_app/services/feed_services.dart';
import 'package:fitness_social_app/widgets/post_feed_widget.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
  }

  final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        body: PostFeedWidget(postQuery: FeedServices().fetchPosts(user!.uid)));
  }

  @override
  bool get wantKeepAlive => true;
}
