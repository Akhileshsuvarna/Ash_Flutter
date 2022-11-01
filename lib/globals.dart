import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:connectycube_flutter_call_kit/connectycube_flutter_call_kit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:health_connector/models/exercise_meta.dart';
import 'package:health_connector/models/exercise_result.dart';
import 'package:health_connector/models/exercise_score.dart';
import 'package:health_connector/models/user_score.dart';
import 'package:health_connector/util/view_utils.dart';

import 'constants.dart';
import 'log/logger.dart';
import 'main.dart';
import 'models/UserProfile.dart';
import 'models/exercise_transactions.dart';
import 'util/notification_helper.dart';

class Globals {
  Globals._();

  static Future<ConnectivityResult> getConnectivityStatus() async =>
      await (Connectivity().checkConnectivity());

  static Future<bool> lookupInternet() async {
    try {
      final result = await InternetAddress.lookup('www.google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Logger.debug('Internet connected');
      }
    } on SocketException catch (_) {
      Logger.error('Internet not connected');
      return false;
    }
    return true;
  }

  static initFirebaseDatabase() async {
    try {
      firebaseDatabase = FirebaseDatabase.instanceFor(app: firebaseApp);

      isFirebaseRTDInitialized = true;
      Logger.info('Firebase RTDB successfully initialized');
    } catch (ex) {
      Logger.error(
          'Error Occured while Initializing Firebase Database = ${ex.toString()}');
    }
  }

