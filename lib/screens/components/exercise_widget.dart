import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:octo_image/octo_image.dart';

import '../../constants.dart';
import '../../models/exercise_meta.dart';
import '../pose_detector_view.dart';

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

_exerciseActions(BuildContext context, ExerciseMeta meta) => Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          meta.isARAvailable
              ? iconButton(
                  text: 'AR',
                  backgroundColor: Colors.blue,
                  onPressed: () => _onArPressed(context, meta),
                  icon: const Icon(Icons.view_in_ar, color: Colors.white))
              : Container(),
          meta.isVideoAvailable
              ? iconButton(
                  text: 'Video',
                  backgroundColor: Constants.appBarColor,
                  onPressed: () => _onVideoPressed(context),
                  icon: const Icon(Icons.ondemand_video, color: Colors.white))
              : Container()
        ]);

_onArPressed(BuildContext context, ExerciseMeta meta) {
  openPoseDetector(context, meta);
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

openPoseDetector(BuildContext context, ExerciseMeta meta,
        {bool addNew = false}) =>
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                PoseDetectorView(addNew: addNew, meta: meta)));

_onVideoPressed(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Team Please provide videos for exercises')));
}
