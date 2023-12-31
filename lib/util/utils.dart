import 'dart:convert' show utf8, LineSplitter;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:image/image.dart' as img;
import 'package:blurhash_dart/blurhash_dart.dart';
import 'package:health_connector/constants.dart';

import '../log/logger.dart';
import '../main.dart';
import 'pose_data.dart';

class Utils {
  const Utils._();

  static Future speak(String text) async {
    var result = await flutterTts.speak(text);
    Logger.debug(result);
  }

  static bool isBlank(dynamic obj) {
    if (obj == null) {
      return true;
    }

    if (obj is String) {
      obj = obj.trim();
    }

    try {
      // 'String, Iterable, Map' all have isEmpty function
      return obj.isEmpty;
    } catch (e) {
      return false;
    }
  }

  static String? toBlank(String? str) => toDefault(str, "");

  static String? toNull(String? str) => toDefault(str, null);

  static T? toDefault<T>(T? value, T? defaultValue) {
    if (value is String) {
      return isBlank(value) ? defaultValue : value;
    } else if (value is List) {
      return isBlank(value) ? defaultValue : value;
    }

    return value ?? defaultValue;
  }

  static String? toUtf8(List<int> bytes) => toString__(bytes, true);

  // ignore: non_constant_identifier_names
  static String? toString__(List<int> bytes, bool toUtf8) => isBlank(bytes)
      ? null
      : toNull(toUtf8 ? utf8.decode(bytes) : String.fromCharCodes(bytes));

  static List<String>? splitLines(String str) =>
      isBlank(str) ? null : const LineSplitter().convert(str.trim());

  static List<String>? split(String? str, String delimiters) =>
      isBlank(str) ? null : str?.trim().split(RegExp("[$delimiters]"));

  static List<String>? splitByCommaAsList(String? str) => split(str, ",");

  static List<String> splitListBySeperatorAsList(
      List<dynamic> str, String seperator) {
    List<String> result = [];
    for (var element in str) {
      result.add(element.toString().split(seperator)[1]);
    }
    return result;
  }

  static bool equalsIgnoreCase(String? string1, String? string2) =>
      string1?.toLowerCase() == string2?.toLowerCase();

  static String? trimAndToLower(String str) =>
      isBlank(str) ? null : str.trim().toLowerCase();

  static String? trim(String? str) => isBlank(str) ? null : str?.trim();

  static List<T>? nonNullList<T>(List<T?>? elements) {
    if (elements == null) {
      return null;
    }

    List<T> list = <T>[];

    for (T? element in elements) {
      if (element != null) {
        list.add(element);
      }
    }

    return list.isEmpty ? null : list;
  }

  static List<T>? castList<T>(List<dynamic> list) =>
      isBlank(list) ? null : list.map((item) => item as T).toList();

  static bool comparePoseLandmark(PoseLandmark best, PoseLandmark current) {
    if (current.likelihood >= best.likelihood) {
      if (best.x - current.x > Constants.accuracy &&
          best.y - current.y > Constants.accuracy &&
          best.z - current.z > Constants.accuracy) {
        return true;
      }
    }
    return false;
  }

// TODO-Sikander complete this later
  static bool x = true;
  static void isPoseGeneric(String conf, Pose pose) {
    // if(isUserLefty(pose))
    // {
    //   //Comapre all left side landmarks
    // }
    // else if(isUserRight(pose)){
    //   //compare all right side marks
    // }
    // else{
    //   // Unknown Side Compare All Worst case scnerio
    // }
    // var poseData = PoseData.fromMap(pose.landmarks);
    // if (Utils.x && poseData.leftHip.x > poseData.nose.x) {}
  }

  static bool isCatPose(Pose pose, Size size) {
    var poseData = PoseData.fromMap(pose.landmarks, size);
    // Logger.debug("""X-Axis: leftShoulder ${poseData.leftShoulder.x}
    //     | leftHip ${poseData.leftHip.x}
    //     | leftElbow ${poseData.leftElbow.x}
    //     | leftKnee ${poseData.leftKnee.x}
    //     | leftAnkle ${poseData.leftAnkle.x}
    //     | leftWrist ${poseData.leftWrist.x}""");
    // Logger.debug("""Y-Axis: leftShoulder ${poseData.leftShoulder.y}
    //     | leftHip ${poseData.leftHip.y}
    //     | leftElbow ${poseData.leftElbow.y}
    //     | leftKnee ${poseData.leftKnee.y}
    //     | leftAnkle ${poseData.leftAnkle.y}
    //     | leftWrist ${poseData.leftWrist.y}""");
    // Logger.debug("""Z-Axis: leftShoulder ${poseData.leftShoulder.y}
    //     | leftHip ${poseData.leftHip.z}
    //     | leftElbow ${poseData.leftElbow.z}
    //     | leftKnee ${poseData.leftKnee.z}
    //     | leftAnkle ${poseData.leftAnkle.z}
    //     | leftWrist ${poseData.leftWrist.z}""");
    if (poseData.leftAnkle.x > poseData.leftShoulder.x) {
      return _catLeft(poseData);
    } else if (poseData.rightAnkle.x < poseData.rightShoulder.x) {
      return _catRight(poseData);
    } else {
      return false;
    }
  }

