import 'dart:async';
import 'dart:convert';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectycube_flutter_call_kit/connectycube_flutter_call_kit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:health_connector/services/internet_connectivity.dart';
import 'package:health_connector/services/token_services.dart';
import 'package:health_connector/util/notification_helper.dart';
import 'package:native_device_orientation/native_device_orientation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'services/call_services.dart';
import 'config/app_theme.dart';
import 'constants.dart';
import 'globals.dart';
import 'log/logger.dart';
import 'models/UserProfile.dart';
import 'models/questionaire.dart';

late NativeDeviceOrientation currentDeviceOrientation;
List<CameraDescription> cameras = [];
CameraController? cameraController;
FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
late FirebaseDatabase firebaseDatabase;
late FirebaseApp firebaseApp;
late FirebaseFirestore fireStoreInstance;
bool isFirebaseRTDInitialized = false;
late SharedPreferences prefs;
UserProfile userProfile = UserProfile();
String initialRoute = Constants.logIn;
FlutterTts flutterTts = FlutterTts();
late String localPath;
late StreamSubscription<QuerySnapshot<Map<String, dynamic>>> chatStream;
CallEvent? incomingCallEvent;
final bloc = CallServices();

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  Logger.debug("Handling a background message: ${message.messageId}");

  if (NotificationHelper.isCallInvite(message.data)) {
    var callerData =
        NotificationHelper.parseNotificationDataToCallerData(message.data);
    ConnectycubeFlutterCallKit.setOnLockScreenVisibility(isVisible: true);

    NotificationHelper.showCallNotification(callerData);
  }
}

Future<void> firebaseMessagingForegroundHandler(RemoteMessage message) async {
  Logger.debug("Handling a foreground message: ${message.messageId}");

  if (NotificationHelper.isCallInvite(message.data)) {
    var callerData =
        NotificationHelper.parseNotificationDataToCallerData(message.data);
    ConnectycubeFlutterCallKit.setOnLockScreenVisibility(isVisible: false);

    NotificationHelper.showCallNotification(callerData);
  }
}

late Questionaire questionaireData;

main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FlutterDownloader.initialize();
  FlutterDownloader.registerCallback(downloadCallback);

  localPath = (await getApplicationDocumentsDirectory()).path;

  _initMain();

  ConnectycubeFlutterCallKit.instance.init(
    onCallAccepted: _onCallAccepted,
    onCallRejected: _onCallRejected,
  );

  ConnectycubeFlutterCallKit.onCallRejectedWhenTerminated =
      onCallRejectedWhenTerminated;
  ConnectycubeFlutterCallKit.onCallAcceptedWhenTerminated =
      onCallAcceptedWhenTerminated;
}

Future<void> _onCallAccepted(CallEvent callEvent) async {
  print("the call was accepted $callEvent");
  bloc.callServicesEventSinkAdd = callEvent;
  incomingCallEvent = callEvent;
}

Future<void> _onCallRejected(CallEvent callEvent) async {
  print("the call was rejected");
  bloc.callServicesEventSink.add(callEvent);
  //  incomingCallEvent = callEvent;
}

void downloadCallback(String id, DownloadTaskStatus status, int progress) {
  if (progress == 100) {
    print('All assets downloaded for exercise: ${prefs.getString(id)}');
  }
}

_initMain() {
  Globals.lookupInternet().then((value) async {
    prefs = await SharedPreferences.getInstance();

    // prefs.clear();
    prefs.setBool('isAdmin', true);
    if (value) {
      await Globals.initFirebase();

      // _listenChat();
      _listenOrientation();
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
          userProfile.data!.firebaseToken = prefs.getString('fcmToken') ?? '';
          await Globals.updateFirebaseToken();
        }
      } else {
        Logger.debug("User not LoggedIn");
      }
    } else {
      initialRoute = Constants.internetError;
    }
    cameras = await availableCameras();
    runApp(MultiProvider(providers: [
      // ChangeNotifierProvider(create: (context) => AppTheme.of(context)),
      ChangeNotifierProvider(create: (context) => InternetConnectivity()),
      // Provider(create: (context) => AppTheme.of(context)),
      Provider(create: (context) => AgoraTokenServices()),
    ], child: const HealthConnectorApp()));
    // ], child: LoadingOverlay(child: const HealthConnectorApp()))); // TODO(skandar) use loading overlay when Need ~ Maybe Later.
  });
}

void _listenOrientation() {
  NativeDeviceOrientationCommunicator obj =
      NativeDeviceOrientationCommunicator();
  obj.onOrientationChanged(useSensor: true).listen((event) {
    currentDeviceOrientation = event;
    Logger.info("Device orientation $event");
  });
}

void _listenChat() {
  var x = FirebaseChatCore.instance.rooms();
  chatStream = fireStoreInstance
      .collection('rooms')
      .doc("RpWdNQuTwfmrdioT2qgn")
      .collection("messages")
      .snapshots()
      .listen((event) {
    // Logger.info("chat stream event ${event}");
    if (!event.metadata.hasPendingWrites) {
      if (event.docChanges.length != event.docs.length) {
        for (var element in event.docChanges) {
          if (element.doc.metadata.hasPendingWrites) {
            print("chat stream event new message");
          } else {
            print("chat stream event existing message");
          }
          // print("chat stream event data ${element.doc.data()}");
        }
      }
    }
  }, onError: (error) {
    Logger.info("chat stream error $error");
  }, onDone: () {
    Logger.info("chat stream completed");
  });
}

class HealthConnectorApp extends StatefulWidget {
  const HealthConnectorApp({Key? key}) : super(key: key);

  @override
  createState() => _HealthConnectorAppState();
}

class _HealthConnectorAppState extends State<HealthConnectorApp> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    if (!Provider.of<InternetConnectivity>(context).status) {
      initialRoute = Constants.internetError;
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Constants.appTheme,
      routes: Constants.myroutes,
      initialRoute: initialRoute,
    );
  }
}

Future onCallRejectedWhenTerminated(CallEvent event) async {
    bloc.callServicesEventSink.add(event);
     incomingCallEvent = event;
}

Future onCallAcceptedWhenTerminated(CallEvent event) async {
    bloc.callServicesEventSink.add(event);
     incomingCallEvent = event;
}
