import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:fitness_social_app/models/workout_post_model.dart';
import 'package:fitness_social_app/services/feed_services.dart';
import 'package:fitness_social_app/widgets/workout_widgets/workout_widget.dart';
import 'package:flutter/material.dart';

class WorkoutFeed extends StatefulWidget {
  const WorkoutFeed({Key? key, required this.uid, this.profileView})
      : super(key: key);
  final String uid;
  final bool? profileView;

  @override
  State<WorkoutFeed> createState() => _WorkoutFeedState();
}

class _WorkoutFeedState extends State<WorkoutFeed>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        body: FirestoreListView<WorkoutModel>(
      pageSize: 5,
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      emptyBuilder: (context) {
        return ListView(
          children: [
            const Center(
              child: Text('No Posts'),
            ),
          ],
        );
      },
      loadingBuilder: (context) {
        return const Center(child: CircularProgressIndicator());
      },
      errorBuilder: (context, error, stackTrace) {
        return const Center(
          child: Text('There was a problem loading the feed please try again'),
        );
      },
      query: FeedServices().fetchUserWorkouts(widget.uid),
      itemBuilder: (context, doc) {
        final post = doc.data();
        return WorkoutWidget(
          workoutModel: post,
          postId: doc.id,
          mini: widget.profileView,
        );
      },
    ));
  }

  @override
  bool get wantKeepAlive => true;
}
