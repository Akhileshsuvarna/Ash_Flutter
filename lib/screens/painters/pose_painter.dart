import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:health_connector/log/logger.dart';

import 'coordinates_translator.dart';

double minLikelihood = 0.95;

class PosePainter extends CustomPainter {
  PosePainter(
      this.poses, this.absoluteImageSize, this.rotation, this.paintColor);

  final List<Pose> poses;
  final Size absoluteImageSize;
  final InputImageRotation rotation;
  final Color paintColor;

  @override
  void paint(Canvas canvas, Size size) {
    String data = 'Start : \n';

    final jointPaintLeft = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14.0
      ..color = const Color(0xFF7E57C2);

    final jointPaintRight = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14.0
      ..color = Colors.blue;

    final leftPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0
      ..color = paintColor;

    final rightPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0
      ..color = paintColor;

    for (var pose in poses) {
      void paintLine(
          PoseLandmarkType type1, PoseLandmarkType type2, Paint paintType) {
        PoseLandmark joint1 = pose.landmarks[type1]!;
        PoseLandmark joint2 = pose.landmarks[type2]!;
        data = data +
            '${pose.landmarks[type1]!.type} || X = ${pose.landmarks[type1]!.x} || Y = ${pose.landmarks[type1]!.y} || Z = ${pose.landmarks[type1]!.z}\n';
        data = data +
            '${pose.landmarks[type2]!.type} || X = ${pose.landmarks[type2]!.x} || Y = ${pose.landmarks[type2]!.y} || Z = ${pose.landmarks[type2]!.z}\n';

        // if (joint1.likelihood > minLikelihood &&
        //     joint2.likelihood > minLikelihood) {
        canvas.drawLine(
            Offset(translateX(joint1.x, rotation, size, absoluteImageSize),
                translateY(joint1.y, rotation, size, absoluteImageSize)),
            Offset(translateX(joint2.x, rotation, size, absoluteImageSize),
                translateY(joint2.y, rotation, size, absoluteImageSize)),
            paintType);
        // }
      }

      //Draw arms
      paintLine(
          PoseLandmarkType.leftShoulder, PoseLandmarkType.leftElbow, leftPaint);
      paintLine(
          PoseLandmarkType.leftElbow, PoseLandmarkType.leftWrist, leftPaint);
      paintLine(PoseLandmarkType.rightShoulder, PoseLandmarkType.rightElbow,
          rightPaint);
      paintLine(
          PoseLandmarkType.rightElbow, PoseLandmarkType.rightWrist, rightPaint);

      //Draw Body
      paintLine(
          PoseLandmarkType.leftShoulder, PoseLandmarkType.leftHip, leftPaint);
      paintLine(PoseLandmarkType.rightShoulder, PoseLandmarkType.rightHip,
          rightPaint);

      //Draw Thighs
      paintLine(PoseLandmarkType.leftHip, PoseLandmarkType.leftKnee, leftPaint);
      paintLine(
          PoseLandmarkType.rightHip, PoseLandmarkType.rightKnee, rightPaint);

      //Draw knees to Ankle
      paintLine(
          PoseLandmarkType.leftKnee, PoseLandmarkType.leftAnkle, leftPaint);
      paintLine(
          PoseLandmarkType.rightKnee, PoseLandmarkType.rightAnkle, rightPaint);

      //Draw Chest /body
      paintLine(PoseLandmarkType.leftShoulder, PoseLandmarkType.rightShoulder,
          leftPaint);
      paintLine(PoseLandmarkType.leftHip, PoseLandmarkType.rightHip, leftPaint);

      pose.landmarks.forEach((_, landmark) {
        // if (landmark.likelihood > minLikelihood) {
        if (landmark.type == PoseLandmarkType.leftShoulder ||
            landmark.type == PoseLandmarkType.leftElbow ||
            landmark.type == PoseLandmarkType.leftWrist ||
            landmark.type == PoseLandmarkType.leftHip ||
            landmark.type == PoseLandmarkType.leftKnee ||
            landmark.type == PoseLandmarkType.leftAnkle) {
          canvas.drawCircle(
              Offset(
                translateX(landmark.x, rotation, size, absoluteImageSize),
                translateY(landmark.y, rotation, size, absoluteImageSize),
              ),
              1,
              jointPaintLeft);
          data = data +
              'Type = ${landmark.type} || X = ${landmark.x} || Y = ${landmark.y} || Z = ${landmark.z}\n';
        } else if (landmark.type == PoseLandmarkType.rightShoulder ||
            landmark.type == PoseLandmarkType.rightElbow ||
            landmark.type == PoseLandmarkType.rightWrist ||
            landmark.type == PoseLandmarkType.rightHip ||
            landmark.type == PoseLandmarkType.rightKnee ||
            landmark.type == PoseLandmarkType.rightAnkle) {
          canvas.drawCircle(
              Offset(
                translateX(landmark.x, rotation, size, absoluteImageSize),
                translateY(landmark.y, rotation, size, absoluteImageSize),
              ),
              1,
              jointPaintRight);
          data = data +
              'Type = ${landmark.type} || X = ${landmark.x} || Y = ${landmark.y} || Z = ${landmark.z}\n';
        }
        // }
      });
    }

    // Logger.debug('$data \nEnd');
  }

  @override
  bool shouldRepaint(covariant PosePainter oldDelegate) =>
      oldDelegate.absoluteImageSize != absoluteImageSize ||
      oldDelegate.poses != poses;
}
