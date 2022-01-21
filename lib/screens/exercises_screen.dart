import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:health_connector/constants.dart';
import 'package:health_connector/enums/enums.dart';
import 'package:health_connector/main.dart';
import 'package:health_connector/models/exercise_meta.dart';
import 'package:health_connector/screens/pose_detector_view.dart';
import 'package:health_connector/services/firebase/firebase_rtdb_services.dart';
import 'package:health_connector/util/enum_utils.dart';

import 'components/exercise_widget.dart';

class ExercisePage extends StatefulWidget {
  const ExercisePage({Key? key}) : super(key: key);

  @override
  _ExercisePageState createState() => _ExercisePageState();
}

class _ExercisePageState extends State<ExercisePage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late Size _size;

  @override
  initState() => super.initState();

  // TODO-Sikander get Exercise(s) Meta information.
  // Check if Firebase is connected.
  // Check app is logged in.
  Future<List<ExerciseMeta>>? _getExercisesMeta() async =>
      ExerciseMeta.listFromMap(await FirebaseRtdbServices.getDataAtNode(
          FirebaseRtdbServices.getDatabaseReferenceRecursively(
              rootNode: 'healthconnector', nodes: ['exercises'])));

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Constants.appBarColor,
        appBar: AppBar(backgroundColor: Constants.appBarColor, elevation: 0),
        body: Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
                backgroundColor: Constants.appBarColor,
                automaticallyImplyLeading: false,
                title: const Text('Exercises',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontStyle: FontStyle.normal,
                        fontFamily: 'Lexend Deca',
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold)),
                centerTitle: false,
                elevation: 0,
                actions: _appBarActions()),
            backgroundColor: Constants.appBackgroundColor,
            body: _body()));
  }

  List<Widget> _appBarActions() => [
        prefs.getBool('isAdmin') != null && prefs.getBool('isAdmin') != false
            ? IconButton(
                onPressed: _addExercise, icon: const Icon(Icons.add, size: 32))
            : Container()
      ];
  _addExercise() => openPoseDetector(context, addNew: true);
  _body() => FutureBuilder(
      future: _getExercisesMeta(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return _progressIndicator();
          case ConnectionState.none:
            return _progressIndicator();
          case ConnectionState.active:
            return _progressIndicator();
          case ConnectionState.done:
            return _exercises(snapshot.data as List<ExerciseMeta>);
        }
      });

  _progressIndicator() => const Center(child: CircularProgressIndicator());

  _exercises(List<ExerciseMeta> metaData) => ListView.builder(
      itemCount: metaData.length,
      itemBuilder: (context, index) => Padding(
          padding: EdgeInsets.only(
              left: _size.width / 16,
              right: _size.width / 16,
              top: _size.height / 48),
          child: exerciseWidget(
              size: _size,
              coverImageUrl: metaData[index].coverImageUrl!,
              context: context,
              title: metaData[index].title,
              description: metaData[index].description,
              exerciseType: metaData[index].exerciseType)));

  void onFloatPressed() async {
    var dbRef = FirebaseRtdbServices.getDatabaseReferenceRecursively(
        rootNode: 'healthconnector', nodes: ['exercises']);

    var map = await FirebaseRtdbServices.getDataAtNode(dbRef);

    var list = ExerciseMeta.listFromMap(map);
  }
}
