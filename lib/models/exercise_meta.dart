import 'package:health_connector/enums/enums.dart';
import 'package:health_connector/exercise_params.dart';
import 'package:health_connector/log/logger.dart';
import 'package:health_connector/util/enum_utils.dart';

//  This class contains meta information of Exercises
class ExerciseMeta {
  ExerciseMeta(this.title, this.description, this.coverImageUrl,
      this.isARAvailable, this.isVideoAvailable, this.exerciseType);
  String title;
  String description;
  bool isARAvailable;
  bool isVideoAvailable;
  String? coverImageUrl;
  ExerciseType exerciseType;

  static listFromMap(Map map) {
    List<ExerciseMeta> result = [];
    map.forEach((key, value) {
      result.add(ExerciseMeta(
          value[ExerciseParams.title] ?? '',
          value[ExerciseParams.description] ?? '',
          value[ExerciseParams.coverImageUrl],
          value[ExerciseParams.isARAvailable] ?? false,
          value[ExerciseParams.isVideoAvailable] ?? false,
          getExerciseType(value[ExerciseParams.exerciseType])));
    });
    return result;
  }

  static ExerciseType getExerciseType(String code) =>
      EnumUtils.toEnum(code, ExerciseType.values, true)!;

  fromMap(Map map) {
    title = map[ExerciseParams.title];
    description = map[ExerciseParams.description];
    coverImageUrl = map[ExerciseParams.coverImageUrl];
    isARAvailable = map[ExerciseParams.isARAvailable];
    isVideoAvailable = map[ExerciseParams.isVideoAvailable];
  }
}
