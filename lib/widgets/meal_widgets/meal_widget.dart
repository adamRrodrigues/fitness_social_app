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

class MealWidget extends ConsumerWidget {
  const MealWidget({Key? key, required this.meal}) : super(key: key);
  final MealModel meal;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    User? user = ref.read(userProvider);
    return GestureDetector(
      onTap: () {
        context.pushNamed(RouteConstants.viewMealScreen, extra: meal);
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
                  meal.uid == user!.uid
                      ? GestureDetector(
                          onTap: () {
                            context.pop();
                            MealServices().deleteMeal(meal.postId);
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
          elevation: 4,
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
                  SizedBox(
                    height: 200,
                    width: double.infinity,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10)),
                      child: ImageWidget(url: meal.image),
                    ),
                  ),
                  MiniProfie(
                    userId: meal.uid,
                    optionalSubText: meal.mealName,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  ListView.builder(
                    itemCount: 3 > meal.ingredients.length
                        ? meal.ingredients.length
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
                          meal.ingredients[index],
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
