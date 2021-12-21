import 'package:flutter/material.dart';
import 'package:health_connector/VisionDetectorViews/pose_detector_view.dart';
import 'package:health_connector/constants.dart';
import 'package:health_connector/enums/enums.dart';
import 'package:health_connector/models/exercise_meta.dart';
import 'package:health_connector/services/firebase/firebase_rtdb_services.dart';
import 'package:health_connector/util/enum_utils.dart';
import 'package:health_connector/util/view_utils.dart';

class ExercisePage extends StatefulWidget {
  const ExercisePage({Key? key}) : super(key: key);

  @override
  _ExercisePageState createState() => _ExercisePageState();
}

class _ExercisePageState extends State<ExercisePage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  List<ExerciseMeta>? _exerciseData;
  late Size _size;
  @override
  initState() {
    super.initState();
    _getExercisesMeta();
  }

  void _getExercisesMeta() async {
    // TODO-Sikander get Exercise(s) Meta information.
    // Check if Firebase is connected.
    // Check app is logged in.
    try {
      var dbRef = FirebaseRtdbServices.getDatabaseReferenceRecursively(
          rootNode: 'healthconnector', nodes: ['exercises']);

      var map = await FirebaseRtdbServices.getDataAtNode(dbRef);

      setState(() => _exerciseData = ExerciseMeta.listFromMap(map));
    } catch (error) {
      ViewUtils.popup(const Text('Error'), Text(error.toString()), context);
    }
  }

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
                elevation: 0),
            backgroundColor: Constants.appBackgroundColor,
            body: _body()));
  }

  _body() =>
      _exerciseData != null ? _exercises(_exerciseData!) : _progressIndicator();

  _progressIndicator() => const Center(child: CircularProgressIndicator());

  _exercises(List<ExerciseMeta> metaData) => ListView.builder(
      itemCount: metaData.length,
      itemBuilder: (context, index) => Padding(
          padding: EdgeInsets.only(
              left: _size.width / 16,
              right: _size.width / 16,
              top: _size.height / 48),
          child: Container(
              width: _size.width,
              height: _size.height / 4.5,
              decoration: BoxDecoration(
                  color: metaData[index].coverImageUrl == null
                      ? Constants.exerciseDefaultBackgroundColor
                      : Colors.black,
                  image: metaData[index].coverImageUrl != null &&
                          metaData[index].coverImageUrl!.length > 1
                      ? DecorationImage(
                          fit: BoxFit.cover,
                          image: Image.network(metaData[index].coverImageUrl!)
                              .image)
                      : null,
                  boxShadow: const [
                    BoxShadow(
                        blurRadius: 3,
                        color: Color(0x33000000),
                        offset: Offset(0, 2))
                  ],
                  borderRadius: BorderRadius.circular(8)),
              child: SizedBox(
                  child: Column(mainAxisSize: MainAxisSize.max, children: [
                Padding(
                    padding: EdgeInsets.only(top: _size.height / 48),
                    child: Row(mainAxisSize: MainAxisSize.max, children: [
                      Expanded(child: _exerciseTitle(metaData[index].title))
                    ])),
                Padding(
                    padding: EdgeInsets.only(top: _size.height / 256),
                    child: _exerciseDescription(metaData[index].description)),
                Expanded(
                    child: Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(16, 4, 16, 16),
                        child: _exerciseActions(metaData[index].exerciseType)))
              ])))));

  _exerciseTitle(String title) => Text(title,
      textAlign: TextAlign.center,
      style: const TextStyle(
          fontFamily: 'Lexend Deca',
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 24));

  _exerciseDescription(String description) => Text(description,
      textAlign: TextAlign.center,
      style: const TextStyle(
          fontFamily: 'Lexend Deca',
          color: Constants.appBackgroundColor,
          fontWeight: FontWeight.normal,
          fontSize: 14));

  _exerciseActions(ExerciseType exerciseType) => Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            iconButton(
                text: 'AR',
                backgroundColor: Colors.blue,
                onPressed: () => _onArPressed(exerciseType),
                icon: const Icon(Icons.view_in_ar, color: Colors.white)),
            iconButton(
                text: 'Video',
                backgroundColor: Constants.appBarColor,
                onPressed: () => _onVideoPressed(exerciseType),
                icon: const Icon(Icons.ondemand_video, color: Colors.white))
          ]);

  _onArPressed(ExerciseType exerciseType) {
    if (_isExerciseImplemented(exerciseType)) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  PoseDetectorView(exerciseType: exerciseType)));
    } else {
      var txt =
          'Exercise ${EnumUtils.getName(exerciseType)} has not implemented yet';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(txt)));
      // speak(txt);
    }
  }

  bool _isExerciseImplemented(ExerciseType exerciseType) {
    if (exerciseType == ExerciseType.catcow) {
      return true;
    } else {
      return false;
    }
  }

  _onVideoPressed(ExerciseType exerciseType) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            'Team Please provide videos for exercises ${EnumUtils.getName(exerciseType)}')));
  }

  void onFloatPressed() async {
    var dbRef = FirebaseRtdbServices.getDatabaseReferenceRecursively(
        rootNode: 'healthconnector', nodes: ['exercises']);

    var map = await FirebaseRtdbServices.getDataAtNode(dbRef);

    var list = ExerciseMeta.listFromMap(map);
  }

  iconButton(
          {required String text,
          required Color backgroundColor,
          required Icon icon,
          required Function() onPressed}) =>
      ElevatedButton.icon(
          style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(backgroundColor)),
          onPressed: onPressed,
          icon: icon,
          label: Text(text,
              style: const TextStyle(color: Constants.secondaryColor)));
}
