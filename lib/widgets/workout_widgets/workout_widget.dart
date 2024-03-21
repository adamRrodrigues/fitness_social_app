import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_social_app/models/workout_post_model.dart';
import 'package:fitness_social_app/routing/route_constants.dart';
import 'package:fitness_social_app/services/user_services.dart';
import 'package:fitness_social_app/widgets/custom_start_widget.dart';
import 'package:fitness_social_app/widgets/image_widget.dart';
import 'package:fitness_social_app/widgets/mini_profie.dart';
import 'package:fitness_social_app/widgets/pill_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class WorkoutWidget extends ConsumerWidget {
  const WorkoutWidget(
      {Key? key,
      required this.workoutModel,
      this.mini,
      this.day = 0,
      this.selection = false})
      : super(key: key);
  final WorkoutModel workoutModel;
  final bool? mini;
  final int day;
  final bool selection;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () async {
        if (selection) {
          context.pushNamed(RouteConstants.editWorkout,
              extra: {"workoutModel": workoutModel, "day": day});
        } else {
          context.pushNamed(RouteConstants.viewWorkoutScreen,
              extra: workoutModel);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: Material(
          elevation: 4,
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).colorScheme.surface,
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(10),
            ),
            // height: 500,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                    child: ImageWidget(url: workoutModel.imageUrl),
                  ),
                ),
                SizedBox(
                  height: 35,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: workoutModel.categories.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: PillWidget(
                            editable: false,
                            name: workoutModel.categories[index],
                            delete: () {},
                            active: false),
                      );
                    },
                  ),
                ),
                mini == false
                    ? MiniProfie(
                        userId: workoutModel.uid,
                        optionalSubText: workoutModel.workoutName,
                      )
                    : Container(),
                Builder(builder: (context) {
                  if (workoutModel.postId != workoutModel.templateId) {
                    return GestureDetector(
                        onTap: () {
                          context.pushNamed(
                              RouteConstants.fetchingWorkoutScreen,
                              extra: workoutModel.templateId);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "built from this template",
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(color: Colors.cyan),
                          ),
                        ));
                  }
                  return Container();
                }),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("${workoutModel.exercises.length} Exercises: "),
                ),
                ListView.builder(
                  itemCount: 2 > workoutModel.exercises.length
                      ? workoutModel.exercises.length
                      : 2,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return ListTile(
                      // leading: Icon(
                      //   Icons.circle,
                      // ),
                      // minLeadingWidth: 10,
                      dense: true,
                      title: Text(
                        workoutModel.exercises[index]['name'],
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
