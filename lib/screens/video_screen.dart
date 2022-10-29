import 'package:animated_button/animated_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health_connector/constants.dart';
import 'package:health_connector/screens/components/custom_back_button.dart';
import 'package:video_player/video_player.dart';

import '../globals.dart';
import '../models/exercise_meta.dart';
import 'components/exercise_widget.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({Key? key, required this.meta}) : super(key: key);

  final ExerciseMeta meta;

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late Size _size;
  late VideoPlayerController _controller;

  final ValueNotifier<bool> isInitialized = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _startActivity();
  }

  void _startActivity() async {
    _controller = VideoPlayerController.network(widget.meta.videoUrl);
    await _controller.initialize();
    Future.delayed(
        const Duration(seconds: 2), () => isInitialized.value = true);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: customBackButton(context, color: Colors.black),
        title: const Text('Exercises',
            textAlign: TextAlign.start,
            style: TextStyle(
                fontStyle: FontStyle.normal,
                fontFamily: 'Lexend Deca',
                color: Colors.black,
                fontSize: 28,
                fontWeight: FontWeight.w600)),
        centerTitle: true,
        elevation: 0,
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _videoPlayer(),
          _title(),
          _description(),
          _metaInfo(),
          _arButton(),
        ],
      ),
    );
  }

  Widget _videoPlayer() {
    return ValueListenableBuilder<bool>(
      builder: (BuildContext context, bool value, Widget? child) {
        return value
            ? Container(
                width: _size.width,
                child: Stack(
                    alignment: Alignment.center,
                    fit: StackFit.loose,
                    children: [
                      AspectRatio(
                        aspectRatio: 16.0 / 9.0,
                        child: VideoPlayer(_controller),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _controller.value.isPlaying
                                ? _controller.pause()
                                : _controller.play();
                          });
                        },
                        child: Icon(
                          _controller.value.isPlaying
                              ? Icons.pause
                              : Icons.play_circle,
                          color: _controller.value.isPlaying
                              ? Colors.transparent
                              : Colors.purple.withOpacity(0.7),
                          size: _size.height / 8,
                        ),
                      ),
                    ]),
              )
            : SizedBox(
                height: _size.height / 3,
                child: Center(child: Globals.progressIndicator(size: 150)));
      },
      valueListenable: isInitialized,
    );
  }

  Widget _title() {
    return Padding(
        padding:
            EdgeInsets.only(left: _size.width / 24, top: _size.height / 32),
        child: Row(children: [
          Text(
            'How to do the ${widget.meta.title}',
            style: GoogleFonts.lexendDeca(
              textStyle: const TextStyle(
                color: Colors.purple,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w700,
                fontSize: 26,
              ),
            ),
          )
        ]));
  }

  Widget _description() {
    return Padding(
      padding: EdgeInsets.only(left: _size.width / 24, top: _size.height / 64),
      child: Row(
        children: [
          Container(
            width: _size.width / 1.1,
            child: Text(
              'How to do the ${widget.meta.description}',
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.lexendDeca(
                textStyle: TextStyle(
                  color: Colors.grey[400],
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _metaInfo() => Padding(
        padding:
            EdgeInsets.only(left: _size.width / 24, top: _size.height / 64),
        child: Row(
          children: [
            Text(
              '${widget.meta.exerciseDuration}m | ${widget.meta.exerciseIntensity} Intensity | ${widget.meta.exerciseLocation}',
              textAlign: TextAlign.center,
              style: GoogleFonts.lexendDeca(
                textStyle: const TextStyle(
                  color: Colors.purple,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      );

  Widget _arButton() {
    return Padding(
      padding: EdgeInsets.only(top: _size.height / 32),
      child: AnimatedButton(
        onPressed: () {
          viewModelInAR(context, widget.meta);
        },
        child: Text(
          'Start AR',
          style: GoogleFonts.lexendDeca(
            textStyle: const TextStyle(
              color: Colors.white,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }
}
