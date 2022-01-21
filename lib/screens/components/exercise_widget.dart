import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:health_connector/enums/enums.dart';
import 'package:health_connector/util/enum_utils.dart';

import '../../constants.dart';
import '../pose_detector_view.dart';

Widget exerciseWidget(
        {required Size size,
        required String coverImageUrl,
        required String title,
        required String description,
        required ExerciseType exerciseType,
        required BuildContext context}) =>
    SizedBox(
        width: size.width,
        height: size.height / 4.5,
        child: Stack(children: [
          CachedNetworkImage(
              imageUrl: coverImageUrl,
              imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: imageProvider, fit: BoxFit.cover))),
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  CircularProgressIndicator(value: downloadProgress.progress),
              errorWidget: (context, url, error) => const Icon(Icons.error)),
          SizedBox(
              child: Column(mainAxisSize: MainAxisSize.max, children: [
            Padding(
                padding: EdgeInsets.only(top: size.height / 48),
                child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [Expanded(child: _exerciseTitle(title))])),
            Padding(
                padding: EdgeInsets.only(top: size.height / 256),
                child: _exerciseDescription(description)),
            Expanded(
                child: Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(16, 4, 16, 16),
                    child: _exerciseActions(exerciseType, context)))
          ]))
        ]));
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

_exerciseActions(ExerciseType exerciseType, BuildContext context) => Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          iconButton(
              text: 'AR',
              backgroundColor: Colors.blue,
              onPressed: () => _onArPressed(exerciseType, context),
              icon: const Icon(Icons.view_in_ar, color: Colors.white)),
          iconButton(
              text: 'Video',
              backgroundColor: Constants.appBarColor,
              onPressed: () => _onVideoPressed(exerciseType, context),
              icon: const Icon(Icons.ondemand_video, color: Colors.white))
        ]);

_onArPressed(ExerciseType exerciseType, BuildContext context) {
  if (_isExerciseImplemented(exerciseType)) {
    openPoseDetector(context, exerciseType: exerciseType);
  } else {
    var txt =
        'Exercise ${EnumUtils.getName(exerciseType)} has not implemented yet';
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(txt)));
    // speak(txt);
  }
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
            style: const TextStyle(color: Constants.secondaryColor)));

openPoseDetector(BuildContext context,
        {ExerciseType? exerciseType, bool addNew = false}) =>
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PoseDetectorView(
                  exerciseType: exerciseType,
                  addNew: addNew,
                )));

bool _isExerciseImplemented(ExerciseType exerciseType) {
  if (exerciseType == ExerciseType.catcow ||
      exerciseType == ExerciseType.sphinx) {
    return true;
  } else {
    return false;
  }
}

_onVideoPressed(ExerciseType exerciseType, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
          'Team Please provide videos for exercises ${EnumUtils.getName(exerciseType)}')));
}
