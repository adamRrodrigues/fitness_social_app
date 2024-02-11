import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_social_app/main.dart';
import 'package:fitness_social_app/models/routine_model.dart';
import 'package:fitness_social_app/models/workout_post_model.dart';
import 'package:fitness_social_app/routing/route_constants.dart';
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
    Routine routine = ref.read(routineProvider);

    User? user = FirebaseAuth.instance.currentUser;
    return GestureDetector(
      onTap: () {
        if (selection) {
          routine.addToRoutine(day, workoutModel);
          RoutineServices().updateRoutine(user!.uid, day, workoutModel.postId);
          print(routine.routines[day].workouts);
          if (context.mounted) {
            context.pop();
          }
        } else {
          context.pushNamed(RouteConstants.viewWorkoutScreen,
              extra: workoutModel, pathParameters: {'id': workoutModel.postId});
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Material(
          elevation: 4,
          color: Theme.of(context).colorScheme.secondary,
          // borderRadius: BorderRadius.circular(10),
          child: Container(
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                // borderRadius: BorderRadius.circular(10),
                border: Border(
                    bottom: BorderSide(
                        color: Theme.of(context).colorScheme.primary))),
            // height: 500,
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  mini == false
                      ?
                      // ? StreamBuilder(
                      //     stream: FirebaseFirestore.instance
                      //         .collection('users')
                      //         .doc(workoutModel.uid)
                      //         .snapshots(),
                      //     builder: (context, snapshot) {
                      //       if (snapshot.hasData &&
                      //           snapshot.connectionState ==
                      //               ConnectionState.active) {
                      //         Map<String, dynamic> data =
                      //             snapshot.data!.data() as Map<String, dynamic>;

                      //         final thisUser =
                      //             UserServices().mapSingleUser(data);

                      //         return Padding(
                      //           padding: const EdgeInsets.all(8.0),
                      //           child: MiniProfie(
                      //               user: thisUser,
                      //               optionalSubText:
                      //                   '${workoutModel.createdAt.toDate().day.toString()}/${workoutModel.createdAt.toDate().month.toString()}/${workoutModel.createdAt.toDate().year.toString()} '),
                      //         );
                      //       } else if (snapshot.connectionState ==
                      //           ConnectionState.waiting) {
                      //         return const SizedBox(
                      //             height: 50,
                      //             child: Text(
                      //               'loading...',
                      //             ));
                      //       } else {
                      //         return const Text('Error Loading');
                      //       }
                      //     },
                      //   )
                      Container()
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
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              workoutModel.workoutName,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(fontWeight: FontWeight.bold),
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
    );
  }
}
