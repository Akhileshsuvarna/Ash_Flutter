import 'dart:convert' show utf8, LineSplitter;
import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:blurhash_dart/blurhash_dart.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:health_connector/constants.dart';

import '../log/logger.dart';
import 'pose_data.dart';

class Utils {
  const Utils._();

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
    var poseData = PoseData.fromMap(pose.landmarks);
    if (Utils.x && poseData.leftHip.x > poseData.nose.x) {}
  }

  static bool isCatPose(Pose pose) {
    var poseData = PoseData.fromMap(pose.landmarks);
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
      if (poseData.nose.x < poseData.leftShoulder.x &&
          poseData.nose.x < poseData.rightShoulder.x &&
          poseData.nose.x < poseData.leftHip.x &&
          poseData.nose.x < poseData.rightHip.x &&
          poseData.nose.x < poseData.leftKnee.x &&
          poseData.nose.x < poseData.rightKnee.x &&
          poseData.nose.x < poseData.leftAnkle.x &&
          poseData.nose.x < poseData.rightAnkle.x &&
          poseData.leftElbow.x < poseData.leftHip.x &&
          poseData.leftElbow.x < poseData.rightHip.x &&
          poseData.leftElbow.x < poseData.leftKnee.x &&
          poseData.leftElbow.x < poseData.rightKnee.x &&
          poseData.leftElbow.x < poseData.leftAnkle.x &&
          poseData.leftElbow.x < poseData.rightAnkle.x &&
          poseData.rightElbow.x < poseData.leftHip.x &&
          poseData.rightElbow.x < poseData.rightHip.x &&
          poseData.rightElbow.x < poseData.leftKnee.x &&
          poseData.rightElbow.x < poseData.rightKnee.x &&
          poseData.rightElbow.x < poseData.leftAnkle.x &&
          poseData.rightElbow.x < poseData.rightAnkle.x &&
          poseData.leftWrist.x < poseData.leftHip.x &&
          poseData.leftWrist.x < poseData.rightHip.x &&
          poseData.leftWrist.x < poseData.leftKnee.x &&
          poseData.leftWrist.x < poseData.rightKnee.x &&
          poseData.leftWrist.x < poseData.leftAnkle.x &&
          poseData.leftWrist.x < poseData.rightAnkle.x &&
          poseData.rightWrist.x < poseData.leftHip.x &&
          poseData.rightWrist.x < poseData.rightHip.x &&
          poseData.rightWrist.x < poseData.leftKnee.x &&
          poseData.rightWrist.x < poseData.rightKnee.x &&
          poseData.rightWrist.x < poseData.leftAnkle.x &&
          poseData.rightWrist.x < poseData.rightAnkle.x &&
          poseData.leftShoulder.x < poseData.leftHip.x &&
          poseData.leftShoulder.x < poseData.rightHip.x &&
          poseData.leftShoulder.x < poseData.leftKnee.x &&
          poseData.leftShoulder.x < poseData.rightKnee.x &&
          poseData.leftShoulder.x < poseData.leftAnkle.x &&
          poseData.leftShoulder.x < poseData.rightAnkle.x &&
          poseData.rightShoulder.x < poseData.leftHip.x &&
          poseData.rightShoulder.x < poseData.rightHip.x &&
          poseData.rightShoulder.x < poseData.leftKnee.x &&
          poseData.rightShoulder.x < poseData.rightKnee.x &&
          poseData.rightShoulder.x < poseData.leftAnkle.x &&
          poseData.rightShoulder.x < poseData.rightAnkle.x &&
          poseData.leftHip.x < poseData.leftAnkle.x &&
          poseData.leftHip.x < poseData.rightAnkle.x &&
          poseData.rightHip.x < poseData.leftAnkle.x &&
          poseData.rightHip.x < poseData.rightAnkle.x &&
          poseData.leftKnee.x < poseData.leftAnkle.x &&
          poseData.leftKnee.x < poseData.rightAnkle.x &&
          poseData.rightKnee.x < poseData.leftAnkle.x &&
          poseData.rightKnee.x < poseData.rightAnkle.x &&
          poseData.nose.y < poseData.leftElbow.y &&
          poseData.nose.y < poseData.rightElbow.y &&
          poseData.nose.y < poseData.leftWrist.y &&
          poseData.nose.y < poseData.rightWrist.y &&
          poseData.nose.y < poseData.leftShoulder.y &&
          poseData.nose.y < poseData.rightShoulder.y &&
          poseData.nose.y < poseData.leftHip.y &&
          poseData.nose.y < poseData.rightHip.y &&
          poseData.nose.y < poseData.leftKnee.y &&
          poseData.nose.y < poseData.rightKnee.y &&
          poseData.nose.y < poseData.leftAnkle.y &&
          poseData.nose.y < poseData.rightAnkle.y &&
          poseData.leftElbow.y > poseData.leftShoulder.y &&
          poseData.leftElbow.y > poseData.rightShoulder.y &&
          poseData.leftElbow.y > poseData.leftHip.y &&
          poseData.leftElbow.y > poseData.rightHip.y &&
          poseData.rightElbow.y > poseData.leftShoulder.y &&
          poseData.rightElbow.y > poseData.rightShoulder.y &&
          poseData.rightElbow.y > poseData.leftHip.y &&
          poseData.rightElbow.y > poseData.rightHip.y &&
          poseData.leftWrist.y > poseData.leftShoulder.y &&
          poseData.leftWrist.y > poseData.rightShoulder.y &&
          poseData.leftWrist.y > poseData.leftHip.y &&
          poseData.leftWrist.y > poseData.rightHip.y &&
          poseData.rightWrist.y > poseData.leftShoulder.y &&
          poseData.rightWrist.y > poseData.rightShoulder.y &&
          poseData.rightWrist.y > poseData.leftHip.y &&
          poseData.rightWrist.y > poseData.rightHip.y &&
          poseData.leftWrist.y > poseData.leftElbow.y &&
          poseData.leftWrist.y > poseData.rightElbow.y &&
          poseData.rightWrist.y > poseData.leftElbow.y &&
          poseData.rightWrist.y > poseData.rightElbow.y) {
        return true;
      } else {
        return false;
      }
    } catch (e, stackTrace) {
      Logger.error(e, stackTrace: stackTrace);
      return false;
    }
    return false;
  }

  static bool _catRight(PoseData poseData) {
    try {
      if (poseData.nose.x > poseData.rightShoulder.x &&
          poseData.nose.x > poseData.rightHip.x &&
          poseData.nose.x > poseData.rightKnee.x &&
          poseData.nose.x > poseData.rightAnkle.x &&
          poseData.leftElbow.x > poseData.rightHip.x &&
          poseData.leftElbow.x > poseData.rightKnee.x &&
          poseData.leftElbow.x > poseData.rightAnkle.x &&
          poseData.rightElbow.x > poseData.rightHip.x &&
          poseData.rightElbow.x > poseData.rightKnee.x &&
          poseData.rightElbow.x > poseData.rightAnkle.x &&
          poseData.leftWrist.x > poseData.rightHip.x &&
          poseData.leftWrist.x > poseData.rightKnee.x &&
          poseData.leftWrist.x > poseData.rightAnkle.x &&
          poseData.rightWrist.x > poseData.rightHip.x &&
          poseData.rightWrist.x > poseData.rightKnee.x &&
          poseData.rightWrist.x > poseData.rightAnkle.x &&
          poseData.leftShoulder.x > poseData.rightHip.x &&
          poseData.leftShoulder.x > poseData.rightKnee.x &&
          poseData.leftShoulder.x > poseData.rightAnkle.x &&
          poseData.rightShoulder.x > poseData.rightHip.x &&
          poseData.rightShoulder.x > poseData.rightKnee.x &&
          poseData.rightShoulder.x > poseData.rightAnkle.x &&
          poseData.rightHip.x > poseData.rightAnkle.x &&
          poseData.rightKnee.x > poseData.rightAnkle.x &&
          poseData.nose.y < poseData.rightElbow.y &&
          poseData.nose.y < poseData.rightWrist.y &&
          poseData.nose.y < poseData.rightKnee.y &&
          poseData.nose.y < poseData.rightAnkle.y &&
          poseData.rightWrist.y > poseData.rightShoulder.y &&
          poseData.rightWrist.y > poseData.rightHip.y &&
          poseData.rightWrist.y > poseData.rightElbow.y) {
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
