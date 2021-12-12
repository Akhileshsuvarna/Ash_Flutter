import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health_connector/constants.dart';
import 'package:health_connector/log/logger.dart';
import 'package:health_connector/models/exercise_meta.dart';

class ExercisePage extends StatefulWidget {
  const ExercisePage({Key? key}) : super(key: key);

  @override
  _ExercisePageState createState() => _ExercisePageState();
}

class _ExercisePageState extends State<ExercisePage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  initState() {
    super.initState();
  }

  Future<List<ExerciseMeta>> _getExercisesMeta() async {
    // TODO-Sikander get Exercise(s) Meta information.
    // Check if Firebase is connected.
    // Check app is logged in.
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Constants.appBackgroundColor,
        automaticallyImplyLeading: false,
        title: const Text(
          'Exercises',
          textAlign: TextAlign.start,
          style: TextStyle(
            fontFamily: 'Lexend Deca',
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: const [],
        centerTitle: false,
        elevation: 2,
      ),
      backgroundColor: Constants.appBackgroundColor,
      body: FutureBuilder(
          future: _getExercisesMeta(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Center(
                  child: CircularProgressIndicator(),
                );
              case ConnectionState.none:
                return const Center(
                  child: CircularProgressIndicator(),
                );
              case ConnectionState.active:
                return const Center(
                  child: CircularProgressIndicator(),
                );
              case ConnectionState.done:
                List<ExerciseMeta> metaData =
                    snapshot.data as List<ExerciseMeta>;
                return ListView.builder(
                    itemCount: metaData.length,
                    itemBuilder: (context, index) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        height: 184,
                        decoration: BoxDecoration(
                          color: metaData[index].coverImageUrl == null
                              ? Constants.exerciseDefaultBackgroundColor
                              : Colors.transparent,
                          image: metaData[index].coverImageUrl != null
                              ? DecorationImage(
                                  fit: BoxFit.fitWidth,
                                  image: Image.network(
                                    metaData[index].coverImageUrl!,
                                  ).image,
                                )
                              : null,
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 3,
                              color: Color(0x33000000),
                              offset: Offset(0, 2),
                            )
                          ],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: const Color(0x65090F13),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    16, 16, 16, 0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        metaData[index].title,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontFamily: 'Lexend Deca',
                                          color: Colors.white,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    16, 4, 16, 0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        metaData[index].description,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontFamily: 'Lexend Deca',
                                          color: Constants.appBackgroundColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      16, 4, 16, 16),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Logger.debug(
                                              'Button-Reserve pressed ...');
                                        },
                                        child: const Icon(
                                          Icons.view_in_ar,
                                          color: Colors.white,
                                          size: 15,
                                        ),
                                      ),
                                      const Spacer(),
                                      ElevatedButton(
                                        onPressed: () {
                                          Logger.debug(
                                              'Button-Reserve pressed ...');
                                        },
                                        child: const Icon(
                                          Icons.ondemand_video,
                                          color: Colors.white,
                                          size: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    });
            }
          }),
    );
  }
}
