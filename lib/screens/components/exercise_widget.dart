import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:native_ar_viewer/native_ar_viewer.dart';
import 'package:native_ar_viewer/native_ar_viewer_platform_interface.dart';
import 'package:octo_image/octo_image.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import '../../constants.dart';
import '../../main.dart';
import '../../models/exercise_meta.dart';
import '../exercise_model_viewer.dart';
import '../pose_detector_view.dart';
import '../video_screen.dart';

Widget exerciseWidget(
        {required Size size,
        required BuildContext context,
        required ExerciseMeta meta}) =>
    ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: size.width,
        height: size.height / 4.5,
        color: Colors.black,
        child: Stack(
          fit: StackFit.expand,
          children: [
            OctoImage(
              image: CachedNetworkImageProvider(meta.coverImageUrl),
              placeholderBuilder: OctoPlaceholder.blurHash(meta.blurHash),
              errorBuilder: OctoError.icon(color: Colors.red),
              fit: BoxFit.cover,
            ),
            SizedBox(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: size.height / 48),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: _exerciseTitle(meta.title),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: size.height / 256),
                    child: _exerciseDescription(
                        '${meta.exerciseDuration}m | ${meta.exerciseIntensity} Intensity | ${meta.exerciseLocation}'),
                  ),
                  Expanded(
                    child: Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(16, 4, 16, 16),
                      child: _exerciseActions(context, meta),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

_exerciseTitle(String title) => Text(
      title,
      textAlign: TextAlign.center,
      style: GoogleFonts.poppins(
          textStyle: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.w700, fontSize: 24)),
      // style: const TextStyle(
      //     fontFamily: 'Lexend Deca',
      //     color: Colors.white,
      //     fontWeight: FontWeight.bold,
      //     fontSize: 24),
    );

_exerciseDescription(String description) => Text(
      description,
      textAlign: TextAlign.center,
      style: GoogleFonts.poppins(
          textStyle: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.w400, fontSize: 14)),
    );

_exerciseActions(BuildContext context, ExerciseMeta meta) => Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          meta.isARAvailable
              ? iconButton(
                  text: 'Start',
                  backgroundColor: Colors.blue,
                  onPressed: () => _onArPressed(context, meta),
                  icon: const Icon(Icons.view_in_ar, color: Colors.white))
              : Container(),
          meta.isVideoAvailable
              ? iconButton(
                  text: 'Video',
                  backgroundColor: Constants.appBarColor,
                  onPressed: () => _onVideoPressed(context, meta),
                  icon: const Icon(Icons.ondemand_video, color: Colors.white))
              : Container()
        ]);

_onArPressed(BuildContext context, ExerciseMeta meta) {
  _openPoseDetector(context, meta);
}

_onVideoPressed(BuildContext context, ExerciseMeta meta) {
  pushNewScreen(
    context,
    screen: VideoScreen(meta: meta),
    withNavBar: false,
    pageTransitionAnimation: PageTransitionAnimation.cupertino,
  );

  // Navigator.push(
  //   context,
  //   MaterialPageRoute(
  //     builder: (BuildContext context) => VideoScreen(meta: meta),
  //   ),
  // );
}

iconButton(
        {required String text,
        required Color backgroundColor,
        required Icon icon,
        required Function() onPressed}) =>
    ElevatedButton.icon(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(backgroundColor)),
        onPressed: onPressed,
        icon: icon,
        label: Text(text,
            style: GoogleFonts.poppins(
                textStyle: const TextStyle(color: Colors.white))));

_openPoseDetector(BuildContext context, ExerciseMeta meta,
    {bool addNew = false}) {
  // Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //         builder: (context) => PoseDetectorView(addNew: addNew, meta: meta)));
  pushNewScreen(
    context,
    screen: PoseDetectorView(addNew: addNew, meta: meta),
    withNavBar: false,
    pageTransitionAnimation: PageTransitionAnimation.cupertino,
  );
}

viewModelInAR(BuildContext context, ExerciseMeta meta) async {
  if (Platform.isAndroid) {
    NativeArViewerPlatform.instance.launchAR(meta.modelUrlAndroid);
  } else {
    var modelPath = '$localPath/${meta.modelName}.usdz';
    var modelAtPath = await File(modelPath).exists();
    if (modelAtPath) {
      await NativeArViewerPlatform.instance.launchAR(modelPath);
    } else {
      final dir = Directory(localPath);
      final List<FileSystemEntity> entities = await dir.list().toList();
      for (var element in entities) {
        print('Item at path:$element');
      }
      Constants.showMessage(context, 'Please wait assets are being downloaded');
    }
  }
}
