import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:health_connector/main.dart';
import 'package:native_device_orientation/native_device_orientation.dart';

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

  PoseData.fromMap(Map<PoseLandmarkType, PoseLandmark> landmarks, Size size) {
    landmarks.forEach((key, value) {
      if (key == PoseLandmarkType.nose) {
        nose = axisMap(value, size);
      } else if (key == PoseLandmarkType.leftEyeInner) {
        leftEyeInner = axisMap(value, size);
      } else if (key == PoseLandmarkType.leftEye) {
        leftEye = axisMap(value, size);
      } else if (key == PoseLandmarkType.leftEyeOuter) {
        leftEyeOuter = axisMap(value, size);
      } else if (key == PoseLandmarkType.rightEyeInner) {
        rightEyeInner = axisMap(value, size);
      } else if (key == PoseLandmarkType.rightEye) {
        rightEye = axisMap(value, size);
      } else if (key == PoseLandmarkType.rightEyeOuter) {
        rightEyeOuter = axisMap(value, size);
      } else if (key == PoseLandmarkType.leftEar) {
        leftEar = axisMap(value, size);
      } else if (key == PoseLandmarkType.rightEar) {
        rightEar = axisMap(value, size);
      } else if (key == PoseLandmarkType.leftMouth) {
        leftMouth = axisMap(value, size);
      } else if (key == PoseLandmarkType.rightMouth) {
        rightMouth = axisMap(value, size);
      } else if (key == PoseLandmarkType.leftShoulder) {
        leftShoulder = axisMap(value, size);
      } else if (key == PoseLandmarkType.rightShoulder) {
        rightShoulder = axisMap(value, size);
      } else if (key == PoseLandmarkType.leftElbow) {
        leftElbow = axisMap(value, size);
      } else if (key == PoseLandmarkType.rightElbow) {
        rightElbow = axisMap(value, size);
      } else if (key == PoseLandmarkType.leftWrist) {
        leftWrist = axisMap(value, size);
      } else if (key == PoseLandmarkType.rightWrist) {
        rightWrist = axisMap(value, size);
      } else if (key == PoseLandmarkType.leftPinky) {
        leftPinky = axisMap(value, size);
      } else if (key == PoseLandmarkType.rightPinky) {
        rightPinky = axisMap(value, size);
      } else if (key == PoseLandmarkType.leftIndex) {
        leftIndex = axisMap(value, size);
      } else if (key == PoseLandmarkType.rightIndex) {
        rightIndex = axisMap(value, size);
      } else if (key == PoseLandmarkType.leftThumb) {
        leftThumb = axisMap(value, size);
      } else if (key == PoseLandmarkType.rightThumb) {
        rightThumb = axisMap(value, size);
      } else if (key == PoseLandmarkType.leftHip) {
        leftHip = axisMap(value, size);
      } else if (key == PoseLandmarkType.rightHip) {
        rightHip = axisMap(value, size);
      } else if (key == PoseLandmarkType.leftKnee) {
        leftKnee = axisMap(value, size);
      } else if (key == PoseLandmarkType.rightKnee) {
        rightKnee = axisMap(value, size);
      } else if (key == PoseLandmarkType.leftAnkle) {
        leftAnkle = axisMap(value, size);
      } else if (key == PoseLandmarkType.rightAnkle) {
        rightAnkle = axisMap(value, size);
      } else if (key == PoseLandmarkType.leftHeel) {
        leftHeel = axisMap(value, size);
      } else if (key == PoseLandmarkType.rightHeel) {
        rightHeel = axisMap(value, size);
      } else if (key == PoseLandmarkType.leftFootIndex) {
        leftFootIndex = axisMap(value, size);
      } else if (key == PoseLandmarkType.rightFootIndex) {
        rightFootIndex = axisMap(value, size);
      } else {
        throw 'unknown PoseLandmarkType -> $key';
      }
    });
  }

  PoseLandmark axisMap(PoseLandmark landmark, Size size) {
    switch (currentDeviceOrientation) {
      case NativeDeviceOrientation.portraitUp:
        return landmark;
      case NativeDeviceOrientation.portraitDown:
        return PoseLandmark(
            type: landmark.type,
            x: size.width - landmark.x,
            y: size.height - landmark.y,
            z: landmark.z,
            likelihood: landmark.likelihood);
      case NativeDeviceOrientation.landscapeLeft:
        return PoseLandmark(
            type: landmark.type,
            x: size.width - landmark.y,
            y: size.height - landmark.x,
            z: landmark.z,
            likelihood: landmark.likelihood);
      case NativeDeviceOrientation.landscapeRight:
        return PoseLandmark(
            type: landmark.type,
            x: landmark.y,
            y: landmark.x,
            z: landmark.z,
            likelihood: landmark.likelihood);
      case NativeDeviceOrientation.unknown:
        return landmark;
    }
  }
}
