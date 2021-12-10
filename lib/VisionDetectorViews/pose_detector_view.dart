import 'package:Health_Connector/util/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

import 'camera_view.dart';
import 'painters/pose_painter.dart';

class PoseDetectorView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PoseDetectorViewState();
}

const List<Pose> xyz = [];

class _PoseDetectorViewState extends State<PoseDetectorView> {
  PoseDetector poseDetector = GoogleMlKit.vision.poseDetector();
  bool isBusy = false;
  CustomPaint? customPaint;
  FlutterTts flutterTts = FlutterTts();
  bool _isMatched = false;

  @override
  void initState() {
    super.initState();

    _speak('Starting exercise');
    _speak('cat cow ');
    _speak('in');
    _speak('3');
    _speak('2');
    _speak('1');
  }

  @override
  void dispose() async {
    super.dispose();
    await poseDetector.close();
  }

  Future _speak(String text) async {
    var result = await flutterTts.speak(text);
    print(result);
  }

  @override
  Widget build(BuildContext context) => CameraView(
      title: 'Pose Detector',
      customPaint: customPaint,
      onImage: (inputImage) => processImage(inputImage));

  Future<void> processImage(InputImage inputImage) async {
    if (isBusy) return;
    isBusy = true;
    // if (!_isMatched) {
    final List<Pose> poses = await poseDetector.processImage(inputImage);
    // if (poses.length == 1) {
    if (inputImage.inputImageData?.size != null &&
        inputImage.inputImageData?.imageRotation != null) {
      // TODO-Sikander
      // compare pose here to check if Pose match with excersie pose
      if (poses.length == 1) {
        _isMatched = Utils.isCatPose(poses[0]);
      }
      Color paintColor = _isMatched ? Colors.green : Colors.white;
      final painter = PosePainter(poses, inputImage.inputImageData!.size,
          inputImage.inputImageData!.imageRotation, paintColor);
      customPaint = CustomPaint(painter: painter);
      // if (_isMatched) {
      //   _speak('Congratulation cat cow position achieved');
      // }
    } else {
      customPaint = null;
    }
    // }
    // }
    isBusy = false;
    if (mounted) {
      setState(() {});
    }
  }
}
