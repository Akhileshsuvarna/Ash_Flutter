import 'package:app/VisionDetectorViews/painters/pose_painter.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class PoseData {
  PoseLandmark? nose;
  PoseLandmark? leftEyeInner;
  PoseLandmark? leftEye;
  PoseLandmark? leftEyeOuter;
  PoseLandmark? rightEyeInner;
  PoseLandmark? rightEye;
  PoseLandmark? rightEyeOuter;
  PoseLandmark? leftEar;
  PoseLandmark? rightEar;
  PoseLandmark? leftMouth;
  PoseLandmark? rightMouth;
  PoseLandmark? leftShoulder;
  PoseLandmark? rightShoulder;
  PoseLandmark? leftElbow;
  PoseLandmark? rightElbow;
  PoseLandmark? leftWrist;
  PoseLandmark? rightWrist;
  PoseLandmark? leftPinky;
  PoseLandmark? rightPinky;
  PoseLandmark? leftIndex;
  PoseLandmark? rightIndex;
  PoseLandmark? leftThumb;
  PoseLandmark? rightThumb;
  PoseLandmark? leftHip;
  PoseLandmark? rightHip;
  PoseLandmark? leftKnee;
  PoseLandmark? rightKnee;
  PoseLandmark? leftAnkle;
  PoseLandmark? rightAnkle;
  PoseLandmark? leftHeel;
  PoseLandmark? rightHeel;
  PoseLandmark? leftFootIndex;
  PoseLandmark? rightFootIndex;

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
