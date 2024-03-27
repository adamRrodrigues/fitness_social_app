import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:fitness_social_app/main.dart';
import 'package:fitness_social_app/services/feed_services.dart';
import 'package:fitness_social_app/widgets/meal_widgets/meal_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DiscoverPageMeals extends ConsumerStatefulWidget {
  const DiscoverPageMeals({
    super.key,
    required this.user,
  });

  final User? user;

  @override
  _DiscoverPageMealsState createState() => _DiscoverPageMealsState();
}

class _DiscoverPageMealsState extends ConsumerState<DiscoverPageMeals> {
  @override
  Widget build(BuildContext context) {
    FeedServices feedServices = ref.read(feedServicesProvider);

    return SizedBox(
      height: 420,
      child: FirestoreListView(
        scrollDirection: Axis.horizontal,
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
        query: feedServices.fetchMeals(),
        itemBuilder: (context, doc) {
          final post = doc.data();
          return Container(
              width: 400,
              // padding: const EdgeInsets.all(8.0),
              child: MealWidget(
                meal: post,
              ));
        },
      ),
    );
  }
}
