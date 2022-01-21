import 'package:google_ml_kit/google_ml_kit.dart';

class PoseData {
  late PoseLandmark nose;
  late PoseLandmark leftEyeInner;
  late PoseLandmark leftEye;
  late PoseLandmark leftEyeOuter;
  late PoseLandmark rightEyeInner;
  late PoseLandmark rightEye;
  late PoseLandmark rightEyeOuter;
  late PoseLandmark leftEar;
  late PoseLandmark rightEar;
  late PoseLandmark leftMouth;
  late PoseLandmark rightMouth;
  late PoseLandmark leftShoulder;
  late PoseLandmark rightShoulder;
  late PoseLandmark leftElbow;
  late PoseLandmark rightElbow;
  late PoseLandmark leftWrist;
  late PoseLandmark rightWrist;
  late PoseLandmark leftPinky;
  late PoseLandmark rightPinky;
  late PoseLandmark leftIndex;
  late PoseLandmark rightIndex;
  late PoseLandmark leftThumb;
  late PoseLandmark rightThumb;
  late PoseLandmark leftHip;
  late PoseLandmark rightHip;
  late PoseLandmark leftKnee;
  late PoseLandmark rightKnee;
  late PoseLandmark leftAnkle;
  late PoseLandmark rightAnkle;
  late PoseLandmark leftHeel;
  late PoseLandmark rightHeel;
  late PoseLandmark leftFootIndex;
  late PoseLandmark rightFootIndex;

  PoseData.fromMap(Map<PoseLandmarkType, PoseLandmark> landmarks) {
    landmarks.forEach((key, value) {
      if (key == PoseLandmarkType.nose) {
        nose = value;
      } else if (key == PoseLandmarkType.leftEyeInner) {
        leftEyeInner = value;
      } else if (key == PoseLandmarkType.leftEye) {
        leftEye = value;
      } else if (key == PoseLandmarkType.leftEyeOuter) {
        leftEyeOuter = value;
      } else if (key == PoseLandmarkType.rightEyeInner) {
        rightEyeInner = value;
      } else if (key == PoseLandmarkType.rightEye) {
        rightEye = value;
      } else if (key == PoseLandmarkType.rightEyeOuter) {
        rightEyeOuter = value;
      } else if (key == PoseLandmarkType.leftEar) {
        leftEar = value;
      } else if (key == PoseLandmarkType.rightEar) {
        rightEar = value;
      } else if (key == PoseLandmarkType.leftMouth) {
        leftMouth = value;
      } else if (key == PoseLandmarkType.rightMouth) {
        rightMouth = value;
      } else if (key == PoseLandmarkType.leftShoulder) {
        leftShoulder = value;
      } else if (key == PoseLandmarkType.rightShoulder) {
        rightShoulder = value;
      } else if (key == PoseLandmarkType.leftElbow) {
        leftElbow = value;
      } else if (key == PoseLandmarkType.rightElbow) {
        rightElbow = value;
      } else if (key == PoseLandmarkType.leftWrist) {
        leftWrist = value;
      } else if (key == PoseLandmarkType.rightWrist) {
        rightWrist = value;
      } else if (key == PoseLandmarkType.leftPinky) {
        leftPinky = value;
      } else if (key == PoseLandmarkType.rightPinky) {
        rightPinky = value;
      } else if (key == PoseLandmarkType.leftIndex) {
        leftIndex = value;
      } else if (key == PoseLandmarkType.rightIndex) {
        rightIndex = value;
      } else if (key == PoseLandmarkType.leftThumb) {
        leftThumb = value;
      } else if (key == PoseLandmarkType.rightThumb) {
        rightThumb = value;
      } else if (key == PoseLandmarkType.leftHip) {
        leftHip = value;
      } else if (key == PoseLandmarkType.rightHip) {
        rightHip = value;
      } else if (key == PoseLandmarkType.leftKnee) {
        leftKnee = value;
      } else if (key == PoseLandmarkType.rightKnee) {
        rightKnee = value;
      } else if (key == PoseLandmarkType.leftAnkle) {
        leftAnkle = value;
      } else if (key == PoseLandmarkType.rightAnkle) {
        rightAnkle = value;
      } else if (key == PoseLandmarkType.leftHeel) {
        leftHeel = value;
      } else if (key == PoseLandmarkType.rightHeel) {
        rightHeel = value;
      } else if (key == PoseLandmarkType.leftFootIndex) {
        leftFootIndex = value;
      } else if (key == PoseLandmarkType.rightFootIndex) {
        rightFootIndex = value;
      } else {
        throw 'unknown PoseLandmarkType -> $key';
      }
    });
  }
}
