import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:extended_image/extended_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_social_app/models/workout_post_model.dart';
import 'package:fitness_social_app/routing/route_constants.dart';
import 'package:fitness_social_app/screen/run_workou.dart';
import 'package:fitness_social_app/screen/view_exercise_screen.dart';
import 'package:fitness_social_app/services/post_service.dart';
import 'package:fitness_social_app/widgets/custom_button.dart';
import 'package:fitness_social_app/widgets/image_widget.dart';
import 'package:fitness_social_app/widgets/pill_widget.dart';
import 'package:fitness_social_app/widgets/workout_widgets/exercise_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

class ViewWorkout extends StatelessWidget {
  const ViewWorkout({Key? key, required this.workoutModel}) : super(key: key);
  final WorkoutModel workoutModel;
  // final String postId;
  @override
  Widget build(BuildContext context) {
    final imageProvider = MultiImageProvider(
        [ExtendedImage.network(workoutModel.imageUrl).image]);

    User? user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: Text(workoutModel.workoutName),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                      height: 300,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: GestureDetector(
                          onTap: () {
                            showImageViewerPager(context, imageProvider);
                          },
                          child: ImageWidget(url: workoutModel.imageUrl)))
                  .animate()
                  .shimmer(),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 35,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: workoutModel.categories.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: PillWidget(
                                editable: false,
                                delete: () {},
                                name: workoutModel.categories[index],
                                active: false),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            workoutModel.exercises.isNotEmpty
                ? ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: workoutModel.exercises.length,
                    itemBuilder: (context, index) {
                      final exerciseModel = WorkoutPostServices()
                          .mapExercise(workoutModel.exercises[index]);
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(context, CupertinoPageRoute(
                            builder: (context) {
                              return ViewExerciseScreen(
                                  exerciseModel: exerciseModel);
                            },
                          ));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: ExerciseWidget(exerciseModel: exerciseModel),
                        ).animate().shimmer(),
                      );
                    },
                  )
                : const Text('Any exercises you add will appear here')
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
          height: 60,
          padding: const EdgeInsets.all(8),
          color: Colors.transparent,
          elevation: 0,
          child: GestureDetector(
            onTap: () {
              context.pushNamed(RouteConstants.editWorkout,
                  extra: {"workoutModel": workoutModel, "day": 69});
            },
            child: CustomButton(
                buttonText: user!.uid != workoutModel.uid
                    ? 'Create Workout From This Template'
                    : "Edit Workout"),
          )),
    );
  }
}
