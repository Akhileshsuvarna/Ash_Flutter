import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';
import 'constants.dart';
import 'globals.dart';
import 'log/logger.dart';

List<CameraDescription> cameras = [];

FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
late FirebaseDatabase firebaseDatabase;
late FirebaseApp firebaseApp;
bool isFirebaseRTDInitialized = false;

String initialRoute = Constants.signIn;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  Logger.debug("Handling a background message: ${message.messageId}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Globals.lookupInternet().then((value) async {
    if (value) {
      firebaseApp = await Firebase.initializeApp();

      // firebaseApp = await Firebase.initializeApp(
      //   options: FirebaseOptions(
      //     appId: Constants.getFirebaseAppId(),
      //     apiKey: Constants.getFirebaseAPIKey(),
      //     projectId: Constants.firebaseProjectId,
      //     messagingSenderId: '',
      //     databaseURL: Constants.firebaseDatabaseUrl,
      //   ),
      // );
      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);

      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
              alert: true, badge: true, sound: true);

      NotificationSettings settings =
          await _firebaseMessaging.requestPermission(
              alert: true,
              announcement: true,
              badge: true,
              carPlay: false,
              criticalAlert: true,
              provisional: false,
              sound: true);
      await initFirebaseDatabase();
      print('User granted permission: ${settings.authorizationStatus}');

      var fcmtoken = await _firebaseMessaging.getToken();
      Logger.info(fcmtoken ?? 'No firebase token received');
    } else {
      initialRoute = Constants.internetError;
    }
    cameras = await availableCameras();
    runApp(HealthConnectorApp());
  });
}

class HealthConnectorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      MaterialApp(debugShowCheckedModeBanner: false, home: Home());
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Constants.appTheme,
      routes: Constants.myroutes,
      initialRoute: initialRoute);
}

initFirebaseDatabase() async {
  try {
    firebaseDatabase = FirebaseDatabase(app: firebaseApp);

    isFirebaseRTDInitialized = true;
    Logger.info('Firebase RTDB successfully initialized');
  } catch (ex) {
    Logger.error(
        'Error Occured while Initializing Firebase Database = ${ex.toString()}');
  }
}
