import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:fitness_social_app/models/generic_post_model.dart';
import 'package:fitness_social_app/widgets/custom_button.dart';
import 'package:fitness_social_app/widgets/generic_post_widget.dart';
import 'package:flutter/material.dart';

class PostFeedWidget extends StatefulWidget {
  const PostFeedWidget(
      {super.key,
      required this.postQuery,
      this.profileView = false,
      this.noPostsMessage = "Nothing to see here"});

  final Query<GenericPost> postQuery;
  final bool? profileView;
  final String noPostsMessage;

  @override
  State<PostFeedWidget> createState() => _PostFeedWidgetState();
}

class _PostFeedWidgetState extends State<PostFeedWidget> {
  @override
  Widget build(BuildContext context) {
    return FirestoreListView<GenericPost>(
      pageSize: 5,
      physics: const BouncingScrollPhysics(),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      emptyBuilder: (context) {
        return ListView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            Center(
              child: Text(widget.noPostsMessage),
            ),
          ],
        );
      },
      loadingBuilder: (context) {
        return const Center(child: CircularProgressIndicator());
      },
      errorBuilder: (context, error, stackTrace) {
        return ListView(children: [
          const Center(
            child:
                Text('There was a problem loading the feed please try again'),
          ),
          GestureDetector(
              onTap: () {
                setState(() {});
              },
              child: const CustomButton(buttonText: "Refresh"))
        ]);
      },
      query: widget.postQuery,
      itemBuilder: (context, doc) {
        final post = doc.data();
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: GenericPostWidget(
            post: post,
            postId: doc.id,
            mini: widget.profileView,
          ),
        );
      },
    );
  }
}
