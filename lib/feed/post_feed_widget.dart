import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:fitness_social_app/models/generic_post_model.dart';
import 'package:fitness_social_app/widgets/generic_post_widget.dart';
import 'package:flutter/material.dart';

class PostFeedWidget extends StatelessWidget {
  const PostFeedWidget({
    super.key,
    required this.postQuery,
    this.profileView = false,
  });

  final Query<GenericPost> postQuery;
  final bool? profileView;

  @override
  Widget build(BuildContext context) {
    return FirestoreListView<GenericPost>(
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
      query: postQuery,
      itemBuilder: (context, doc) {
        final post = doc.data();
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: GenericPostWidget(
            post: post,
            postId: doc.id,
            mini: profileView,
          ),
        );
      },
    );
  }
}
