import 'package:fitness_social_app/services/feed_services.dart';
import 'package:fitness_social_app/widgets/post_feed_widget.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: PostFeedWidget(postQuery: FeedServices().postQuery));
  }
}
