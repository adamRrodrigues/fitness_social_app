import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:fitness_social_app/main.dart';
import 'package:fitness_social_app/services/feed_services.dart';
import 'package:fitness_social_app/widgets/mini_profie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DiscoverPageUsers extends ConsumerStatefulWidget {
  const DiscoverPageUsers({
    super.key,
    required this.user,
  });

  final User? user;

  @override
  _DiscoverPageUsersState createState() => _DiscoverPageUsersState();
}

class _DiscoverPageUsersState extends ConsumerState<DiscoverPageUsers> {
  @override
  Widget build(BuildContext context) {
    FeedServices feedServices = ref.read(feedServicesProvider);

    return SizedBox(
      height: 130,
      child: FirestoreListView(
        scrollDirection: Axis.horizontal,
        addAutomaticKeepAlives: true,
        shrinkWrap: true,
        pageSize: 5,
        physics: const BouncingScrollPhysics(),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        emptyBuilder: (context) {
          return const Center(
            child: Text("No Users"),
          );
        },
        loadingBuilder: (context) {
          return const Center(child: CircularProgressIndicator());
        },
        errorBuilder: (context, error, stackTrace) {
          return const Text("Error");
        },
        query: feedServices.fetchUsers(widget.user!.uid),
        itemBuilder: (context, doc) {
          final post = doc.data();
          return SizedBox(
              width: 100,
              // padding: const EdgeInsets.all(8.0),
              child: MiniProfileWidget(
                thisUser: post,
              ));
        },
      ),
    );
  }
}
