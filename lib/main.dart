import 'dart:io';

import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';
import 'VisionDetectorViews/pose_detector_view.dart';

List<CameraDescription> cameras = [];

FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

late FirebaseDatabase firebaseDatabase;
late FirebaseApp firebaseApp;
bool isFirebaseRTDInitialized = false;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  cameras = await availableCameras();
  runApp(MyApp());
}

// void main() => runApp(const MaterialApp(home: CameraAwesomeStream()));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Livvinyl Fitness App'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  // CustomCard(
                  //   'Face Detector',
                  //   FaceDetectorView(),
                  //   featureCompleted: true,
                  // ),
                  // CustomCard(
                  //   'Barcode Scanner',
                  //   BarcodeScannerView(),
                  //   featureCompleted: true,
                  // ),

                  CustomCard(
                    'Exercise 1',
                    PoseDetectorView(),
                    featureCompleted: true,
                  ),

                  // CustomCard(
                  //   'Digital Ink Recogniser',
                  //   DigitalInkView(),
                  //   featureCompleted: true,
                  // ),
                  // CustomCard(
                  //   'Text Detector',
                  //   TextDetectorView(),
                  //   featureCompleted: true,
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  final String _label;
  final Widget _viewPage;
  final bool featureCompleted;

  const CustomCard(this._label, this._viewPage,
      {this.featureCompleted = false});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.only(bottom: 10),
      child: ListTile(
        tileColor: Theme.of(context).primaryColor,
        title: Text(
          _label,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        onTap: () {
          if (Platform.isIOS && !featureCompleted) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content:
                    Text('This feature has not been implemented for iOS yet')));
          } else
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => _viewPage));
        },
      ),
    );
  }
}
