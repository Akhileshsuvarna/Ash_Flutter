// /*
//  * ----------------------------------------------------------------------------
//  * Copyright © 2009 by Mobile-Technologies Limited. All rights reserved. All intellectual property rights in and/or in
//  * the computer program and its related documentation and technology are the sole Mobile-Technologies Limited property.
//  * This computer program is under Mobile-Technologies Limited copyright and cannot be in whole or in part reproduced,
//  * sublicensed, leased, sold or used in any form or by any means, including without limitation graphic, electronic,
//  * mechanical, photocopying, recording, taping or information storage and retrieval systems without Mobile-Technologies
//  * Limited prior written consent. The downloading, exporting or reexporting of this computer program or any related
//  * documentation or technology is subject to any export rules, including US regulations.
//  * ----------------------------------------------------------------------------
//  */

// import 'dart:async';
// import 'dart:io';
// import 'dart:typed_data';
// import 'dart:ui' as ui;
// import 'package:camerawesome/camerawesome_plugin.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:image_gallery_saver/image_gallery_saver.dart';
// import 'package:permission_handler/permission_handler.dart';

// class CameraAwesomeStream extends StatefulWidget {
//   const CameraAwesomeStream();

//   @override
//   _State createState() => _State();
// }

// class _State extends State<CameraAwesomeStream> {
//   ValueNotifier<Size> _photoSize = ValueNotifier(Size.infinite);
//   ValueNotifier<Sensors> _sensor = ValueNotifier(Sensors.BACK);
//   ValueNotifier<CaptureModes> _captureMode = ValueNotifier(CaptureModes.PHOTO);
//   bool _doProcess = false;
//   GlobalKey _globalKey = GlobalKey();
//   @override
//   void initState() {
//     super.initState();
//     getPermission();
//   }

//   getPermission() async {
//     var permission = await Permission.storage.request();
//     if (permission.isGranted) {
//       print('Permission Granted');
//       setState(() {
//         _doProcess = true;
//       });
//     }
//   }

//   @override
//   void dispose() {
//     _photoSize.dispose();
//     _sensor.dispose();
//     _captureMode.dispose();

//     super.dispose();
//   }

//   bool busy = false;
//   @override
//   Widget build(BuildContext context) {
//     return _doProcess
//         ? CameraAwesome(
//             key: _globalKey,
//             onPermissionsResult: _onPermissionsResult,
//             selectDefaultSize: (availableSizes) =>
//                 _getDefaultSize(availableSizes),
//             captureMode: _captureMode,
//             photoSize: _photoSize,
//             sensor: _sensor,
//             imagesStreamBuilder: (imageStream) {
//               print("-- init CameraAwesome images stream");

//               imageStream!.listen((Uint8List image) async {
//                 // File('my_image${DateTime.now().millisecondsSinceEpoch}.jpg')
//                 //     .writeAsBytes(image);

//                 final result = await ImageGallerySaver.saveImage(
//                   image,
//                   isReturnImagePathOfIOS: true,
//                 );
//                 print(result);
//                 await _save();

//                 busy = false;
//               });
//             },
//           )
//         : Container();
//   }

//   _onPermissionsResult(bool? granted) {
//     if (!granted!) {
//       print('NOT granted');
//     } else {
//       // setState(() {});
//       print("granted");
//     }
//   }

//   _getDefaultSize(List<Size> availableSizes) {
//     availableSizes.forEach((element) {
//       print('Available Size $element');
//     });
//     return availableSizes[1];
//   }

//   _saveImage(Uint8List image) async {
//     try {
//       print('saving...');
//       final result = await ImageGallerySaver.saveImage(
//         image,
//         isReturnImagePathOfIOS: true,
//       );
//       print(result);
//     } catch (e) {
//       print(e);
//     }
//   }

//   _saveScreen() async {
//     RenderRepaintBoundary boundary =
//         _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
//     ui.Image image = await boundary.toImage();
//     ByteData? byteData = await (image.toByteData(format: ui.ImageByteFormat.png)
//         as FutureOr<ByteData?>);
//     if (byteData != null) {
//       final result =
//           await ImageGallerySaver.saveImage(byteData.buffer.asUint8List());
//       print(result);
//     }
//   }

//   _save() async {
//     var response = await Dio().get(
//         "https://ss0.baidu.com/94o3dSag_xI4khGko9WTAnF6hhy/image/h%3D300/sign=a62e824376d98d1069d40a31113eb807/838ba61ea8d3fd1fc9c7b6853a4e251f94ca5f46.jpg",
//         options: Options(responseType: ResponseType.bytes));
//     final result = await ImageGallerySaver.saveImage(
//         Uint8List.fromList(response.data),
//         quality: 60,
//         name: "hello");
//     print(result);
//   }
// }
