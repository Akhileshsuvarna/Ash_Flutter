import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:octo_image/octo_image.dart';

import '../../constants.dart';
import '../pose_detector_view.dart';

Widget exerciseWidget(
        {required Size size,
        required String coverImageUrl,
        required String blurHash,
        required String title,
        required String description,
        required BuildContext context}) =>
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
              image: CachedNetworkImageProvider(coverImageUrl),
              placeholderBuilder: OctoPlaceholder.blurHash(blurHash),
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
                          child: _exerciseTitle(title),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: size.height / 256),
                    child: _exerciseDescription(description),
                  ),
                  Expanded(
                    child: Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(16, 4, 16, 16),
                      child: _exerciseActions(context),
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

_exerciseActions(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          iconButton(
              text: 'AR',
              backgroundColor: Colors.blue,
              onPressed: () => _onArPressed(context),
              icon: const Icon(Icons.view_in_ar, color: Colors.white)),
          iconButton(
              text: 'Video',
              backgroundColor: Constants.appBarColor,
              onPressed: () => _onVideoPressed(context),
              icon: const Icon(Icons.ondemand_video, color: Colors.white))
        ]);

_onArPressed(BuildContext context) {
  openPoseDetector(context);
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

openPoseDetector(BuildContext context, {bool addNew = false}) => Navigator.push(
    context,
    MaterialPageRoute(
        builder: (context) =>
            PoseDetectorView(addNew: addNew, exerciseName: 'testing')));

_onVideoPressed(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Team Please provide videos for exercises')));
}
