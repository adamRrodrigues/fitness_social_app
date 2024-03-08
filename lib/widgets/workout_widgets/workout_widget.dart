import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_social_app/main.dart';
import 'package:fitness_social_app/models/routine_model.dart';
import 'package:fitness_social_app/models/workout_post_model.dart';
import 'package:fitness_social_app/routing/route_constants.dart';
import 'package:fitness_social_app/services/post_service.dart';
import 'package:fitness_social_app/services/routine_services.dart';
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
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Material(
            elevation: 8,
            color: Theme.of(context).colorScheme.surface,
            // borderRadius: BorderRadius.circular(10),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(10),
              ),
              // height: 500,
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    mini == false
                        ? StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('users')
                                .doc(workoutModel.uid)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData &&
                                  snapshot.connectionState ==
                                      ConnectionState.active) {
                                Map<String, dynamic> data = snapshot.data!
                                    .data() as Map<String, dynamic>;

                                final thisUser =
                                    UserServices().mapSingleUser(data);

                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: MiniProfie(
                                      userId: thisUser.uid,
                                      optionalSubText:
                                          '${workoutModel.createdAt.toDate().day.toString()}/${workoutModel.createdAt.toDate().month.toString()}/${workoutModel.createdAt.toDate().year.toString()} '),
                                );
                              } else if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const SizedBox(
                                    height: 50,
                                    child: Text(
                                      'loading...',
                                    ));
                              } else {
                                return const Text('Error Loading');
                              }
                            },
                          )
                        : Container(),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              // width: 220,
                              height: 40,
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                workoutModel.workoutName,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                        fontWeight: FontWeight.bold,
                                        overflow: TextOverflow.ellipsis),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                '${workoutModel.exercises.length.toString()} exercises',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(4),
                              child: CustomStarWidget(starValue: 4.5),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 150,
                          width: 150,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: ImageWidget(url: workoutModel.imageUrl),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
