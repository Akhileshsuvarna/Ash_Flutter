// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:flutter_cache_manager/flutter_cache_manager.dart';
// import 'package:health_connector/models/exercise_meta.dart';
// import 'package:health_connector/util/utils.dart';
// // ignore: import_of_legacy_library_into_null_safe

// class ExerciseModelViewer extends StatefulWidget {
//   const ExerciseModelViewer({Key? key, required this.meta}) : super(key: key);
//   final ExerciseMeta meta;

//   @override
//   State<StatefulWidget> createState() => _ExerciseModelViewerState();
// }

// class _ExerciseModelViewerState extends State<ExerciseModelViewer> {
//   @override
//   void initState() {
//     super.initState();
//     _startActivity();
//   }

//   @override
//   void dispose() async {
//     super.dispose();
//   }

//   _startActivity() async {
//     Utils.speak('This is how you will preform exercise ${widget.meta.title}');
//   }

//   // @override
//   // Widget build(BuildContext context) => Scaffold(
//   //       appBar: AppBar(
//   //         title: Text(
//   //           widget.meta.title,
//   //           style: const TextStyle(color: Colors.black),
//   //         ),
//   //         elevation: 0,
//   //         backgroundColor: Colors.transparent,
//   //         iconTheme: const IconThemeData(color: Colors.black),
//   //       ),
//   //       extendBodyBehindAppBar: true,
//   //       body: ModelViewer(
//   //         backgroundColor: const Color.fromARGB(0xFF, 0xEE, 0xEE, 0xEE),
//   //         src: widget.meta.modelUrl,
//   //         alt: widget.meta.title,
//   //         ar: true,
//   //         autoRotate: false,
//   //         cameraControls: true,
//   //         autoPlay: true,
//   //         arModes: const ['scene-viewer', 'quick-look'],
//   //       ),
//   //       floatingActionButton: _floatingActionButton(),
//   //       floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
//   //     );

//   _floatingActionButton() {
//     return null;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<String>(
//       future: chached3DSrc(widget.meta.modelUrlAndroid),
//       builder: (__, AsyncSnapshot<String> snapshot) {
//         if (snapshot.connectionState == ConnectionState.done) {
//           return Scaffold(
//             appBar: AppBar(
//               title: Text(
//                 widget.meta.title,
//                 style: const TextStyle(color: Colors.black),
//               ),
//               elevation: 0,
//               backgroundColor: Colors.transparent,
//               iconTheme: const IconThemeData(color: Colors.black),
//             ),
//             extendBodyBehindAppBar: true,
//             body: ModelViewer(
//               backgroundColor: const Color.fromARGB(0xFF, 0xEE, 0xEE, 0xEE),
//               src: snapshot.data,
//               alt: widget.meta.title,
//               ar: true,
//               autoRotate: false,
//               cameraControls: true,
//               autoPlay: true,
//               arModes: const ['scene-viewer', 'quick-look'],
//             ),
//             floatingActionButton: _floatingActionButton(),
//             floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
//           );
//         } else {
//           return const SizedBox();
//         }
//       },
//     );
//   }

//   Future<String> chached3DSrc(String source) async {
//     final BaseCacheManager _cacheManager = DefaultCacheManager();
//     final fileInfo = await _cacheManager.getFileFromCache(source);

//     if (fileInfo == null || fileInfo.file == null) {
//       unawaited(_cacheManager.downloadFile(source));
//       return source;
//     } else {
//       return "file://" + fileInfo.file.path;
//     }
//   }
// }
