import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:health_connector/screens/exercises_screen.dart';
import 'package:health_connector/screens/login_screen.dart';

import 'screens/internet_error.dart';

class Constants {
  const Constants._();

// From Anthony
// #662D91 purple
// #262262 dark purple
// #25AAE1
  static const double accuracy = 10.0;
  static const String loading = 'Loading ...';
  static const Color appBackgroundColor = Color(0xffffffff);
  static const Color appBarColor = Color(0xFF7E57C2);
  static const Color exerciseDefaultBackgroundColor = Colors.black;
  static const Color primaryTextColor = Colors.white;
  static const Color primaryColor = Color(0xFF7E57C2);
  static const Color secondaryColor = Colors.white;

  static ThemeData appTheme = ThemeData(
      brightness: Brightness.light,
      primaryColor: primaryColor,
      primarySwatch: Colors.blue,
      fontFamily: 'Georgia',
      textTheme: const TextTheme(
          headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind')));

  static const String signIn = 'signin';
  static const String signUp = 'signup';
  static const String pwReset = 'pwreset';
  static const String splashScreen = 'splashscreen';
  static const String internetError = 'internetscreen';
  static const String exerciseScreen = 'exercise_screen';
  static const String poseDetectorScreen = 'posedetectorscreen';
  static const String signUpWithApple = 'signup_with_apple';
  static const String signUpWithGoogle = 'signup_with_gmail';
  static const String storyScreen = "stories_screen";
  static const String pinCodeScreen = "pincode_screen";
  static Map<String, WidgetBuilder> myroutes = <String, WidgetBuilder>{
    signIn: (BuildContext context) => const LoginPage(),
    // PW_RESET: (BuildContext context) => ResetPasswordScreen(),
    exerciseScreen: (BuildContext context) => const ExercisePage(),
    // STORY_SCREEN: (BuildContext context) => StoryScreen(),
    // VIP_SCREEN: (BuildContext context) => VipInfo(),
    internetError: (BuildContext context) => const InternetError(),
  };

  static showMessage(BuildContext context, String message) =>
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));

  static FirebaseOptions firebaseOptions() => FirebaseOptions(
      appId: Constants.firebaseAPIKey,
      apiKey: Constants.firebaseAppID,
      projectId: Constants.firebaseProjectId,
      storageBucket: Constants.firebaseStorageBucket,
      messagingSenderId: Constants.measurementId,
      measurementId: Constants.measurementId,
      databaseURL: Constants.firebaseDatabaseUrl);

  static const String firebaseProjectId = 'livvinyl-health-connector';
  static const String firebaseDatabaseUrl =
      'https://livvinyl-health-connector-default-rtdb.firebaseio.com';

  static String firebaseAPIKey = 'AIzaSyDQIByqxJQERYTYrPet9SNZ2lH1WogQrAk';

  static String firebaseAppID = '1:335396837024:web:87afe595e8f716210c9bc5';

  static String firebaseStorageBucket = 'livvinyl-health-connector.appspot.com';

  static const String dbRoot = 'healthconnector';

  static const String messagingSenderId = '335396837024';

  static const String measurementId = 'G-XJVZYTYMVZ';
}
