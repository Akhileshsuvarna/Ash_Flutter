import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:health_connector/log/logger.dart';
import 'package:health_connector/main.dart';
import 'package:health_connector/models/exercise_meta.dart';
import 'package:health_connector/screens/add_exercise.dart';
import 'package:health_connector/util/enum_utils.dart';

import '../util/utils.dart';
import 'camera_view.dart';
import 'painters/pose_painter.dart';

class PoseDetectorView extends StatefulWidget {
  const PoseDetectorView({Key? key, required this.meta, this.addNew = false})
      : super(key: key);
  final ExerciseMeta meta;
  final bool addNew;

  @override
  State<StatefulWidget> createState() => _PoseDetectorViewState();
}

class _PoseDetectorViewState extends State<PoseDetectorView> {
  PoseDetector poseDetector = GoogleMlKit.vision.poseDetector();
  bool isBusy = false, _isMatched = false;
  CustomPaint? customPaint;
  FlutterTts flutterTts = FlutterTts();
  String? _path;

  @override
  void initState() {
    super.initState();
    isBusy = false;
    _startActivity();
  }

  @override
  void dispose() async {
    super.dispose();
    await poseDetector.close();
    isBusy = false;
  }

  _startActivity() async {
    if (widget.addNew) {
      await _speak('Please press capture button when exercise pose acheived');
    } else {
      await _speak('Starting exercise ${EnumUtils.getName(widget.meta.title)}');
    }
  }

  Future _speak(String text) async {
    var result = await flutterTts.speak(text);
    Logger.debug(result);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      body: CameraView(
          customPaint: customPaint,
          onImage: (inputImage) => processImage(inputImage)),
      floatingActionButton: _floatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat);

  Widget? _floatingActionButton() => SizedBox(
      height: 70.0,
      width: 70.0,
      child: FloatingActionButton(
          heroTag: 'capturePose',
          child: const Icon(Icons.screenshot_outlined),
          onPressed: _savePose));

  Future<void> processImage(InputImage inputImage) async {
    if (isBusy) return;
    isBusy = true;
    if (!_isMatched) {
      final List<Pose> poses = await poseDetector.processImage(inputImage);
      // Logger.debug('pose detecte ${poses.length}');
      if (poses.length == 1) {
        if (inputImage.inputImageData?.size != null &&
            inputImage.inputImageData?.imageRotation != null) {
          customPaint = _getSkeltonPaint(poses, inputImage);

          if (widget.addNew) {
            if (_path != null) {
              Logger.debug('Exercise Saved');
              _addExercise(poses[0], customPaint!, _path!);
              _isMatched = true;
            }
          } else {
            _isMatched = _isPoseMatched(poses[0], inputImage);
          }

          if (_isMatched && !widget.addNew) {
            _speak(
                'Congratulation ${EnumUtils.getName(widget.meta.title)!} position achieved');
            Future.delayed(const Duration(seconds: 3),
                () => Navigator.of(context).pop(true));
          }
        }
      }
      isBusy = false;
    }
    if (mounted) {
      setState(() {});
    }
  }

  CustomPaint _getSkeltonPaint(List<Pose> poses, InputImage inputImage) {
    Color paintColor = _isMatched ? Colors.green : Colors.white;
    var paint = PosePainter(poses, inputImage.inputImageData!.size,
        inputImage.inputImageData!.imageRotation, paintColor);
    return CustomPaint(painter: paint);
  }

  bool _isPoseMatched(Pose pose, InputImage inputImage) {
    // TODO(Skandar): Match pose here
    // pose.landmarks.entries.forEach((element) {
    //   // element.value.type.
    // });
    // return false;
    print(pose.landmarks);
    if (widget.meta.title.toLowerCase().contains("cat")) {
      return Utils.isCatPose(pose);
    } else if (widget.meta.title.toLowerCase().contains("sphinx")) {
      return Utils.isSphinxPose(pose);
    } else if (widget.meta.title.toLowerCase().contains("plank")) {
      return Utils.isPlankPose(pose);
    } else {
      return false;
    }
  }

  void _savePose() {
    // cameraController!.takePicture().then((value) {
    //   setState(() {
    //     _path = value.path;
    //   });
    // });
  }

  void _addExercise(Pose pose, CustomPaint customPaint, String path) =>
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const AddExercise()));
}
