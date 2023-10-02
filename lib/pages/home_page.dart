import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_social_app/main.dart';
import 'package:fitness_social_app/services/feed_services.dart';
import 'package:fitness_social_app/widgets/post_feed_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with AutomaticKeepAliveClientMixin {
  User? user;
  @override
  void initState() {
    super.initState();
    // "ref" can be used in all life-cycles of a StatefulWidget.
    user = ref.read(userProvider);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        body: RefreshIndicator(
            onRefresh: () async {
              Future(
                () {
                  setState(() {});
                },
              );
            },
            child: PostFeedWidget(
                postQuery: FeedServices().fetchPosts(user!.uid))));
  }

  @override
  bool get wantKeepAlive => true;
}
