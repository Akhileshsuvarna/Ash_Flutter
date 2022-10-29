import 'package:health_connector/models/exercise_meta.dart';
import 'package:health_connector/models/exercise_score.dart';

class ExerciseResult {
  ExerciseResult(this.eMeta, this.eScore);
  late ExerciseMeta eMeta;
  late ExerciseScore eScore;

  Map<String, dynamic> toJson() =>
      {"eMeta": eMeta.toJson(), "eScore": eScore.toJson()};
  ExerciseResult.fromJson(Map<String, dynamic> json) {
    eMeta = json['eMeta'];
    eScore = json['eScore'];
  }
}
