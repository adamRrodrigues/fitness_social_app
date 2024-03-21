import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:fitness_social_app/models/meal_model.dart';
import 'package:fitness_social_app/routing/route_constants.dart';
import 'package:fitness_social_app/widgets/custom_button.dart';
import 'package:fitness_social_app/widgets/meal_widgets/meal_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MealFeed extends StatefulWidget {
  const MealFeed(
      {super.key,
      required this.postQuery,
      this.horizontal = false,
      this.add = false,
      this.profileView = false,
      this.noPostsMessage = "Nothing to see here"});

  final Query<MealModel> postQuery;
  final bool? profileView;
  final bool add;
  final String noPostsMessage;
  final bool horizontal;

  @override
  State<MealFeed> createState() => _MealFeedState();
}

class _MealFeedState extends State<MealFeed> {
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      if (!widget.horizontal) {
        return FirestoreListView<MealModel>(
          pageSize: 5,
          shrinkWrap: true,
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          emptyBuilder: (context) {
            return Center(
              child: Text(widget.noPostsMessage),
            );
          },
          loadingBuilder: (context) {
            return const Center(child: CircularProgressIndicator());
          },
          errorBuilder: (context, error, stackTrace) {
            return ListView(children: [
              const Center(
                child: Text(
                    'There was a problem loading the feed please try again'),
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
              child: GestureDetector(
                onTap: () {
                  if (widget.add) {
                    
                  } else {
                    context.pushNamed(RouteConstants.viewMealScreen,
                        extra: post);
                  }
                },
                child: MealWidget(
                  meal: post,
                ),
              ),
            );
          },
        );
      } else {
        return FirestoreListView<MealModel>(
          pageSize: 5,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          emptyBuilder: (context) {
            return Center(
              child: Text(widget.noPostsMessage),
            );
          },
          loadingBuilder: (context) {
            return const Center(child: CircularProgressIndicator());
          },
          errorBuilder: (context, error, stackTrace) {
            return ListView(children: [
              const Center(
                child: Text(
                    'There was a problem loading the feed please try again'),
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
            return Container(
              width: 400,
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  if (widget.add) {
                  } else {
                    context.pushNamed(RouteConstants.viewMealScreen,
                        extra: post);
                  }
                },
                child: MealWidget(
                  meal: post,
                ),
              ),
            );
          },
        );
      }
    });
  }
}
