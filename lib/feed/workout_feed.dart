import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:fitness_social_app/main.dart';
import 'package:fitness_social_app/models/routine_model.dart';
import 'package:fitness_social_app/models/workout_post_model.dart';
import 'package:fitness_social_app/widgets/workout_widgets/workout_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WorkoutFeed extends ConsumerStatefulWidget {
  const WorkoutFeed(
      {Key? key,
      required this.uid,
      this.profileView,
      required this.postQuery,
      this.horizontal = false,
      this.day = 0,
      this.selection = false})
      : super(key: key);
  final String uid;
  final Query<WorkoutModel> postQuery;
  final bool? profileView;
  final int day;
  final bool selection;
  final bool horizontal;

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
    return Builder(builder: (context) {
      if (widget.horizontal == false) {
        return FirestoreListView<WorkoutModel>(
          pageSize: 5,
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          physics: const BouncingScrollPhysics(),
          emptyBuilder: (context) {
            return Center(
              child: Text('Nothing To See Here'),
            );
          },
          loadingBuilder: (context) {
            return const Center(child: CircularProgressIndicator());
          },
          errorBuilder: (context, error, stackTrace) {
            return const Center(
              child:
                  Text('There was a problem loading the feed please try again'),
            );
          },
          query: widget.postQuery,
          itemBuilder: (context, doc) {
            final post = doc.data();
            return InkWell(
              onTap: () {
                // context.pop();
              },
              child: WorkoutWidget(
                workoutModel: post,
                day: widget.day,
                selection: widget.selection,
                mini: widget.profileView,
              ),
            );
          },
        );
      } else {
        return FirestoreListView<WorkoutModel>(
          pageSize: 5,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          emptyBuilder: (context) {
            return Center(
              child: Text('Nothing To See Here'),
            );
          },
          loadingBuilder: (context) {
            return const Center(child: CircularProgressIndicator());
          },
          errorBuilder: (context, error, stackTrace) {
            return const Center(
              child:
                  Text('There was a problem loading the feed please try again'),
            );
          },
          query: widget.postQuery,
          itemBuilder: (context, doc) {
            final post = doc.data();
            return SizedBox(
              width: 400,
              child: WorkoutWidget(
                workoutModel: post,
                day: widget.day,
                selection: widget.selection,
                mini: false,
              ),
            );
          },
        );
      }
    });
  }

  @override
  bool get wantKeepAlive => true;
}
