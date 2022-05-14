import 'package:health_connector/exercise_params.dart';

//  This class contains meta information of Exercises
class ExerciseMeta {
  ExerciseMeta(
      this.title,
      this.exerciseDuration,
      this.exerciseIntensity,
      this.exerciseLocation,
      this.coverImageUrl,
      this.blurHash,
      this.isARAvailable,
      this.isVideoAvailable,
      this.poseData,
      this.orderId,
      this.modelUrl);
  String title;
  int exerciseDuration;
  String exerciseLocation;
  String exerciseIntensity;
  bool isARAvailable;
  bool isVideoAvailable;
  String coverImageUrl;
  String blurHash;
  int orderId;
  List<dynamic> poseData;
  String modelUrl;

  static listFromMap(Map map) {
    List<ExerciseMeta> result = [];
    map.forEach((key, value) {
      result.add(
        ExerciseMeta(
            value[ExerciseParams.title] ?? '',
            value[ExerciseParams.exerciseDuration] ?? 5,
            value[ExerciseParams.exerciseIntensity] ?? 'Low Intensity',
            value[ExerciseParams.exerciseLocation] ?? 'Indoor/Outdoor',
            value[ExerciseParams.coverImageUrl],
            value[ExerciseParams.blurHash],
            value[ExerciseParams.isARAvailable] ?? false,
            value[ExerciseParams.isVideoAvailable] ?? false,
            value[ExerciseParams.poseData],
            value[ExerciseParams.orderId],
            value[ExerciseParams.modelUrl]),
      );
    });
    result.sort((a, b) => a.orderId.compareTo(b.orderId));
    return result;
  }

  fromMap(Map map) {
    title = map[ExerciseParams.title];
    exerciseDuration = map[ExerciseParams.exerciseDuration];
    exerciseIntensity = map[ExerciseParams.exerciseIntensity];
    exerciseLocation = map[ExerciseParams.exerciseLocation];
    coverImageUrl = map[ExerciseParams.coverImageUrl];
    coverImageUrl = map[ExerciseParams.blurHash];
    isARAvailable = map[ExerciseParams.isARAvailable];
    isVideoAvailable = map[ExerciseParams.isVideoAvailable];
    poseData = map[ExerciseParams.poseData];
    modelUrl = map[ExerciseParams.modelUrl];
  }

  toMap() => {
        ExerciseParams.title: title,
        ExerciseParams.exerciseDuration: exerciseDuration,
        ExerciseParams.exerciseIntensity: exerciseIntensity,
        ExerciseParams.exerciseLocation: exerciseLocation,
        ExerciseParams.coverImageUrl: coverImageUrl,
        ExerciseParams.blurHash: blurHash,
        ExerciseParams.isARAvailable: isARAvailable,
        ExerciseParams.isVideoAvailable: isVideoAvailable,
        ExerciseParams.poseData: poseData,
        ExerciseParams.modelUrl: modelUrl
      };
}
