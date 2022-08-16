import 'package:health_connector/constants.dart';
import 'package:health_connector/main.dart';
import 'package:health_connector/models/exercise_meta.dart';

class UploadMeta {
  UploadMeta._();

  static upload(ExerciseMeta exerciseMeta) async {
    await firebaseDatabase
        .ref()
        .child(Constants.dbRoot)
        .child(Constants.exercises)
        .child(DateTime.now().millisecondsSinceEpoch.toString())
        .set(exerciseMeta.toJson());
  }
}