  static bool _catLeft(PoseData poseData) {
    try {
      if (
          // poseData.nose.x < poseData.leftShoulder.x &&
          // poseData.nose.x < poseData.leftHip.x &&
          // poseData.nose.x < poseData.leftKnee.x &&
          // poseData.nose.x < poseData.leftAnkle.x &&
          poseData.leftElbow.x < poseData.leftHip.x &&
              poseData.leftElbow.x < poseData.leftKnee.x &&
              poseData.leftElbow.x < poseData.leftAnkle.x &&
              poseData.leftWrist.x < poseData.leftHip.x &&
              poseData.leftWrist.x < poseData.leftKnee.x &&
              poseData.leftWrist.x < poseData.leftAnkle.x &&
              poseData.leftShoulder.x < poseData.leftHip.x &&
              poseData.leftShoulder.x < poseData.leftKnee.x &&
              poseData.leftShoulder.x < poseData.leftAnkle.x &&
              poseData.leftHip.x < poseData.leftAnkle.x &&
              poseData.leftKnee.x < poseData.leftAnkle.x &&
              // poseData.nose.y < poseData.leftElbow.y &&
              // poseData.nose.y < poseData.leftWrist.y &&
              // // poseData.nose.y < poseData.leftShoulder.y && // For Cat
              // // poseData.nose.y > poseData.leftShoulder.y && // For Cow
              // poseData.nose.y < poseData.leftHip.y && // For Cat
              // poseData.nose.y < poseData.leftKnee.y &&
              // poseData.nose.y < poseData.leftAnkle.y &&
              poseData.leftShoulder.y < poseData.leftHip.y &&
              poseData.leftShoulder.y < poseData.leftElbow.y &&
              poseData.leftShoulder.y < poseData.leftKnee.y &&
              poseData.leftShoulder.y < poseData.leftWrist.y &&
              poseData.leftShoulder.y < poseData.leftAnkle.y &&
              poseData.leftHip.y < poseData.leftElbow.y &&
              poseData.leftHip.y < poseData.leftKnee.y &&
              poseData.leftHip.y < poseData.leftWrist.y &&
              poseData.leftHip.y < poseData.leftAnkle.y &&
              poseData.leftElbow.y < poseData.leftWrist.y &&
              poseData.leftElbow.y < poseData.leftKnee.y &&
              poseData.leftElbow.y < poseData.leftAnkle.y) {
        if (poseData.leftKnee.y - poseData.leftHip.y >
            poseData.leftElbow.y - poseData.leftShoulder.y) {
          return true;
        }
      }
    } catch (e, stackTrace) {
      Logger.error(e, stackTrace: stackTrace);
    }
    return false;
  }

  static bool _catRight(PoseData poseData) {
    try {
      if (poseData.rightAnkle.x < poseData.rightKnee.x &&
          poseData.rightAnkle.x < poseData.rightHip.x &&
          poseData.rightAnkle.x < poseData.rightShoulder.x &&
          poseData.rightAnkle.x < poseData.rightEar.x &&
          poseData.rightHip.x < poseData.rightShoulder.x &&
          poseData.rightHip.x < poseData.rightEar.x &&
          poseData.rightShoulder.x < poseData.rightEar.x &&

          // poseData.rightShoulder.y < poseData.nose.y && // Cow
          // poseData.rightShoulder.y > poseData.nose.y &&  // Cat
          poseData.rightShoulder.y < poseData.rightHip.y &&
          poseData.rightShoulder.y < poseData.rightElbow.y &&
          poseData.rightShoulder.y < poseData.rightKnee.y &&
          poseData.rightShoulder.y < poseData.rightWrist.y &&
          poseData.rightShoulder.y < poseData.rightAnkle.y &&
          poseData.rightHip.y < poseData.rightElbow.y &&
          poseData.rightHip.y < poseData.rightKnee.y &&
          poseData.rightHip.y < poseData.rightWrist.y &&
          poseData.rightHip.y < poseData.rightAnkle.y &&
          poseData.rightElbow.y < poseData.rightKnee.y &&
          poseData.rightElbow.y < poseData.rightWrist.y &&
          poseData.rightElbow.y < poseData.rightAnkle.y) {
        if (poseData.rightKnee.y - poseData.rightHip.y >
            poseData.rightElbow.y - poseData.rightShoulder.y) {
          return true;
        }
      }
    } catch (e, stackTrace) {
      Logger.error(e, stackTrace: stackTrace);
    }
    return false;
  }

