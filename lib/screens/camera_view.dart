import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:health_connector/util/device_utils.dart';
import 'package:native_device_orientation/native_device_orientation.dart';
import 'package:native_screenshot/native_screenshot.dart';
import '../log/logger.dart';
import '../main.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';

class CameraView extends StatefulWidget {
  const CameraView(
      {Key? key,
      required this.customPaint,
      required this.onImage,
      this.initialDirection = CameraLensDirection.back})
      : super(key: key);

  final CustomPaint? customPaint;
  final Function(InputImage inputImage) onImage;
  final CameraLensDirection initialDirection;

  @override
  _CameraViewState createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  int _cameraIndex = 0, mainPointers = 0;
  Orientation? _lastOrientation;
  double _currentScale = 1.0, _baseScale = 1.0, _cW = 0.0, _cH = 0.0;
  final List<double> _availableZoom = [1.0, 1.0]; // min, max
  late Size _size;

  @override
  void initState() {
    super.initState();

    for (var i = 0; i < cameras.length; i++) {
      Logger.info('camera index = $i');

      if (cameras[i].lensDirection == widget.initialDirection) {
        _cameraIndex = 0;
      }
    }
    _startLiveFeed();
  }

  @override
  void dispose() {
    _stopLiveFeed();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _lastOrientation = DeviceUtils.orientation(context);
    _size = MediaQuery.of(context).size;

    // final Size size = DeviceUtils.size(context);
    // final double width = size.width;
    // final double height = size.height;
    // Logger.debug('Device Width = $width');
    // Logger.debug('Device Height = $height');
    // Logger.debug('Frame Width = ${cameraController?.value.previewSize?.width}');
    // Logger.debug(
    //     'Frame Height = ${cameraController?.value.previewSize?.height}');

    // final Widget body = _body(width, height);
    return Scaffold(
        appBar: AppBar(elevation: 0, backgroundColor: Colors.black),
        // extendBodyBehindAppBar: true,
        backgroundColor: Colors.black,
        body: _body(),
        floatingActionButton: _floatingActionButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat);
  }

