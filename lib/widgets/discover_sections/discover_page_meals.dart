import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:fitness_social_app/main.dart';
import 'package:fitness_social_app/screen/run_workou.dart';
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
    User? user = FirebaseAuth.instance.currentUser;

    return SizedBox(
      height: 450,
      child: FirestoreListView(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        pageSize: 5,
        addAutomaticKeepAlives: true,
        physics: const BouncingScrollPhysics(),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        emptyBuilder: (context) {
          return const Center(
            child: Text("No Meals Exist"),
          );
        },
        loadingBuilder: (context) {
          return const Center(child: CircularProgressIndicator());
        },
        errorBuilder: (context, error, stackTrace) {
          return const Text("Error");
        },
        query: feedServices.fetchAllMeals(user!.uid),
        itemBuilder: (context, doc) {
          final post = doc.data();
          return SizedBox(
              width: 400,
              child: MealWidget(
                meal: post,
              ));
        },
      ),
    );
  }
}
