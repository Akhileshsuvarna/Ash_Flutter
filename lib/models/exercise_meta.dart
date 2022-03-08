import 'package:health_connector/exercise_params.dart';

//  This class contains meta information of Exercises
class ExerciseMeta {
  ExerciseMeta(this.title, this.description, this.coverImageUrl, this.blurHash,
      this.isARAvailable, this.isVideoAvailable, this.poseData);
  String title;
  String description;
  bool isARAvailable;
  bool isVideoAvailable;
  String coverImageUrl;
  String blurHash;
  Map<String, dynamic> poseData;

  static listFromMap(Map map) {
    List<ExerciseMeta> result = [];
    map.forEach((key, value) {
      result.add(ExerciseMeta(
          value[ExerciseParams.title] ?? '',
          value[ExerciseParams.description] ?? '',
          value[ExerciseParams.coverImageUrl],
          value[ExerciseParams.blurHash],
          value[ExerciseParams.isARAvailable] ?? false,
          value[ExerciseParams.isVideoAvailable] ?? false,
          value[ExerciseParams.poseData]));
    });
    return result;
  }

  fromMap(Map map) {
    title = map[ExerciseParams.title];
    description = map[ExerciseParams.description];
    coverImageUrl = map[ExerciseParams.coverImageUrl];
    coverImageUrl = map[ExerciseParams.blurHash];
    isARAvailable = map[ExerciseParams.isARAvailable];
    isVideoAvailable = map[ExerciseParams.isVideoAvailable];
    poseData = map[ExerciseParams.poseData];
  }

  toMap() => {
        ExerciseParams.title: title,
        ExerciseParams.description: description,
        ExerciseParams.coverImageUrl: coverImageUrl,
        ExerciseParams.blurHash: blurHash,
        ExerciseParams.isARAvailable: isARAvailable,
        ExerciseParams.isVideoAvailable: isVideoAvailable,
        ExerciseParams.poseData: poseData
      };
}