  static initFirebase() async {
    try {
      firebaseApp = await Firebase.initializeApp();
      fireStoreInstance = FirebaseFirestore.instanceFor(app: firebaseApp);

      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

      FirebaseMessaging.onMessageOpenedApp.listen((event) {
        try {
          if (event.data.entries.isNotEmpty) {
            for (var element in event.data.entries) {
              if (element.key == "callInvite") {
                if (NotificationHelper.isCallInvite(event.data)) {
                  var callerData =
                      NotificationHelper.parseNotificationDataToCallerData(
                          event.data);
                  ConnectycubeFlutterCallKit.setOnLockScreenVisibility(
                      isVisible: false);

                  NotificationHelper.showCallNotification(callerData);
                }
              }
            }
          }
          Logger.info("Gotcha ${event.data.entries}");
        } catch (e, stackTrace) {
          Logger.error(e, stackTrace: stackTrace);
        }
      });

      FirebaseMessaging.onMessage.listen(firebaseMessagingForegroundHandler);

      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      NotificationSettings settings = await firebaseMessaging.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: false,
        criticalAlert: true,
        provisional: false,
        sound: true,
      );

      Logger.debug('User granted permission: ${settings.authorizationStatus}');

      await initFirebaseDatabase();
    } catch (error, stackTrace) {
      Logger.error(error, stackTrace: stackTrace);
    }
  }

  static updateFirebaseToken() async {
    await firebaseDatabase
        .ref()
        .child(Constants.dbRoot)
        .child('users')
        .child(userProfile.data!.uuid)
        .child('firebaseToken')
        .set(prefs.getString('fcmToken'));
  }

  static getProfileRemote() async {
    try {
      await firebaseDatabase
          .ref()
          .child(Constants.dbRoot)
          .child('users')
          .child(userProfile.data!.uuid)
          .get()
          .then((snapshot) async {
        if (snapshot.exists) {
          dynamic data = snapshot.value; // as Map<String, dynamic>;
          Map<String, dynamic> parsedmap = {};
          for (int i = 0; i < data.length; i++) {
            parsedmap.addEntries([
              MapEntry(data.entries.elementAt(i).key.toString(),
                  data.entries.elementAt(i).value)
            ]);
          }
          UserProfile tmp = UserProfile(data: Data.fromJson(parsedmap));
          tmp.data = Data.fromJson(parsedmap);
          userProfile = tmp;
          Logger.info("user Profile fetched from Remote");
        }
      });
    } catch (e, stackTrace) {
      Logger.error(
          'Error occured while fetching remote profile ${e.toString()}',
          stackTrace: stackTrace);
    }
  }

  static uploadExerciseResult(ExerciseMeta eMeta, ExerciseScore eScore) async {
    try {
      await firebaseDatabase
          .ref()
          .child(Constants.dbRoot)
          .child('users')
          .child(userProfile.data!.uuid)
          .child('exerciseResults')
          .child(DateTime.now().millisecondsSinceEpoch.toString())
          .set(ExerciseResult(eMeta, eScore).toJson());
      int currentProgresScore = await getCurrentProgressScore();
      int thisExerciseScore =
          ((eScore.framesWithRequiredPose / eScore.framesProcessed) * 100)
              .floor();
      await firebaseDatabase
          .ref()
          .child(Constants.dbRoot)
          .child('users')
          .child(userProfile.data!.uuid)
          .child('progressScore')
          .set(thisExerciseScore + currentProgresScore);
    } catch (e, stackTrace) {
      Logger.error(
          'Error occured while uploading Exercise result to firebase ${e.toString()}',
          stackTrace: stackTrace);
    }
  }

  static Future<int> getCurrentProgressScore() async {
    var snapshot = await firebaseDatabase
        .ref()
        .child(Constants.dbRoot)
        .child('users')
        .child(userProfile.data!.uuid)
        .child('progressScore')
        .get();
    if (snapshot.exists) {
      return snapshot.value as int;
    } else {
      return 0;
    }
  }

  static Future<String> getLastExercisePerformedDate() async {
    var temp = [];
    var snapshot = await firebaseDatabase
        .ref()
        .child(Constants.dbRoot)
        .child('users')
        .child(userProfile.data!.uuid)
        .child('exerciseResults')
        .get();
    if (snapshot.exists) {
      Map<dynamic, dynamic> exercises = snapshot.value as Map<dynamic, dynamic>;

      exercises.forEach((key, value) {
        temp.add(key);
      });
      temp.sort();
      var dt = DateTime.fromMillisecondsSinceEpoch(int.parse(temp.last));

      return '${dt.day}/${dt.month}/${dt.year}';
    } else {
      return '';
    }
  }

  static Future<List<ExerciseTransactions>>
      getLastExerciseTransactions() async {
    List<ExerciseTransactions> result = [];
    var snapshot = await firebaseDatabase
        .ref()
        .child(Constants.dbRoot)
        .child('users')
        .child(userProfile.data!.uuid)
        .child('exerciseResults')
        .get();
    if (snapshot.exists) {
      Map<dynamic, dynamic> exercises = snapshot.value as Map<dynamic, dynamic>;

      exercises.forEach((key, value) {
        Map exerciseResult = value;
        Map eScoreMap = exerciseResult['eScore'];
        Map eMetaMap = exerciseResult['eMeta'];
        var eScore = ExerciseScore.fromJson(
            eScoreMap.map((key, value) => MapEntry(key.toString(), value)));
        var eMeta = ExerciseMeta.fromMap(
            eMetaMap.map((key, value) => MapEntry(key.toString(), value)));
        result.add(ExerciseTransactions(
            eMeta.title,
            ((eScore.framesWithRequiredPose / eScore.framesProcessed) * 100)
                .floor()));
      });
    }
    return result;
  }

  static Future<List<UserScore>> getLeaderScoreBoard() async {
    List<UserScore> result = [];

    try {
      var usersSnapshot = await firebaseDatabase
          .ref()
          .child(Constants.dbRoot)
          .child('users')
          .get();

      if (usersSnapshot.exists) {
        Map<dynamic, dynamic> usersMap =
            usersSnapshot.value as Map<dynamic, dynamic>;
        for (var element in usersMap.entries) {
          if (element.value['progressScore'] != null) {
            result.add(UserScore(
              element.value['name'],
              element.value['photoURL'],
              element.value['progressScore'] ?? 0,
              element.value['uuid'],
            ));
          }
        }
      }
      result.sort((a, b) => b.score.compareTo(a.score));
    } catch (e) {
      Logger.error(e);
    }

    return result;
  }

  static Widget progressIndicator({double size = 200}) =>
      Center(child: ViewUtils.customProgressIndicatorWidget(size: size));
}