  static bool isSphinxPose(Pose pose, Size size) {
    var poseData = PoseData.fromMap(pose.landmarks, size);
    if (poseData.leftShoulder.x < poseData.leftAnkle.x) {
      return _sphinxLeft(poseData);
    } else if (poseData.rightAnkle.x < poseData.rightShoulder.x) {
      return _sphinxRight(poseData);
    } else {
      return false;
    }
  }

  static bool _sphinxLeft(PoseData poseData) {
    try {
      if (poseData.leftWrist.x < poseData.leftElbow.x &&
          poseData.leftWrist.x < poseData.leftHip.x &&
          poseData.leftWrist.x < poseData.leftKnee.x &&
          poseData.leftWrist.x < poseData.leftAnkle.x &&
          poseData.leftElbow.x < poseData.leftHip.x &&
          poseData.leftElbow.x < poseData.leftKnee.x &&
          poseData.leftElbow.x < poseData.leftAnkle.x &&
          poseData.leftHip.x < poseData.leftKnee.x &&
          poseData.leftHip.x < poseData.leftAnkle.x &&
          poseData.leftKnee.x < poseData.leftAnkle.x &&
          poseData.leftEar.y < poseData.leftShoulder.y &&
          poseData.leftEar.y < poseData.leftElbow.y &&
          poseData.leftEar.y < poseData.leftWrist.y &&
          poseData.leftEar.y < poseData.leftHip.y &&
          poseData.leftEar.y < poseData.leftKnee.y &&
          poseData.leftEar.y < poseData.leftAnkle.y &&
          poseData.nose.y < poseData.leftShoulder.y &&
          poseData.nose.y < poseData.leftElbow.y &&
          poseData.nose.y < poseData.leftHip.y &&
          poseData.nose.y < poseData.leftWrist.y &&
          poseData.nose.y < poseData.leftKnee.y &&
          poseData.nose.y < poseData.leftAnkle.y &&
          poseData.leftShoulder.y < poseData.leftElbow.y &&
          poseData.leftShoulder.y < poseData.leftWrist.y &&
          poseData.leftShoulder.y < poseData.leftHip.y &&
          poseData.leftShoulder.y < poseData.leftKnee.y &&
          poseData.leftShoulder.y < poseData.leftAnkle.y) {
        if (poseData.leftHip.y.abs() - poseData.leftShoulder.y.abs() >
            poseData.leftElbow.y.abs() - poseData.leftHip.y.abs()) {
          return true;
        }
      }
    } catch (e, stackTrace) {
      Logger.error(e, stackTrace: stackTrace);
    }
    return false;
  }

  static bool _sphinxRight(PoseData poseData) {
    try {
      if (poseData.rightAnkle.x < poseData.rightKnee.x &&
          poseData.rightAnkle.x < poseData.rightHip.x &&
          poseData.rightAnkle.x < poseData.rightShoulder.x &&
          poseData.rightAnkle.x < poseData.nose.x &&
          poseData.rightAnkle.x < poseData.rightElbow.x &&
          poseData.rightAnkle.x < poseData.rightWrist.x &&
          poseData.rightKnee.x < poseData.rightHip.x &&
          poseData.rightKnee.x < poseData.rightShoulder.x &&
          poseData.rightKnee.x < poseData.nose.x &&
          poseData.rightKnee.x < poseData.rightWrist.x &&
          poseData.rightHip.x < poseData.rightShoulder.x &&
          poseData.rightHip.x < poseData.nose.x &&
          poseData.rightHip.x < poseData.rightElbow.x &&
          poseData.rightHip.x < poseData.rightWrist.x &&
          poseData.rightShoulder.x < poseData.nose.x &&
          poseData.rightShoulder.x < poseData.rightWrist.x &&
          poseData.nose.x < poseData.rightWrist.x &&
          poseData.nose.y < poseData.rightShoulder.y &&
          poseData.nose.y < poseData.rightAnkle.y &&
          poseData.nose.y < poseData.rightKnee.y &&
          poseData.nose.y < poseData.rightHip.y &&
          poseData.nose.y < poseData.rightElbow.y &&
          poseData.nose.y < poseData.leftWrist.y &&
          poseData.rightShoulder.y < poseData.rightAnkle.y &&
          poseData.rightShoulder.y < poseData.rightKnee.y &&
          poseData.rightShoulder.y < poseData.rightHip.y &&
          poseData.rightShoulder.y < poseData.rightElbow.y &&
          poseData.rightShoulder.y < poseData.leftWrist.y) {
        if (poseData.rightHip.y.abs() - poseData.rightShoulder.y.abs() >
            poseData.rightElbow.y.abs() - poseData.rightHip.y.abs()) {
          return true;
        }
      }
    } catch (e, stackTrace) {
      Logger.error(e, stackTrace: stackTrace);
    }
    return false;
  }

