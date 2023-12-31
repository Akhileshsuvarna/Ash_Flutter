import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:health_connector/chat_screen.dart';
import 'package:health_connector/screens/exercises_screen.dart';
import 'package:health_connector/screens/home_screen.dart';
import 'package:health_connector/screens/login_screen.dart';
import 'package:health_connector/screens/questions/question_screen0.dart';
import 'package:health_connector/screens/user_profile_screen.dart';
import 'package:health_connector/services/token_services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'main.dart';
import 'screens/internet_error.dart';
import 'screens/questions/question_screen_1.dart';

class Constants {
  const Constants._();

  static const bool isDebug = true;

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
  static const Color profileBackground = Color(0xFFF5F5F5);
  static const Color unSelectedTab = Color(0xFF58585b);
  static const Color selectedTab = Color(0xFF652c90);

  static Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return primaryColor;
    }
    if (states.any((element) => element.name == "selected")) {
      return primaryColor;
    }
    return Colors.grey;
  }

  static ThemeData appTheme = ThemeData(
      brightness: Brightness.light,
      primaryColor: primaryColor,
      primarySwatch: Colors.blue,
      fontFamily: 'Georgia',
      textTheme: const TextTheme(
          headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind')));
  static const serverUrl =
      'wss://api.deepgram.com/v1/listen?encoding=linear16&sample_rate=16000&language=en-GB';
  static const apiKey = '<your Deepgram API key>';
  static const String logIn = 'logIn';
  static const String signUp = 'signup';
  static const String pwReset = 'pwreset';
  static const String splashScreen = 'splashscreen';
  static const String internetError = 'internetscreen';
  static const String exerciseScreen = 'exercise_screen';
  static const String poseDetectorScreen = 'posedetectorscreen';
  static const String exerciseResultScreen = 'exerciseresultscreen';
  static const String signUpWithApple = 'signup_with_apple';
  static const String signUpWithGoogle = 'signup_with_gmail';
  static const String storyScreen = "stories_screen";
  static const String pinCodeScreen = "pincode_screen";
  static const String userProfileScreen = 'user_profile_screen';
  static const String userHomeScreen = 'home_screen';
  static const String conversationPage = 'chat_screen';
  static const String questionScreen0 = 'QuestionScreen0';
  static const String questionScreen1 = 'QuestionScreen1';
  static const String videoCallScreen = "videoCallScreen";

  static Map<String, WidgetBuilder> myroutes = <String, WidgetBuilder>{
    logIn: (BuildContext context) => const LoginPage(),
    // PW_RESET: (BuildContext context) => ResetPasswordScreen(),
    exerciseScreen: (BuildContext context) => const ExercisePage(),
    // conversationPage: (BuildContext context) => const ConversationPage(),
    userProfileScreen: (BuildContext context) => const UserProfileScreen(),
    questionScreen0: (BuildContext context) => const QuestionScreen0(),
    questionScreen1: (BuildContext context) => const QuestionScreen1(),

    userHomeScreen: (BuildContext context) => const HomeScreen(),
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

  static const String exercises = 'exercises';

  static const String messagingSenderId = '335396837024';

  static const String measurementId = 'G-XJVZYTYMVZ';

  // Agora constants

  static const agoraAppID = "e06a6c1e2e5e4aa9bb2804d6213c06d7";

  static const tokenServerBaseUrl = 'healthconnector-token-server.web.app';
  static const tokenServerVideoPublisherWithUid = '/rtc/video/publisher/uid/';
  static agoraGetAudioChannelPath({required String channelName}) =>
      '/rtc/$channelName/publisher/uid/0';
  static const defaultVideoChannelExpiry = '?expiry=3600';

  static const agoraSendInviteUrl =
      '/invite/:userid/:roomId/:inviteType/:agoraSessionToken';

  static String getAgoraInviteUrl(
      {required String senderUid,
        required String roomID,
        required RtcCallType inviteType,
        required String channelName,
        required agoraSessionToken}) =>
      '/invite/$senderUid/$roomID/${inviteType == RtcCallType.audio ? 'audio' : 'video'}/$channelName/$agoraSessionToken';

  static String getPublisherVideoURLWithUid({int uid = 0}) =>
      tokenServerBaseUrl +
          tokenServerVideoPublisherWithUid +
          uid.toString() +
          defaultVideoChannelExpiry;

  static String getPublisherAudioURLWithUid({int uid = 0}) =>
      tokenServerBaseUrl +
          tokenServerVideoPublisherWithUid +
          uid.toString() +
          defaultVideoChannelExpiry;

  static void logout(BuildContext context) async {
    await prefs.clear();
    await FirebaseAuth.instance.signOut();
    initialRoute = Constants.logIn;
  }

  // To reciveve call in background systemAlertWindow is [required]
  static Future<bool> isSystemAlertWindowPermissionGranted() async {
    if (Platform.isAndroid) {
      return await Permission.systemAlertWindow.isGranted;
    } else {
      return true;
    }
  }

  // opens settings for systemAlertWindow permission
  static Future<bool> openSettingsForSystemAlertWindowPermission() async {
    if (Platform.isAndroid) {
      return await Permission.systemAlertWindow.request().isGranted;
    } else {
      return true;
    }
  }
}