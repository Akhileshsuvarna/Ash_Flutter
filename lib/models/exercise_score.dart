import 'dart:convert';

import 'package:health_connector/log/logger.dart';

class ExerciseScore {
  ExerciseScore(
      this.framesProcessed,
      this.framesWithRequiredPose,
      this.framesWithRandomPose,
      this.framesWithoutPose,
      this.exerciseTimeAllotted,
      this.frameStatus,
      this.streakMap);
  int framesProcessed = 0;
  int framesWithRequiredPose = 0;
  int framesWithRandomPose = 0;
  int framesWithoutPose = 0;
  int exerciseTimeAllotted = 0;
  List<FrameStatus> frameStatus = [];
  List<StreakMap> streakMap = [];

  void calculateAgreegate() {
    streakMap = [];
    try {
      int lastStatus = frameStatus[0].status;
      int streakStartTime = frameStatus[0].time;
      int streakEndTime = frameStatus[0].time;
      int streakStatus = frameStatus[0].status;
      for (int i = 0; i < frameStatus.length; i++) {
        if (frameStatus[i].status == lastStatus) {
          streakEndTime = frameStatus[i].time;
          streakStatus = lastStatus;
        } else {
          // if (streakMap.isNotEmpty) {
          //   streakMap.add(StreakMap(
          //     streakMap[streakNumber - 1].streakStatus,
          //     streakMap[streakNumber - 1].streakStartTime,
          //     streakMap[streakNumber - 1].streakEndTime,
          //     streakStartTime,
          //     streakMap[streakNumber - 1].streakEndTime,
          //   ));
          // }
          streakMap.add(StreakMap(
            streakStatus,
            streakStartTime,
            streakEndTime,
            ((streakStartTime + streakEndTime) / 2).floor(),
            streakEndTime - streakStartTime,
          ));
          streakStartTime = frameStatus[i].time;
          lastStatus = frameStatus[i].status;
          streakStatus = lastStatus;
        }

        if (i == frameStatus.length - 1) {
          streakMap.add(StreakMap(
            streakStatus,
            streakStartTime,
            streakEndTime,
            ((streakStartTime + streakEndTime) / 2).floor(),
            streakEndTime - streakStartTime,
          ));
        }
      }
    } catch (e, stackTrace) {
      Logger.error(e, stackTrace: stackTrace);
      rethrow;
    }
  }

  toJson() => {
        "framsesProcessed": framesProcessed,
        "framesWithRequiredPose": framesWithRequiredPose,
        "framesWithRandomPose": framesWithRandomPose,
        "framesWithoutPose": framesWithoutPose,
        "exerciseTimeAllotted": exerciseTimeAllotted,
        "frameStatus": [
          for (var e in frameStatus) {'status': e.status, 'time': e.time}
        ],
        "streakMap": [for (var e in streakMap) e.toJson()]
      };
  ExerciseScore.fromJson(Map<String, dynamic> json) {
    framesProcessed = json['framsesProcessed'];
    framesWithRequiredPose = json['framesWithRequiredPose'];
    framesWithRandomPose = json['framesWithRandomPose'];
    framesWithoutPose = json['framesWithoutPose'];
    exerciseTimeAllotted = json['exerciseTimeAllotted'];
    frameStatus = getFrameStatusList(json['frameStatus']);
    streakMap = getStreakMapList(json['streakMap']);
  }

  List<FrameStatus> getFrameStatusList(List<dynamic> list) {
    List<FrameStatus> result = [];
    for (var element in list) {
      var je = json.encode(element).toString();
      result.add(FrameStatus.fromJson(json.decode(je)));
    }
    return result;
  }

  List<StreakMap> getStreakMapList(List<dynamic> list) {
    List<StreakMap> result = [];
    for (var element in list) {
      var je = json.encode(element).toString();
      result.add(StreakMap.fromJson(json.decode(je)));
    }
    return result;
  }
}

class FrameStatus {
  FrameStatus(this.status, this.time);
  late int status;
  late int time;

  toJson() => {"status": status, "time": time};

  FrameStatus.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    time = json['time'];
  }
}

class StreakMap {
  StreakMap(this.streakStatus, this.streakStartTime, this.streakEndTime,
      this.streakMeanTime, this.streakTime);
  late int streakStatus;
  late int streakStartTime;
  late int streakEndTime;
  late int streakMeanTime;
  late int streakTime;

  toJson() => {
        "streakStatus": streakStatus,
        "streakStartTime": streakStartTime,
        "streakEndTime": streakEndTime,
        "streakMeanTime": streakMeanTime,
        "streakTime": streakTime,
      };

  StreakMap.fromJson(Map<String, dynamic> json) {
    streakStatus = json['streakStatus'];
    streakStartTime = json['streakStartTime'];
    streakEndTime = json['streakEndTime'];
    streakMeanTime = json['streakMeanTime'];
    streakTime = json['streakTime'];
  }
}
