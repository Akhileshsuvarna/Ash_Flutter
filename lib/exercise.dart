import 'package:google_ml_kit/google_ml_kit.dart';

class Exercise {
  // Pose pose = new Pose(landmarks);

  // var landmark = poseLandmarkFromMap(point);

  static poseLandmarkFromMap(Map<dynamic, dynamic> data) {
    return PoseLandmark(PoseLandmarkType.values[data['type']], data['x'],
        data['y'], data['z'], data['likelihood'] ?? 0.0);
  }
}
