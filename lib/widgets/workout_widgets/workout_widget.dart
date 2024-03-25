import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_social_app/main.dart';
import 'package:fitness_social_app/models/workout_post_model.dart';
import 'package:fitness_social_app/routing/route_constants.dart';
import 'package:fitness_social_app/services/post_service.dart';
import 'package:fitness_social_app/services/routine_services.dart';
import 'package:fitness_social_app/widgets/bottom_modal_item_widget.dart';
import 'package:fitness_social_app/widgets/image_widget.dart';
import 'package:fitness_social_app/widgets/mini_profie.dart';
import 'package:fitness_social_app/widgets/pill_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class WorkoutWidget extends ConsumerStatefulWidget {
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
  _WorkoutWidgetState createState() => _WorkoutWidgetState();
}

class _WorkoutWidgetState extends ConsumerState<WorkoutWidget> {
  User? user;
  bool liked = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = ref.read(userProvider);
    liked = widget.workoutModel.likes.contains(user!.uid);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (widget.selection) {
          if (user!.uid == widget.workoutModel.uid) {
            RoutineServices().updateRoutine(user!.uid, widget.day,
                widget.workoutModel.postId, widget.workoutModel.templateId);
          } else {
            context.pushNamed(RouteConstants.editWorkout, extra: {
              "workoutModel": widget.workoutModel,
              "day": widget.day
            });
          }
        } else {
          context.pushNamed(RouteConstants.viewWorkoutScreen,
              extra: widget.workoutModel);
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
                  widget.workoutModel.uid == user!.uid
                      ? GestureDetector(
                          onTap: () async {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              },
                            );
                            await WorkoutPostServices()
                                .deletePost(widget.workoutModel.postId);
                            if (context.mounted) {
                              context.pop();
                            }
                          },
                          child: const BottomModalItem(
                            text: "Delete This Post",
                            iconRequired: true,
                            icon: Icons.delete_rounded,
                          ))
                      : Container(),
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
                Stack(
                  children: [
                    SizedBox(
                      height: 200,
                      width: double.infinity,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10)),
                        child: ImageWidget(url: widget.workoutModel.imageUrl),
                      ),
                    ),
                    widget.workoutModel.postId == widget.workoutModel.templateId
                        ? Positioned(
                            right: 0,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  liked = !liked;

                                  WorkoutPostServices().addToSavedWorkouts(
                                      user!.uid,
                                      widget.workoutModel.templateId,
                                      liked);
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    liked
                                        ? const Icon(Icons.bookmark_rounded)
                                        : const Icon(
                                            Icons.bookmark_outline_rounded),
                                    Text(widget.workoutModel.likeCount
                                        .toString())
                                  ],
                                ),
                              ),
                            ),
                          )
                        : Container()
                  ],
                ),
                SizedBox(
                  height: 35,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.workoutModel.categories.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: PillWidget(
                            editable: false,
                            name: widget.workoutModel.categories[index],
                            delete: () {},
                            active: false),
                      );
                    },
                  ),
                ),
                widget.mini == false
                    ? MiniProfie(
                        userId: widget.workoutModel.uid,
                      )
                    : Container(),
                Builder(builder: (context) {
                  if (widget.workoutModel.postId !=
                      widget.workoutModel.templateId) {
                    return GestureDetector(
                        onTap: () {
                          context.pushNamed(
                              RouteConstants.fetchingWorkoutScreen,
                              extra: widget.workoutModel.templateId);
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
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.workoutModel.workoutName,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:
                      Text("${widget.workoutModel.exercises.length} Exercises"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
