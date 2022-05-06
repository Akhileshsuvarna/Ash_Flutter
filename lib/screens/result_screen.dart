import 'package:flutter/material.dart';
import 'package:health_connector/models/exercise_score.dart';
import '../constants.dart';

class ResultPage extends StatefulWidget {
  const ResultPage(
      {Key? key, required this.exerciseScore, required this.exerciseName})
      : super(key: key);

  final ExerciseScore exerciseScore;
  final String exerciseName;

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Constants.appBackgroundColor,
      appBar: AppBar(
        title: const Text("Score"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Exercise = ${widget.exerciseName}"),
            Text("Frames Processed = ${widget.exerciseScore.framesProcessed}"),
            Text(
                "Frames with Required Pose = ${widget.exerciseScore.framesWithRequiredPose}"),
            Text(
                "Frames with Random Pose = ${widget.exerciseScore.framesWithRandomPose}"),
            Text(
                "Frames without Pose = ${widget.exerciseScore.framesWithoutPose}"),
            Text(
                "Exercise Time = ${widget.exerciseScore.exerciseTimeAllotted} minutes"),
            Text(
                "Performance / Accuracy = ${(widget.exerciseScore.framesWithRequiredPose / widget.exerciseScore.framesProcessed) * 100}"),
          ],
        ),
      ),
    );
  }
}
