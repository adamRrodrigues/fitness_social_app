import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:fitness_social_app/main.dart';
import 'package:fitness_social_app/models/routine_model.dart';
import 'package:fitness_social_app/models/workout_post_model.dart';
import 'package:fitness_social_app/services/feed_services.dart';
import 'package:fitness_social_app/widgets/workout_widgets/workout_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class WorkoutFeed extends ConsumerStatefulWidget {
  const WorkoutFeed({
    Key? key,
    required this.uid,
    this.profileView,
    required this.postQuery,
    this.day = 0,
  }) : super(key: key);
  final String uid;
  final Query<WorkoutModel> postQuery;
  final bool? profileView;
  final int day;

  @override
  _WorkoutFeedState createState() => _WorkoutFeedState();
}

class _WorkoutFeedState extends ConsumerState<WorkoutFeed>
    with AutomaticKeepAliveClientMixin {
  Routine routine = Routine();
  @override
  void initState() {
    routine = ref.read(routineProvider);
    super.initState();
  }

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
        return InkWell(
          onTap: () {
            routine.addToRoutine(widget.day, post);
            print(routine.routines[widget.day].workouts);
            context.pop();
          },
          child: WorkoutWidget(
            workoutModel: post,
            postId: doc.id,
            mini: widget.profileView,
          ),
        );
      },
    ));
  }

  @override
  bool get wantKeepAlive => true;
}
