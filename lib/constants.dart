import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:health_connector/screens/exercises_screen.dart';
import 'package:health_connector/screens/login_screen.dart';

import 'VisionDetectorViews/pose_detector_view.dart';
import 'screens/internet_error.dart';

class Constants {
  const Constants._();

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
  static const String homeScreen = 'home';
  static const String poseDetectorScreen = 'posedetectorscreen';
  static const String signUpWithApple = 'signup_with_apple';
  static const String signUpWithGoogle = 'signup_with_gmail';
  static const String storyScreen = "stories_screen";
  static const String pinCodeScreen = "pincode_screen";
  static Map<String, WidgetBuilder> myroutes = <String, WidgetBuilder>{
    signIn: (BuildContext context) => const LoginPage(),
    // PW_RESET: (BuildContext context) => ResetPasswordScreen(),
    homeScreen: (BuildContext context) => const ExercisePage(),
    // STORY_SCREEN: (BuildContext context) => StoryScreen(),
    // VIP_SCREEN: (BuildContext context) => VipInfo(),
    internetError: (BuildContext context) => const InternetError(),
  };

  static const String firebaseProjectId = 'livvinyl-health-connector';
  static const String firebaseDatabaseUrl =
      'https://livvinyl-health-connector-default-rtdb.firebaseio.com/healthconnector';

  static String getFirebaseAPIKey() => Platform.isIOS
      ? 'AIzaSyAlqq6PZylLKD5C0sN0wRPvTpbHry1Yl4w'
      : 'AIzaSyD8CtMLbQa6VLVhZokj8aPZykyfkIEPd9E';

  static String getFirebaseAppId() => Platform.isIOS
      ? '1:335396837024:ios:0c0696df1d939def0c9bc5'
      : '1:335396837024:android:ee1ef1184ae484920c9bc5';
}