  static bool isPlankPose(Pose pose, Size size) {
    var poseData = PoseData.fromMap(pose.landmarks, size);
    if (poseData.leftShoulder.x < poseData.leftAnkle.x) {
      return _plankLeft(poseData);
    } else if (poseData.rightAnkle.x < poseData.rightShoulder.x) {
      return _plankRight(poseData);
    } else {
      return false;
    }
  }

  static bool _plankLeft(PoseData poseData) {
    try {
      if (poseData.leftWrist.x < poseData.leftElbow.x &&
          poseData.leftWrist.x < poseData.leftHip.x &&
          poseData.leftWrist.x < poseData.leftKnee.x &&
          poseData.leftWrist.x < poseData.leftAnkle.x &&
          poseData.leftElbow.x < poseData.leftHip.x &&
          poseData.leftElbow.x < poseData.leftKnee.x &&
          poseData.leftElbow.x < poseData.leftAnkle.x &&
          poseData.leftHip.x < poseData.leftKnee.x &&
          poseData.leftHip.x < poseData.leftAnkle.x &&
          poseData.leftKnee.x < poseData.leftAnkle.x &&
          poseData.nose.y < poseData.leftWrist.y &&
          poseData.nose.y < poseData.leftElbow.y &&
          poseData.leftShoulder.y < poseData.leftWrist.y &&
          poseData.leftShoulder.y < poseData.leftElbow.y &&
          poseData.leftHip.y < poseData.leftWrist.y &&
          poseData.leftHip.y < poseData.leftElbow.y &&
          poseData.leftKnee.y < poseData.leftElbow.y &&
          poseData.leftKnee.y < poseData.leftWrist.y) {
        return true;
      }
    } catch (e, stackTrace) {
      Logger.error(e, stackTrace: stackTrace);
    }
    return false;
  }

  static bool _plankRight(PoseData poseData) {
    try {
      if (poseData.rightAnkle.x < poseData.rightKnee.x &&
          poseData.rightAnkle.x < poseData.rightHip.x &&
          poseData.rightAnkle.x < poseData.rightElbow.x &&
          poseData.rightAnkle.x < poseData.rightShoulder.x &&
          poseData.rightAnkle.x < poseData.rightWrist.x &&
          poseData.rightKnee.x < poseData.rightHip.x &&
          poseData.rightKnee.x < poseData.rightShoulder.x &&
          poseData.rightKnee.x < poseData.rightWrist.x &&
          poseData.rightHip.x < poseData.rightShoulder.x &&
          poseData.rightHip.x < poseData.rightWrist.x &&
          poseData.rightShoulder.x < poseData.leftWrist.x &&
          poseData.nose.y < poseData.rightElbow.y &&
          poseData.rightHip.y < poseData.rightElbow.y &&
          poseData.rightShoulder.y < poseData.rightElbow.y &&
          poseData.rightKnee.y < poseData.rightElbow.y &&
          poseData.rightKnee.y < poseData.rightWrist.y) {
        return true;
      } else {
        return false;
      }
    } catch (e, stackTrace) {
      Logger.error(e, stackTrace: stackTrace);
      return false;
    }
  }

  static String getBlurHash(String imagePath) {
    final data = File(imagePath).readAsBytesSync();
    final image = img.decodeImage(data.toList());
    return BlurHash.encode(image!, numCompX: 4, numCompY: 3).hash;
  }
}
