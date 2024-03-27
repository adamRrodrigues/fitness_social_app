import 'package:fitness_social_app/screen/run_workou.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ViewVideoScreen extends StatelessWidget {
  const ViewVideoScreen({Key? key, required this.videoPlayerController})
      : super(key: key);
  final VideoPlayerController videoPlayerController;
  @override
  Widget build(BuildContext context) {
    videoPlayerController.play();
    return WillPopScope(
      onWillPop: () async {
        try {
          vController!.dispose();
        } catch (e) {}
        return true;
      },
      child: Scaffold(
          body: SafeArea(
            child: GestureDetector(
                onTap: () {
                  videoPlayerController.value.isPlaying
                      ? videoPlayerController.pause()
                      : videoPlayerController.play();
                },
                child: VideoPlayer(videoPlayerController)),
          )),
    );
  }
}
