import 'package:flutter/material.dart';
import 'package:health_connector/constants.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({Key? key}) : super(key: key);

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          elevation: 0,),
      body: Container(),
    );
  }
}
