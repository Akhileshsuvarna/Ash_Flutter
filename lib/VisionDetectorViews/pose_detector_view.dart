import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:health_connector/enums/enums.dart';
import 'package:health_connector/log/logger.dart';
import 'package:health_connector/util/enum_utils.dart';
import 'package:health_connector/util/utils.dart';

import 'camera_view.dart';
import 'painters/pose_painter.dart';

class PoseDetectorView extends StatefulWidget {
  const PoseDetectorView({Key? key, required this.exerciseType})
      : super(key: key);
  final ExerciseType exerciseType;

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

    _startActivity();
  }

  @override
  void dispose() async {
    super.dispose();
    await poseDetector.close();
  }

  _startActivity() async {
    await _speak('Starting exercise');
    await _speak(EnumUtils.getName(widget.exerciseType)!);
    await _speak('in');
    await _speak('3');
    await _speak('2');
    await _speak('1');
  }

  Future _speak(String text) async {
    var result = await flutterTts.speak(text);
    Logger.debug(result);
  }

  @override
  Widget build(BuildContext context) => CameraView(
      title: 'Pose Detector',
      customPaint: customPaint,
      onImage: (inputImage) => processImage(inputImage));

  Future<void> processImage(InputImage inputImage) async {
    if (isBusy) return;
    isBusy = true;
    if (!_isMatched) {
      final List<Pose> poses = await poseDetector.processImage(inputImage);
      print('pose detecte ${poses.length}');
      if (poses.length == 1) {
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
        if (_isMatched) {
          // TODO-sikander ask team to check do we want to save image of last frame when pose detected (Team Says Good Idea (Save image))
          _speak('Congratulation cat cow position achieved');
          Future.delayed(const Duration(seconds: 3), () {
            print('its happening');
            Navigator.of(context).pop(true);
          });
        }
      } else {
        customPaint = null;
      }
    }
    }
    isBusy = false;
    if (mounted) {
      setState(() {});
    }
  }
}
