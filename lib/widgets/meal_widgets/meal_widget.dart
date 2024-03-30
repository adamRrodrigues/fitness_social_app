import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_social_app/main.dart';
import 'package:fitness_social_app/models/meal_model.dart';
import 'package:fitness_social_app/routing/route_constants.dart';
import 'package:fitness_social_app/services/meal_service.dart';
import 'package:fitness_social_app/widgets/bottom_modal_item_widget.dart';
import 'package:fitness_social_app/widgets/image_widget.dart';
import 'package:fitness_social_app/widgets/mini_profie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MealWidget extends ConsumerStatefulWidget {
  const MealWidget(
      {Key? key, required this.meal, this.selection = false, this.day = 0})
      : super(key: key);
  final MealModel meal;
  final bool selection;
  final int day;

  @override
  _MealWidgetState createState() => _MealWidgetState();
}

class _MealWidgetState extends ConsumerState<MealWidget> {
  User? user;
  bool isLiked = false;
  int likes = 0;

  @override
  void initState() {
    super.initState();
    user = ref.read(userProvider);
    isLiked = widget.meal.likes.contains(user!.uid);
    likes = widget.meal.likes.length;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (widget.selection == true) {
          await FirebaseFirestore.instance
              .collection("routines")
              .doc(user!.uid)
              .collection("day ${widget.day}")
              .doc("meals")
              .update({
            "meals": FieldValue.arrayUnion([widget.meal.postId])
          });
          context.pop();
        } else {
          context.pushNamed(RouteConstants.viewMealScreen, extra: widget.meal);
        }
      },
      onLongPress: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          showDragHandle: true,
          useSafeArea: true,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
          builder: (context) {
            return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: ListView(
                shrinkWrap: true,
                children: [
                  widget.meal.uid == user!.uid
                      ? GestureDetector(
                          onTap: () {
                            context.pop();
                            MealServices().deleteMeal(widget.meal.postId);
                          },
                          child: const BottomModalItem(
                            text: "Delete This Post",
                            iconRequired: true,
                            icon: Icons.delete_rounded,
                          ))
                      : Container(),
                  const Divider(),
                  GestureDetector(
                      onTap: () {
                        context.pop();
                      },
                      child: const BottomModalItem(
                        text: "Share",
                        iconRequired: true,
                        icon: Icons.share_rounded,
                      ))
                ],
              ),
            );
          },
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Material(
          elevation: 2,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).colorScheme.surface),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      SizedBox(
                        height: 200,
                        width: double.infinity,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10)),
                          child: ImageWidget(url: widget.meal.image),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              MealServices().saveMeal(
                                  user!.uid, widget.meal.postId, isLiked);
                              isLiked = !isLiked;
                              isLiked ? likes++ : likes--;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                isLiked
                                    ? Icon(
                                        Icons.bookmark_rounded,
                                        size: 32,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      )
                                    : Icon(
                                        Icons.bookmark_outline_rounded,
                                        size: 32,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                Text(
                                  likes.toString(),
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  MiniProfie(
                    userId: widget.meal.uid,
                    optionalSubText: widget.meal.mealName,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  ListView.builder(
                    itemCount: 3 > widget.meal.ingredients.length
                        ? widget.meal.ingredients.length
                        : 3,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: const Icon(
                          Icons.circle,
                        ),
                        minLeadingWidth: 10,
                        dense: true,
                        title: Text(
                          widget.meal.ingredients[index],
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ).animate().shimmer(),
    );
  }
}
