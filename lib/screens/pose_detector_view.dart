import 'dart:async';

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:health_connector/log/logger.dart';
import 'package:health_connector/models/exercise_meta.dart';
import 'package:health_connector/models/exercise_score.dart';
import 'package:health_connector/screens/add_exercise.dart';
import 'package:health_connector/screens/result_screen.dart';
import 'package:health_connector/util/enum_utils.dart';

import '../constants.dart';
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
  PoseDetector poseDetector = PoseDetector(options: PoseDetectorOptions());
  bool isBusy = false, _isMatched = false;
  CustomPaint? customPaint;
  String? _path;
  final ExerciseScore _eScore = ExerciseScore();
  late Timer _exerciseTime;
  final CountDownController _controller = CountDownController();

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
    if (_exerciseTime.isActive) {
      _exerciseTime.cancel();
    }
    // _controller.pause();
  }

  _startActivity() async {
    if (widget.addNew) {
      await Utils.speak(
          'Please press capture button when exercise pose acheived');
    } else {
      await Utils.speak(
          'Starting exercise ${EnumUtils.getName(widget.meta.title)}');
      _exerciseTime = Timer(Duration(minutes: widget.meta.exerciseDuration),
          _exerciseTimeElapsed);
      _eScore.exerciseTimeAllotted = widget.meta.exerciseDuration;
    }
    _controller.start();
  }

  _exerciseTimeElapsed() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => ResultPage(
          exerciseScore: _eScore,
          exerciseName: widget.meta.title,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      body: CameraView(
          customPaint: customPaint,
          onImage: (inputImage) => processImage(inputImage)),
      floatingActionButton: _floatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop);

  // Widget? _floatingActionButton() => SizedBox(
  //     height: 70.0,
  //     width: 70.0,
  //     child: FloatingActionButton(
  //         heroTag: 'capturePose',
  //         child: const Icon(Icons.screenshot_outlined),
  //         onPressed: _savePose));

  Widget? _floatingActionButton() => CircularCountDownTimer(
        // Countdown duration in Seconds.
        duration: widget.meta.exerciseDuration * 60,

        // Countdown initial elapsed Duration in Seconds.
        initialDuration: 0,

        // Controls (i.e Start, Pause, Resume, Restart) the Countdown Timer.
        controller: _controller,

        // Width of the Countdown Widget.
        width: MediaQuery.of(context).size.width / 8,

        // Height of the Countdown Widget.
        height: MediaQuery.of(context).size.height / 8,

        // Ring Color for Countdown Widget.
        ringColor: Colors.grey[300]!,

        // Ring Gradient for Countdown Widget.
        ringGradient: null,

        // Filling Color for Countdown Widget.
        fillColor: Constants.primaryColor,

        // Filling Gradient for Countdown Widget.
        fillGradient: null,

        // Background Color for Countdown Widget.
        backgroundColor: Colors.transparent,

        // Background Gradient for Countdown Widget.
        backgroundGradient: null,

        // Border Thickness of the Countdown Ring.
        strokeWidth: 8.0,

        // Begin and end contours with a flat edge and no extension.
        strokeCap: StrokeCap.round,

        // Text Style for Countdown Text.
        textStyle: const TextStyle(
          fontSize: 20.0,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),

        // Format for the Countdown Text.
        textFormat: CountdownTextFormat.S,

        // Handles Countdown Timer (true for Reverse Countdown (max to 0), false for Forward Countdown (0 to max)).
        isReverse: false,

        // Handles Animation Direction (true for Reverse Animation, false for Forward Animation).
        isReverseAnimation: false,

        // Handles visibility of the Countdown Text.
        isTimerTextShown: true,

        // Handles the timer start.
        autoStart: false,

        // This Callback will execute when the Countdown Starts.
        onStart: () {
          // Here, do whatever you want
          debugPrint('Countdown Started');
        },

        // This Callback will execute when the Countdown Ends.
        onComplete: () {
          // Here, do whatever you want
          debugPrint('Countdown Ended');
        },
      );

  Future<void> processImage(InputImage inputImage) async {
    if (isBusy) return;
    isBusy = true;
    // if (!_isMatched) {
    _eScore.framesProcessed++;
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
          _eScore.framesWithRequiredPose++;
          // _speak(
          //     '${EnumUtils.getName(widget.meta.title)!} position achieved');
          // TODO(skandar): Start Count Down Timer
        } else {
          _eScore.framesWithRandomPose++;
        }
      }
    } else {
      _eScore.framesWithoutPose++;
    }
    isBusy = false;
    // }
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
