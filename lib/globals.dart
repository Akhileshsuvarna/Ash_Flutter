import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'constants.dart';
import 'log/logger.dart';
import 'main.dart';
import 'models/UserProfile.dart';

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

      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

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

      await initFirebaseDatabase();
      Logger.info('User granted permission: ${settings.authorizationStatus}');
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
}
