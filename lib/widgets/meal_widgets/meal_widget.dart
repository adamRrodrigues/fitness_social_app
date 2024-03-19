import 'package:fitness_social_app/models/meal_model.dart';
import 'package:fitness_social_app/widgets/image_widget.dart';
import 'package:fitness_social_app/widgets/mini_profie.dart';
import 'package:flutter/material.dart';

class MealWidget extends StatelessWidget {
  const MealWidget({Key? key, required this.meal}) : super(key: key);
  final MealModel meal;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Material(
          // borderRadius: BorderRadius.circular(10),
          elevation: 4,
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
                      borderRadius: BorderRadius.only(
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
                  Builder(builder: (context) {
                    if (meal.ingredients.length < 4) {
                      return ListView.builder(
                        itemCount: meal.ingredients.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: Icon(
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
                      );
                    } else {
                      return ListView.builder(
                        itemCount: 3,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: Icon(
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
                      );
                    }
                  })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
