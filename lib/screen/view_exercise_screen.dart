import 'package:fitness_social_app/models/exercise_model.dart';
import 'package:fitness_social_app/screen/view_video_screen.dart';
import 'package:fitness_social_app/widgets/image_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ViewExerciseScreen extends StatefulWidget {
  const ViewExerciseScreen({Key? key, required this.exerciseModel})
      : super(key: key);
  final ExerciseModel exerciseModel;

  @override
  State<ViewExerciseScreen> createState() => _ViewExerciseScreenState();
}

class _ViewExerciseScreenState extends State<ViewExerciseScreen> {
  VideoPlayerController? vController;
  @override
  void dispose() {
    super.dispose();
    try {
      vController!.dispose();
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        try {
          vController!.dispose();
        } catch (e) {}

        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.exerciseModel.name),
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Center(
                  child: SizedBox(
                    height: 400,
                    child: AspectRatio(
                        aspectRatio: 0.65,
                        child: Builder(builder: (context) {
                          if (widget.exerciseModel.imageUrl != "") {
                            try {
                              vController = VideoPlayerController.contentUri(
                                  Uri.parse(widget.exerciseModel.imageUrl),
                                  videoPlayerOptions:
                                      VideoPlayerOptions(mixWithOthers: true))
                                ..initialize().then((value) {
                                  vController!.setVolume(0);
                                  vController!.setLooping(true);
                                  vController!.pause();
                                });
                              if (!vController!.value.isInitialized) {
                                return Stack(
                                  children: [
                                    const Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          CircularProgressIndicator(),
                                          Text("Fetching Video Please Wait")
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
                                        child: AspectRatio(
                                          aspectRatio: 0.65,
                                          child: GestureDetector(
                                              onDoubleTap: () {
                                                // vController!.dispose();
                                                Navigator.push(context,
                                                    CupertinoPageRoute(
                                                  builder: (context) {
                                                    return ViewVideoScreen(
                                                        videoPlayerController:
                                                            vController!);
                                                  },
                                                ));
                                              },
                                              onTap: () {
                                                if (vController!
                                                    .value.isPlaying) {
                                                  vController!.pause();
                                                } else {
                                                  vController!.play();
                                                }
                                              },
                                              child: VideoPlayer(vController!)),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              } else {
                                return Container();
                              }
                            } catch (e) {
                              return const Center(
                                child: Icon(
                                  Icons.play_circle_outline_rounded,
                                  size: 64,
                                ),
                              );
                            }
                          } else {
                            return Center(
                              child: Text("This Exercise has no video"),
                            );
                          }
                        })),
                  ),
                ),
                Builder(
                  builder: (context) {
                    if (widget.exerciseModel.type == "sets") {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text(
                                widget.exerciseModel.weight.toString(),
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              Text(
                                "Weight",
                                style: Theme.of(context).textTheme.bodySmall,
                              )
                            ],
                          ),
                          Text(
                            "|",
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          Column(
                            children: [
                              Text(
                                widget.exerciseModel.sets.toString(),
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              Text(
                                "Sets",
                                style: Theme.of(context).textTheme.bodySmall,
                              )
                            ],
                          ),
                          Text(
                            "|",
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          Column(
                            children: [
                              Text(
                                widget.exerciseModel.reps.toString(),
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              Text(
                                "Reps",
                                style: Theme.of(context).textTheme.bodySmall,
                              )
                            ],
                          ),
                        ],
                      );
                    } else {
                      int hours = widget.exerciseModel.time ~/ 60;
                      int minutes = widget.exerciseModel.time % 60;
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text(
                                hours.toString(),
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              Text(
                                "Hrs",
                                style: Theme.of(context).textTheme.bodySmall,
                              )
                            ],
                          ),
                          Text(
                            "|",
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          Column(
                            children: [
                              Text(
                                minutes.toString(),
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              Text(
                                "Min",
                                style: Theme.of(context).textTheme.bodySmall,
                              )
                            ],
                          ),
                          Text(
                            "|",
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          Column(
                            children: [
                              Text(
                                0.toString(),
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              Text(
                                "Sec",
                                style: Theme.of(context).textTheme.bodySmall,
                              )
                            ],
                          ),
                        ],
                      );
                    }
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.exerciseModel.description,
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: null,
                    overflow: TextOverflow.clip,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
