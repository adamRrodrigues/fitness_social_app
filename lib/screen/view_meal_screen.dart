import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:fitness_social_app/models/meal_model.dart';
import 'package:fitness_social_app/widgets/image_widget.dart';
import 'package:fitness_social_app/widgets/pill_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ViewMealScreen extends StatefulWidget {
  const ViewMealScreen({Key? key, required this.mealModel}) : super(key: key);
  final MealModel mealModel;
  @override
  _ViewMealScreenState createState() => _ViewMealScreenState();
}

class _ViewMealScreenState extends State<ViewMealScreen> {
  @override
  Widget build(BuildContext context) {
    ImageProvider image = Image.network(widget.mealModel.image).image;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.mealModel.mealName),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => showImageViewer(context, image),
              child: SizedBox(
                height: 300,
                width: double.infinity,
                child: ImageWidget(url: widget.mealModel.image),
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
            Text(
              widget.mealModel.description,
              style: Theme.of(context).textTheme.titleSmall,
              maxLines: 4,
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text("Ingredients:", style: Theme.of(context).textTheme.titleMedium,),
            ),
            ListView.builder(
              itemCount: widget.mealModel.ingredients.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Animate(
                  effects: const [SlideEffect()],
                  child: ListTile(
                    dense: true,
                    title: Text(
                      widget.mealModel.ingredients[index],
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