  Widget? _floatingActionButton() {
    if (cameras.length == 1) return null;
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Padding(
        padding: EdgeInsets.only(left: _size.width / 16),
        child: SizedBox(
          // width: MediaQuery.of(context).size.width / 3,
          height: 70.0,
          width: 70.0,
          child: FloatingActionButton(
              backgroundColor: Colors.black,
              heroTag: 'takescreenshot',
              child: const Icon(Icons.radio_button_checked, size: 60),
              onPressed: () async {
                var path = await NativeScreenshot.takeScreenshot();
                Logger.debug('screenshot path = $path');
              }),
        ),
      ),
      // SizedBox(width: 40),
      // Spacer(),
      SizedBox(
          // width: MediaQuery.of(context).size.width / 3,
          height: 70.0,
          width: 70.0,
          child: FloatingActionButton(
              backgroundColor: Colors.black,
              heroTag: 'flipCamera',
              child: Icon(
                  Platform.isIOS
                      ? Icons.flip_camera_ios_outlined
                      : Icons.flip_camera_android_outlined,
                  size: 40),
              onPressed: _switchLiveCamera))
    ]);
  }

  Widget _body() {
    if (cameraController?.value.isInitialized == false) {
      return Container();
    }
    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      return Stack(fit: StackFit.expand, children: <Widget>[
        CameraPreview(cameraController!),
        if (widget.customPaint != null) widget.customPaint!
      ]);
    } else {
      return ClipRect(
        child: OverflowBox(
          alignment: Alignment.topCenter,
          child: FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: AspectRatio(
                aspectRatio:
                    MediaQuery.of(context).orientation == Orientation.landscape
                        ? cameraController!.value.aspectRatio
                        : 1 / cameraController!.value.aspectRatio,
                child: Stack(fit: StackFit.expand, children: <Widget>[
                  CameraPreview(cameraController!),
                  if (widget.customPaint != null) widget.customPaint!
                ]),
              ),
            ),
          ),
        ),
      );
    }
  }

  // Widget _body(double width, double height) {
  //   final double aspectRatio = _controller!.value.previewSize!.aspectRatio;
  //   final double containerWidth =
  //       _getContainerWidth(width, height, aspectRatio);
  //   final double containerHeight =
  //       _getContainerHeight(width, height, aspectRatio);
  //   final double denominator = DeviceUtils.isSmallDevice(context)
  //       ? 16.0
  //       : (DeviceUtils.isNormalDevice(context) ? 18.0 : 48.0);

  //   return Container(
  //       width: width,
  //       height: height,
  //       color: Colors.black,
  //       child: Stack(children: [
  //         Center(
  //             child: Container(
  //                 width: containerWidth,
  //                 height: containerHeight,
  //                 color: Colors.blue,
  //                 child: Listener(
  //                     onPointerDown: (_) => mainPointers++,
  //                     onPointerUp: (_) => mainPointers--,
  //                     child: CameraPreview(_controller!,
  //                         child: LayoutBuilder(
  //                             builder: (context, constraints) =>
  //                                 GestureDetector(
  //                                     behavior: HitTestBehavior.opaque,
  //                                     onScaleStart: _onScaleStart,
  //                                     onScaleUpdate: _onScaleUpdate,
  //                                     onTapDown: (details) => _onViewFinderTap(
  //                                         details, constraints))))))),
  //         if (widget.customPaint != null) widget.customPaint!
  //       ]));
  // }

  Future _startLiveFeed() async {
    final camera = cameras[_cameraIndex];
    cameraController = CameraController(camera,
        Platform.isAndroid ? ResolutionPreset.low : ResolutionPreset.medium,
        enableAudio: false);
    cameraController?.initialize().then((_) async {
      if (!mounted) {
        return;
      }
      cameraController?.getMinZoomLevel().then((value) {
        _availableZoom[0] = value;
      });
      cameraController?.getMaxZoomLevel().then((value) {
        _availableZoom[1] = value;
      });
      await cameraController
          ?.lockCaptureOrientation(DeviceOrientation.portraitUp);
      cameraController?.startImageStream(_processCameraImage);
      setState(() {});
    });
  }

  Future _stopLiveFeed() async {
    await cameraController?.stopImageStream();
    await cameraController?.dispose();
    cameraController = null;
  }

  Future _switchLiveCamera() async {
    // await _stopLiveFeed();
    if (_cameraIndex == 0) {
      _cameraIndex = 1;
    } else {
      _cameraIndex = 0;
    }
    await _startLiveFeed();
  }

  double _getContainerWidth(double width, double height, double aspectRatio) {
    if (DeviceUtils.isLandscape(context)) {
      if (_cW < 1.0 || !DeviceUtils.isOrientation(_lastOrientation!, context)) {
        _cW = width;

        while (_cW / aspectRatio > height) {
          _cW -= 1.0;
        }
      }

      return _cW;
    }

    return _getContainerHeightPortrait(width, height, aspectRatio) /
        aspectRatio;
  }

  double _getContainerHeight(double width, double height, double aspectRatio) =>
      DeviceUtils.isLandscape(context)
          ? _getContainerWidth(width, height, aspectRatio) / aspectRatio
          : _getContainerHeightPortrait(width, height, aspectRatio);

  double _getContainerHeightPortrait(
      double width, double height, double aspectRatio) {
    if (_cH < 1.0 || !DeviceUtils.isOrientation(_lastOrientation!, context)) {
      _cH = height;

      while (_cH * (1 / aspectRatio) > width) {
        _cH -= 1.0;
      }
    }

    return _cH;
  }

  void _onViewFinderTap(TapDownDetails details, BoxConstraints constraints) {
    if (cameraController != null) {
      final Offset offset = Offset(
          details.localPosition.dx / constraints.maxWidth,
          details.localPosition.dy / constraints.maxHeight);

      cameraController!.setExposurePoint(offset);
      cameraController!.setFocusPoint(offset);
    }
  }

  void _onScaleStart(ScaleStartDetails details) => _baseScale = _currentScale;

  Future<void> _onScaleUpdate(ScaleUpdateDetails details) async {
    // When there are not exactly two fingers on screen don't scale
    if (cameraController != null && mainPointers == 2) {
      _currentScale = (_baseScale * details.scale)
          .clamp(_availableZoom[0], _availableZoom[1]);
      await cameraController!.setZoomLevel(_currentScale);
    }
  }

  Future _processCameraImage(CameraImage image) async {
    final WriteBuffer allBytes = WriteBuffer();
    for (Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    final Size imageSize =
        Size(image.width.toDouble(), image.height.toDouble());

    final camera = cameras[_cameraIndex];

    final imageRotation =
        InputImageRotationValue.fromRawValue(camera.sensorOrientation) ??
            InputImageRotation.rotation0deg;

    final inputImageFormat =
        InputImageFormatValue.fromRawValue(image.format.raw) ??
            InputImageFormat.nv21;

    final planeData = image.planes.map(
      (Plane plane) {
        return InputImagePlaneMetadata(
          bytesPerRow: plane.bytesPerRow,
          height: plane.height,
          width: plane.width,
        );
      },
    ).toList();

    final inputImageData = InputImageData(
      size: imageSize,
      imageRotation: imageRotation,
      inputImageFormat: inputImageFormat,
      planeData: planeData,
    );

    final inputImage =
        InputImage.fromBytes(bytes: bytes, inputImageData: inputImageData);

    widget.onImage(inputImage);
  }
}

int getOrientation() {
  if (currentDeviceOrientation == NativeDeviceOrientation.portraitUp) {
    return 90;
  } else if (currentDeviceOrientation == NativeDeviceOrientation.portraitDown) {
    return 180;
  } else {
    return 0;
  }
}
