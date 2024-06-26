import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_social_app/main.dart';
import 'package:fitness_social_app/services/feed_services.dart';
import 'package:fitness_social_app/feed/post_feed_widget.dart';
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
  FeedServices? feedServices;

  @override
  void initState() {
    user = ref.read(userProvider);
    feedServices = ref.read(feedServicesProvider);
    super.initState();
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
            child: StreamBuilder(
                stream: feedServices!.fetchFollowing(user!.uid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (feedServices!.following.isNotEmpty) {
                      return PostFeedWidget(
                        profileView: false,
                        postQuery: feedServices!.fetchPosts(user!.uid),
                        noPostsMessage:
                            "None of the users you follow have any posts </3",
                      );
                    } else {
                      return Expanded(
                        child: Center(
                          child: ListView(
                            children: const [
                              Center(
                                child: Text('You Are Not Following Any users'),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                })));
  }

  @override
  bool get wantKeepAlive => true;
}
