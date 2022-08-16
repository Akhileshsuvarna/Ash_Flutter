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
      this.modelUrlAndroid,
      this.modelUrlIOS,
      this.modelName,
      this.videoUrl,
      this.description);
  late String title;
  late int exerciseDuration;
  late String exerciseLocation;
  late String exerciseIntensity;
  late bool isARAvailable;
  late bool isVideoAvailable;
  late String coverImageUrl;
  late String blurHash;
  late int orderId;
  late List<dynamic> poseData;
  late String modelUrlAndroid;
  late String modelUrlIOS;
  late String modelName;
  late String videoUrl;
  late String description;

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
          value[ExerciseParams.modelUrlAndroid],
          value[ExerciseParams.modelUrlIOS],
          value[ExerciseParams.modelName],
          value[ExerciseParams.videoUrl],
          value[ExerciseParams.description],
        ),
      );
    });
    result.sort((a, b) => a.orderId.compareTo(b.orderId));
    return result;
  }

  ExerciseMeta.fromMap(Map map) {
    title = map[ExerciseParams.title];
    exerciseDuration = map[ExerciseParams.exerciseDuration];
    exerciseIntensity = map[ExerciseParams.exerciseIntensity];
    exerciseLocation = map[ExerciseParams.exerciseLocation];
    coverImageUrl = map[ExerciseParams.coverImageUrl];
    coverImageUrl = map[ExerciseParams.blurHash];
    isARAvailable = map[ExerciseParams.isARAvailable];
    isVideoAvailable = map[ExerciseParams.isVideoAvailable];
    poseData = map[ExerciseParams.poseData];
    modelUrlAndroid = map[ExerciseParams.modelUrlAndroid];
    modelUrlIOS = map[ExerciseParams.modelUrlIOS];
    modelName = map[ExerciseParams.modelName];
    videoUrl = map[ExerciseParams.videoUrl];
    description = map[ExerciseParams.description];
  }

  toJson() => {
        ExerciseParams.title: title,
        ExerciseParams.exerciseDuration: exerciseDuration,
        ExerciseParams.exerciseIntensity: exerciseIntensity,
        ExerciseParams.exerciseLocation: exerciseLocation,
        ExerciseParams.coverImageUrl: coverImageUrl,
        ExerciseParams.blurHash: blurHash,
        ExerciseParams.isARAvailable: isARAvailable,
        ExerciseParams.isVideoAvailable: isVideoAvailable,
        ExerciseParams.poseData: poseData,
        ExerciseParams.modelUrlAndroid: modelUrlAndroid,
        ExerciseParams.modelUrlIOS: modelUrlIOS,
        ExerciseParams.modelName: modelName,
        ExerciseParams.videoUrl: videoUrl,
        ExerciseParams.description: description,
      };
}
