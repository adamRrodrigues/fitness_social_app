import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:fitness_social_app/models/workout_post_model.dart';
import 'package:fitness_social_app/services/feed_services.dart';
import 'package:fitness_social_app/widgets/workout_widgets/workout_widget.dart';
import 'package:flutter/material.dart';

class FitnesstrackerPage extends StatefulWidget {
  const FitnesstrackerPage({Key? key}) : super(key: key);
  @override
  _FitnesstrackerPageState createState() => _FitnesstrackerPageState();
}

class _FitnesstrackerPageState extends State<FitnesstrackerPage> {
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    return FirestoreListView<WorkoutModel>(
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
      query: FeedServices().fetchUserWorkouts(user!.uid),
      itemBuilder: (context, doc) {
        final post = doc.data();
        return WorkoutWidget(workoutModel: post, postId: doc.id, mini: false,);
      },
    );
  }
}
