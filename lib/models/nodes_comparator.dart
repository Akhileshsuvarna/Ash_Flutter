import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:health_connector/enums/enums.dart';
import 'package:health_connector/util/enum_utils.dart';
import 'package:health_connector/util/utils.dart';

class NCParams {
  const NCParams._();
  static const String firstlandmark = 'firstlandmark';
  static const String secondLandmark = 'secondLandmark';
  static const String greaterLandmark = 'greaterLandmark';
  static const String axis = 'axis';
}

class NodesComparator {
  late PoseLandmarkType firstlandmark;
  late PoseLandmarkType secondLandmark;
  late PoseLandmarkType greaterLandmark;
  late Axis axis;

  NodesComparator(
      this.firstlandmark, this.secondLandmark, this.greaterLandmark, this.axis);

  Map<String, dynamic> toJson() => {
        NCParams.firstlandmark:
            Utils.splitListBySeperatorAsList([firstlandmark], '.').first,
        NCParams.secondLandmark:
            Utils.splitListBySeperatorAsList([secondLandmark], '.').first,
        NCParams.greaterLandmark:
            Utils.splitListBySeperatorAsList([greaterLandmark], '.').first,
        NCParams.axis: Utils.splitListBySeperatorAsList([axis], '.').first
      };
  NodesComparator.fromJson(Map<String, dynamic> json) {
    firstlandmark = EnumUtils.toEnum(
        json[NCParams.firstlandmark], PoseLandmarkType.values, true)!;
    secondLandmark = EnumUtils.toEnum(
        json[NCParams.secondLandmark], PoseLandmarkType.values, true)!;
    greaterLandmark = EnumUtils.toEnum(
        json[NCParams.greaterLandmark], PoseLandmarkType.values, true)!;
    axis = EnumUtils.toEnum(json[NCParams.axis], Axis.values, true)!;
  }
}
