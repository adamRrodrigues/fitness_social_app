import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_social_app/models/generic_post_model.dart';
import 'package:fitness_social_app/widgets/post_feed_widget.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final postQuery = FirebaseFirestore.instance
      .collection('generic_posts')
      .orderBy('createdAt')
      .withConverter(
        fromFirestore: (snapshot, _) => GenericPost.fromMap(snapshot.data()!),
        toFirestore: (post, _) => post.toMap(),
      );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: PostFeedWidget(postQuery: postQuery));
  }
}
