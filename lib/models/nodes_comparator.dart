import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:health_connector/enums/enums.dart';
import 'package:health_connector/util/enum_utils.dart';
import 'package:health_connector/util/utils.dart';

class NCParams {
  const NCParams._();
  static const String firstlandmark = 'firstlandmark';
  static const String secondLandmark = 'secondLandmark';
  static const String isFirstGreater = 'isFirstGreater';
  static const String axis = 'axis';
}

class NodesComparator {
  late PoseLandmarkType? firstlandmark;
  late PoseLandmarkType? secondLandmark;
  late bool? isFirstGreater;
  late Axis? axis;

  NodesComparator(
      {this.firstlandmark,
      this.secondLandmark,
      this.isFirstGreater,
      this.axis});

  Map<String, dynamic> toJson() => {
        NCParams.firstlandmark:
            Utils.splitListBySeperatorAsList([firstlandmark], '.').last,
        NCParams.secondLandmark:
            Utils.splitListBySeperatorAsList([secondLandmark], '.').last,
        NCParams.isFirstGreater: isFirstGreater,
        NCParams.axis: Utils.splitListBySeperatorAsList([axis], '.').last
      };
  NodesComparator.fromJson(Map<String, dynamic> json) {
    firstlandmark = EnumUtils.toEnum(
        json[NCParams.firstlandmark], PoseLandmarkType.values, true)!;
    secondLandmark = EnumUtils.toEnum(
        json[NCParams.secondLandmark], PoseLandmarkType.values, true)!;
    isFirstGreater = json[NCParams.isFirstGreater];
    axis = EnumUtils.toEnum(json[NCParams.axis], Axis.values, true)!;
  }
}
