import 'dart:convert';
import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants.dart';
import 'globals.dart';
import 'log/logger.dart';
import 'models/UserProfile.dart';

List<CameraDescription> cameras = [];
CameraController? cameraController;
FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
late FirebaseDatabase firebaseDatabase;
late FirebaseApp firebaseApp;
bool isFirebaseRTDInitialized = false;
late SharedPreferences prefs;
UserProfile userProfile = UserProfile();
String initialRoute = Constants.logIn;
FlutterTts flutterTts = FlutterTts();

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  Logger.debug("Handling a background message: ${message.messageId}");
}

main() {
  WidgetsFlutterBinding.ensureInitialized();
  _initMain();
}

_initMain() {
  Globals.lookupInternet().then((value) async {
    prefs = await SharedPreferences.getInstance();
    // prefs.clear();
    prefs.setBool('isAdmin', true);
    if (value) {
      await Globals.initFirebase();

      var fcmtoken = await firebaseMessaging.getToken();
      Logger.info(fcmtoken ?? 'No firebase token received');
      if (fcmtoken != null) {
        prefs.setString('fcmToken', fcmtoken);
      }
      if (prefs.getString("userProfile") != null &&
          (prefs.getBool("_isLoggedIn") ?? false)) {
        Logger.info("User already LoggedIn");

        initialRoute = Constants.userHomeScreen;
        userProfile =
            UserProfile.fromJson(json.decode(prefs.getString("userProfile")!));

        await Globals.getProfileRemote();

        if (userProfile.data!.firebaseToken != prefs.getString('fcmToken')) {
          await Globals.updateFirebaseToken();
          userProfile.data!.firebaseToken = prefs.getString('fcmToken') ?? '';
        }
      } else {
        Logger.info("User not LoggedIn");
      }
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
        initialRoute: initialRoute,
      );
}
