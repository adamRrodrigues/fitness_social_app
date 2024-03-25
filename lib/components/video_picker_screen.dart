import 'dart:io';

import 'package:fitness_social_app/main.dart';
import 'package:fitness_social_app/services/drafts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class VideoPickerScreen extends ConsumerStatefulWidget {
  const VideoPickerScreen({Key? key}) : super(key: key);

  @override
  _VideoPickerScreenState createState() => _VideoPickerScreenState();
}

class _VideoPickerScreenState extends ConsumerState<VideoPickerScreen> {
  VideoPlayerController? vController;
  XFile? video;
  File? finalVideo;
  WorkoutDraft? workoutDraft;
  @override
  void initState() {
    super.initState();
    workoutDraft = ref.read(draftProvider);
  }

  void selectImage() async {
    try {
      video = await ImagePicker().pickVideo(source: ImageSource.gallery);
      finalVideo = File(video!.path);
      vController = VideoPlayerController.file(finalVideo!)
        ..initialize().then((value) {
          setState(() {});

          vController!.setLooping(true);
          vController!.play();
        });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        try {
          await vController!.dispose();
        } catch (e) {}
        return true;
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                selectImage();
              },
              child: Center(
                child: Container(
                  height: 500,
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: 2,
                          color: Theme.of(context).colorScheme.secondary),
                      borderRadius: BorderRadius.circular(10)),
                  child: AspectRatio(
                    aspectRatio: 0.55,
                    child: video == null
                        ? const Center(
                            child: Icon(
                              Icons.play_circle_outline_rounded,
                              size: 64,
                            ),
                          )
                        : vController!.value.isInitialized
                            ? GestureDetector(
                                onTap: () {
                                  vController!.value.isPlaying
                                      ? vController!.pause()
                                      : vController!.play();
                                },
                                onLongPress: () => selectImage(),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: VideoPlayer(vController!)),
                              )
                            : Container(),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
