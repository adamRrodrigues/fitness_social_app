import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraService extends StatefulWidget {
  const CameraService({Key? key}) : super(key: key);

  @override
  _CameraServiceState createState() => _CameraServiceState();
}

class _CameraServiceState extends State<CameraService> {
  late CameraController controller;

  @override
  void initState() {
    super.initState();
    controller = CameraController(
        const CameraDescription(
            name: 'camera',
            lensDirection: CameraLensDirection.back,
            sensorOrientation: 0),
        ResolutionPreset.max);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }
    return MaterialApp(
      home: CameraPreview(controller),
    );
  }
}