import 'dart:io';

import 'package:animated_button/animated_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health_connector/constants.dart';
import 'package:health_connector/log/logger.dart';
import 'package:health_connector/main.dart';
import 'package:health_connector/models/exercise_meta.dart';
import 'package:health_connector/screens/add_exercise.dart';
import 'package:health_connector/screens/components/loading_overlay.dart';
import 'package:health_connector/services/firebase/firebase_rtdb_services.dart';
import 'package:health_connector/services/token_services.dart';
import 'package:health_connector/util/converter.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

import '../globals.dart';
import 'Agora/AudioCallScreen.dart';
import 'Agora/VideoCallScreen.dart';
import 'components/exercise_widget.dart';
import 'login_screen.dart';

class ExercisePage extends StatefulWidget {
  const ExercisePage({Key? key}) : super(key: key);

  @override
  _ExercisePageState createState() => _ExercisePageState();
}

class _ExercisePageState extends State<ExercisePage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late Size _size;

  @override
  void dispose() {
    super.dispose();

    Logger.info("ExercisePage was disposed");
  }

  @override
  initState() {
    super.initState();
  }

  // TODO-Sikander get Exercise(s) Meta information.
  // Check if Firebase is connected.
  // Check app is logged in.
  Future<List<ExerciseMeta>?> _getExercisesMeta() async {
    var data = await FirebaseRtdbServices.getDataAtNode(
        FirebaseRtdbServices.getDatabaseReferenceRecursively(
            rootNode: Constants.dbRoot, nodes: ['exercises']));
    if (_validateExerciseMeta(data)) {
      var metaData = ExerciseMeta.listFromMap(data);
      downloadAssets(metaData);
      return metaData;
    }
    return null;
  }

  bool _validateExerciseMeta(dynamic data) {
    return true;
  }

  downloadAssets(List<ExerciseMeta> data) async {
    for (var element in data) {
      var modelAtPath =
          await File('$localPath/${element.modelName}.usdz').exists();
      if (!modelAtPath) {
        var taskID = await FlutterDownloader.enqueue(
            url: element.modelUrlIOS, savedDir: localPath);
        if (taskID != null) {
          Logger.debug(taskID);
          prefs.setString(taskID, element.title);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // var res = Provider.of<AgoraTokenServices>(context, listen: false)
    //     .generateRTCToken(
    //         RtcCallType.audio, RtcRole.publisher, RtcTokenType.uid);

    _size = MediaQuery.of(context).size;
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        // backgroundColor: Constants.appBarColor,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Text(
          'Exercises',
          textAlign: TextAlign.start,
          style: GoogleFonts.poppins(
            textStyle: const TextStyle(
              fontSize: 28.0,
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.normal,
              color: Colors.black,
            ),
          ),
        ),
        centerTitle: false,
        elevation: 0,
        actions: _appBarActions(),
      ),
      backgroundColor: Constants.appBackgroundColor,
      body: _body(),
    );
  }

  // List<Widget> _appBarActions() => [
  //       prefs.getBool('isAdmin') != null && prefs.getBool('isAdmin') != false
  //           ? IconButton(
  //               onPressed: _addExercise, icon: const Icon(Icons.add, size: 32))
  //           : Container()
  //     ];

  List<Widget> _appBarActions() => [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
            onPressed: () {
              // Navigator.of(context)
              //     .pushReplacementNamed(Constants.userProfileScreen);
            },
            icon: const Center(
              child: Icon(
                Icons.settings,
                size: 28,
                color: Colors.black,
              ),
            ),
          ),
        )
      ];

  _addExercise() => Navigator.push(
      context, MaterialPageRoute(builder: (context) => const AddExercise()));
  _body() => FutureBuilder(
      future: _getExercisesMeta(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Globals.progressIndicator();
          case ConnectionState.none:
            return Globals.progressIndicator();
          case ConnectionState.active:
            return Globals.progressIndicator();
          case ConnectionState.done:
            return snapshot.data != null
                ? _exercises(snapshot.data as List<ExerciseMeta>)
                : const Center(
                    child: Expanded(
                      child: Text(
                          'We are sorry for the inconvenience, our team is working on getting the right services for you'),
                    ),
                  );
        }
      });

  _exercises(List<ExerciseMeta> metaData) => ListView.builder(
        itemCount: metaData.length,
        itemBuilder: (context, index) => Padding(
            padding: EdgeInsets.only(
              left: _size.width / 16,
              right: _size.width / 16,
              top: _size.height / 48,
            ),
            child: Column(
              children: [
                exerciseWidget(
                  size: _size,
                  context: context,
                  meta: metaData[index],
                ),
                if (index == metaData.length - 1)
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 100),
                    child: AnimatedButton(
                      child: Text(
                        'Add Exercise',
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.normal,
                              color: Colors.white),
                        ),
                      ),
                      height: 56,
                      onPressed: () {
                        Constants.showMessage(context, "Feature coming soon !");
                      },
                      color: Converter.hexToColor('#27A9E1')!,
                      // width: _width / 2,
                      duration: 5,
                    ),
                  ),
              ],
            )),
      );
}
