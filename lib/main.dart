import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants.dart';
import 'globals.dart';
import 'log/logger.dart';
import 'models/UserProfile.dart';

List<CameraDescription> cameras = [];
CameraController? cameraController;
FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
late FirebaseDatabase firebaseDatabase;
late FirebaseApp firebaseApp;
bool isFirebaseRTDInitialized = false;
late SharedPreferences prefs;
late UserProfile userProfile;
String initialRoute = Constants.signIn;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  Logger.debug("Handling a background message: ${message.messageId}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Globals.lookupInternet().then((value) async {
    prefs = await SharedPreferences.getInstance();
    prefs.setBool('isAdmin', true);
    if (value) {
      firebaseApp = await Firebase.initializeApp();

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
      Logger.info('User granted permission: ${settings.authorizationStatus}');

      var fcmtoken = await _firebaseMessaging.getToken();
      Logger.info(fcmtoken ?? 'No firebase token received');
    } else {
      initialRoute = Constants.internetError;
    }
    cameras = await availableCameras();
    runApp(const HealthConnectorApp());
  });
}

class HealthConnectorApp extends StatelessWidget {
  const HealthConnectorApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      const MaterialApp(debugShowCheckedModeBanner: false, home: Home());
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

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
