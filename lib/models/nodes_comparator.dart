import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:health_connector/enums/enums.dart';
import 'package:health_connector/util/enum_utils.dart';
import 'package:health_connector/util/utils.dart';

class NCParams {
  const NCParams._();
  static const String greaterLandmark = 'greaterLandmark';
  static const String smallerLandmark = 'smallerLandmark';
  static const String axis = 'axis';
}

class NodesComparator {
  late PoseLandmarkType? greaterLandmark;
  late PoseLandmarkType? smallerLandmark;
  late Axis? axis;

  NodesComparator({this.greaterLandmark, this.smallerLandmark, this.axis});

  Map<String, dynamic> toJson() => {
        NCParams.greaterLandmark:
            Utils.splitListBySeperatorAsList([greaterLandmark], '.').last,
        NCParams.smallerLandmark:
            Utils.splitListBySeperatorAsList([smallerLandmark], '.').last,
        NCParams.axis: Utils.splitListBySeperatorAsList([axis], '.').last
      };
  NodesComparator.fromJson(Map<String, dynamic> json) {
    greaterLandmark = EnumUtils.toEnum(
        json[NCParams.greaterLandmark], PoseLandmarkType.values, true)!;
    smallerLandmark = EnumUtils.toEnum(
        json[NCParams.smallerLandmark], PoseLandmarkType.values, true)!;
    axis = EnumUtils.toEnum(json[NCParams.axis], Axis.values, true)!;
  }
}
