import 'package:flutter/material.dart';
import 'package:health_connector/constants.dart';
import 'package:health_connector/enums/enums.dart' as enums;
import 'package:health_connector/models/assets.dart';
import 'package:health_connector/models/exercise_meta.dart';
import 'package:health_connector/screens/add_exercise.dart';
import 'package:health_connector/services/firebase/firebase_rtdb_services.dart';

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
  Future<List<ExerciseMeta>?> _getExercisesMeta() async {
    var data = await FirebaseRtdbServices.getDataAtNode(
        FirebaseRtdbServices.getDatabaseReferenceRecursively(
            rootNode: Constants.dbRoot, nodes: ['exercises']));
    return _validateExerciseMeta(data) ? ExerciseMeta.listFromMap(data) : null;
  }

  bool _validateExerciseMeta(dynamic data) {
    return true;
  }

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    return Scaffold(
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
          // actions: _appBarActions(),
        ),
        backgroundColor: Constants.appBackgroundColor,
        body: _body());
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
              Navigator.of(context)
                  .pushReplacementNamed(Constants.userProfileScreen);
            },
            icon: const Icon(
              Icons.account_circle_sharp,
              size: 40,
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
            return _progressIndicator();
          case ConnectionState.none:
            return _progressIndicator();
          case ConnectionState.active:
            return _progressIndicator();
          case ConnectionState.done:
            return snapshot.data != null
                ? _exercises(snapshot.data as List<ExerciseMeta>)
                : const Center(
                    child: Text(
                        'We are sorry for the inconvenience, our team is working on getting the right services for you'));
        }
      });

  _progressIndicator() => const Center(child: CircularProgressIndicator());

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
                if (index == 2)
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: EdgeInsets.only(
                          // left: _size.width / 16,
                          // right: _size.width / 16,
                          top: _size.height / 48,
                          bottom: _size.height / 8),
                      child: Row(
                        children: [
                          // scanWidget(
                          //     size: _size,
                          //     context: context,
                          //     text: "Face Scan",
                          //     imagePath: Assets.ahiFaceScan,
                          //     type: enums.ScanType.face),
                          // scanWidget(
                          //     size: _size,
                          //     context: context,
                          //     text: "Body Scan",
                          //     imagePath: Assets.ahiBodyScan,
                          //     type: enums.ScanType.body),
                          // scanWidget(
                          //     size: _size,
                          //     context: context,
                          //     text: "Derma Scan",
                          //     imagePath: Assets.ahiDermaScan,
                          //     type: enums.ScanType.derma),
                        ],
                      ),
                    ),
                  ),
              ],
            )),
      );

  void onFloatPressed() async {
    // var dbRef = FirebaseRtdbServices.getDatabaseReferenceRecursively(
    //     rootNode: 'healthconnector', nodes: ['exercises']);

    // var map = await FirebaseRtdbServices.getDataAtNode(dbRef);

    // var list = ExerciseMeta.listFromMap(map);
  }
}
