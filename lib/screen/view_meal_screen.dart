import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_social_app/models/meal_model.dart';
import 'package:fitness_social_app/routing/route_constants.dart';
import 'package:fitness_social_app/widgets/custom_button.dart';
import 'package:fitness_social_app/widgets/image_widget.dart';
import 'package:fitness_social_app/widgets/pill_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ViewMealScreen extends StatefulWidget {
  const ViewMealScreen({Key? key, required this.mealModel}) : super(key: key);
  final MealModel mealModel;
  @override
  _ViewMealScreenState createState() => _ViewMealScreenState();
}

class _ViewMealScreenState extends State<ViewMealScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    ImageProvider image = Image.network(widget.mealModel.image).image;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.mealModel.mealName),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () => showImageViewer(context, image),
                child: SizedBox(
                  height: 300,
                  width: double.infinity,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: ImageWidget(url: widget.mealModel.image)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text("Calories: ${widget.mealModel.calories.toString()}"),
                  Text("Servings: ${widget.mealModel.servings.toString()}")
                ],
              ),
            ),
            SizedBox(
              height: 40,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.mealModel.tags.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: PillWidget(
                      name: widget.mealModel.tags[index],
                      active: false,
                      editable: false,
                      delete: () {},
                    ),
                  );
                },
              ),
            ),
            TabBar(
              indicatorColor: Theme.of(context).colorScheme.primary,
              tabs: [
                Tab(
                    icon: Icon(
                  Icons.food_bank_outlined,
                  color: Theme.of(context).colorScheme.secondary,
                )),
                Tab(
                    icon: Icon(
                  Icons.list_rounded,
                  color: Theme.of(context).colorScheme.secondary,
                )),
              ],
            ),
            Expanded(
              child:
                  TabBarView(physics: const BouncingScrollPhysics(), children: [
                ListView.builder(
                  itemCount: widget.mealModel.ingredients.length,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Text("${index + 1})"),
                      leadingAndTrailingTextStyle:
                          Theme.of(context).textTheme.titleSmall,
                      horizontalTitleGap: 2,
                      titleTextStyle: Theme.of(context).textTheme.titleSmall,
                      title: Text(
                        widget.mealModel.ingredients[index],
                      ),
                    );
                  },
                ),
                ListView.builder(
                  itemCount: widget.mealModel.steps.length,
                  shrinkWrap: true,
                  // physics: const NeverScrollableScrollPhysics(),
                  physics: const BouncingScrollPhysics(),

                  itemBuilder: (context, index) {
                    return ListTile(
                      dense: true,
                      title: Text(
                        widget.mealModel.steps[index],
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    );
                  },
                )
              ]),
            ),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          height: 60,
          padding: const EdgeInsets.all(8),
          color: Colors.transparent,
          elevation: 0,
          child: GestureDetector(
              onTap: () {
                MealModel meal = widget.mealModel;
                context.pushReplacementNamed(RouteConstants.editMeal,
                    extra: meal);
              },
              child: CustomButton(
                  buttonText: widget.mealModel.uid == user!.uid
                      ? 'Edit Meal'
                      : "Create Meal From This Template")),
        ),
      ),
    );
  }
}
