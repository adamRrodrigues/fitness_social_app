import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:fitness_social_app/main.dart';
import 'package:fitness_social_app/services/feed_services.dart';
import 'package:fitness_social_app/widgets/workout_widgets/workout_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DiscoverPageWorkouts extends ConsumerStatefulWidget {
  const DiscoverPageWorkouts({
    super.key,
    required this.user,
  });

  final User? user;

  @override
  _DiscoverPageWorkoutsState createState() => _DiscoverPageWorkoutsState();
}

class _DiscoverPageWorkoutsState extends ConsumerState<DiscoverPageWorkouts> {
  @override
  Widget build(BuildContext context) {
    FeedServices feedServices = ref.read(feedServicesProvider);

    return SizedBox(
      height: 420,
      child: FirestoreListView(
        scrollDirection: Axis.horizontal,
        addAutomaticKeepAlives: true,
        shrinkWrap: true,
        pageSize: 5,
        physics: const BouncingScrollPhysics(),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        emptyBuilder: (context) {
          return Center(
            child: Text("No Users"),
          );
        },
        loadingBuilder: (context) {
          return const Center(child: CircularProgressIndicator());
        },
        errorBuilder: (context, error, stackTrace) {
          return Text("Error");
        },
        query: feedServices.fetchWorkouts(widget.user!.uid),
        itemBuilder: (context, doc) {
          final post = doc.data();
          return Container(
              width: 400,
              // padding: const EdgeInsets.all(8.0),
              child: WorkoutWidget(
                workoutModel: post,
                mini: false,
              ));
        },
      ),
    );
  }
}
