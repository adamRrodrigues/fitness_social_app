import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:fitness_social_app/models/generic_post_model.dart';
import 'package:fitness_social_app/widgets/generic_post_widget.dart';
import 'package:flutter/material.dart';

class PostFeedWidget extends StatelessWidget {
  const PostFeedWidget({
    super.key,
    required this.postQuery,
  });

  final Query<GenericPost> postQuery;

  @override
  Widget build(BuildContext context) {
    return FirestoreListView<GenericPost>(
      pageSize: 5,
      emptyBuilder: (context) {
        return const Center(
          child: Text('No Posts'),
        );
      },
      loadingBuilder: (context) {
        return const Center(child: CircularProgressIndicator());
      },
      query: postQuery,
      itemBuilder: (context, doc) {
        final post = doc.data();
        return GenericPostWidget(post: post, postId: doc.id);
      },
    );
  }
}
