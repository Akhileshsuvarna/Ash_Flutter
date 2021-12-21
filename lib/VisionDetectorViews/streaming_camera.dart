/*
 * ----------------------------------------------------------------------------
 * Copyright © 2009 by Mobile-Technologies Limited. All rights reserved. All intellectual property rights in and/or in
 * the computer program and its related documentation and technology are the sole Mobile-Technologies Limited property.
 * This computer program is under Mobile-Technologies Limited copyright and cannot be in whole or in part reproduced,
 * sublicensed, leased, sold or used in any form or by any means, including without limitation graphic, electronic,
 * mechanical, photocopying, recording, taping or information storage and retrieval systems without Mobile-Technologies
 * Limited prior written consent. The downloading, exporting or reexporting of this computer program or any related
 * documentation or technology is subject to any export rules, including US regulations.
 * ----------------------------------------------------------------------------
 */

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:health_connector/log/logger.dart';
import 'package:health_connector/util/device_utils.dart';
import 'package:health_connector/util/view_utils.dart';

// Ref: https://pub.dev/packages/camera/example
class StreamingCamera extends StatefulWidget {
  final ResolutionPreset resolutionPreset;
  final CameraLensDirection lensDir;
  final bool toggleCamera;
  final bool lockOrientation;
  final Widget childView;
  final onLatestImageAvailable onImage;

  const StreamingCamera(this.resolutionPreset, this.lensDir, this.toggleCamera,
      this.lockOrientation, this.childView, this.onImage);

  @override
  _State createState() => _State();
}

// TODO When we switch camera, there is exception in _cameraPreviewWidget()
class _State extends State<StreamingCamera>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  List<CameraDescription>? _cameras;
  CameraController? _controller;
  double _minAvailableExposureOffset = 0.0;
  double _maxAvailableExposureOffset = 0.0;
  double _currentExposureOffset = 0.0;
  AnimationController? _flashModeControlRowAnimationController;
  Animation<double>? _flashModeControlRowAnimation;
  AnimationController? _exposureModeControlRowAnimationController;
  Animation<double>? _exposureModeControlRowAnimation;
  AnimationController? _focusModeControlRowAnimationController;
  Animation<double>? _focusModeControlRowAnimation;

  @override
  void initState() {
    super.initState();
    _startCamera();
  }

  @override
  void dispose() {
    Logger.debug('StreamingCamera dispose()');

    _controller?.dispose();

    WidgetsBinding.instance?.removeObserver(this);

    _flashModeControlRowAnimationController?.dispose();
    _exposureModeControlRowAnimationController?.dispose();
    _focusModeControlRowAnimationController?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _initialized()
      ? Stack(
          fit: StackFit.expand,
          children: [_cameraPreviewWidget(), _modeControlRowWidget()])
      : ViewUtils.createLoader();

  Future<void> _startCamera() async {
    _cameras = await availableCameras();
    WidgetsBinding.instance?.addObserver(this);

    _flashModeControlRowAnimationController = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
    _flashModeControlRowAnimation = CurvedAnimation(
        parent: _flashModeControlRowAnimationController!,
        curve: Curves.easeInCubic);
    _exposureModeControlRowAnimationController = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
    _exposureModeControlRowAnimation = CurvedAnimation(
        parent: _exposureModeControlRowAnimationController!,
        curve: Curves.easeInCubic);
    _focusModeControlRowAnimationController = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
    _focusModeControlRowAnimation = CurvedAnimation(
        parent: _focusModeControlRowAnimationController!,
        curve: Curves.easeInCubic);

    _onNewCameraSelected();
  }

  // TODO CameraPreview for FRONT camera is mirrored
  CameraPreview _cameraPreviewWidget() => CameraPreview(_controller!,
      child: Stack(children: [
        widget.childView,
        LayoutBuilder(
            builder: (context, constraints) => GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTapDown: (details) => _onViewFinderTap(details, constraints)))
      ]));

  /// Display a bar with buttons to change the flash and exposure modes
  Column _modeControlRowWidget() =>
      Column(mainAxisAlignment: MainAxisAlignment.end, children: [
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              if (widget.toggleCamera)
                IconButton(
                    icon: const Icon(Icons.flip_camera_ios_outlined),
                    color: Colors.blue,
                    onPressed: _onNewCameraSelected),
              IconButton(
                  icon: Icon(Icons.flash_on),
                  color: Colors.blue,
                  onPressed: _onFlashModeButtonPressed),
              IconButton(
                  icon: Icon(Icons.exposure),
                  color: Colors.blue,
                  onPressed: _onExposureModeButtonPressed),
              IconButton(
                  icon: Icon(Icons.filter_center_focus),
                  color: Colors.blue,
                  onPressed: _onFocusModeButtonPressed),
              if (!widget.lockOrientation)
                IconButton(
                    icon: Icon(_controller!.value.isCaptureOrientationLocked
                        ? Icons.screen_lock_rotation
                        : Icons.screen_rotation),
                    color: Colors.blue,
                    onPressed: _onCaptureOrientationLockButtonPressed)
            ]),
        _flashModeControlRowWidget(),
        _exposureModeControlRowWidget(),
        _focusModeControlRowWidget()
      ]);

  SizeTransition _flashModeControlRowWidget() => SizeTransition(
      sizeFactor: _flashModeControlRowAnimation!,
      child: ClipRect(
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
            IconButton(
                icon: Icon(Icons.flash_off),
                color: _controller!.value.flashMode == FlashMode.off
                    ? Colors.orange
                    : Colors.blue,
                onPressed: () => _onSetFlashModeButtonPressed(FlashMode.off)),
            IconButton(
                icon: Icon(Icons.flash_auto),
                color: _controller!.value.flashMode == FlashMode.auto
                    ? Colors.orange
                    : Colors.blue,
                onPressed: () => _onSetFlashModeButtonPressed(FlashMode.auto)),
            IconButton(
                icon: Icon(Icons.flash_on),
                color: _controller!.value.flashMode == FlashMode.always
                    ? Colors.orange
                    : Colors.blue,
                onPressed: () =>
                    _onSetFlashModeButtonPressed(FlashMode.always)),
            IconButton(
                icon: Icon(Icons.highlight),
                color: _controller!.value.flashMode == FlashMode.torch
                    ? Colors.orange
                    : Colors.blue,
                onPressed: () => _onSetFlashModeButtonPressed(FlashMode.torch))
          ])));

  SizeTransition _exposureModeControlRowWidget() {
    final ButtonStyle styleAuto = TextButton.styleFrom(
        primary: _controller!.value.exposureMode == ExposureMode.auto
            ? Colors.orange
            : Colors.blue);
    final ButtonStyle styleLocked = TextButton.styleFrom(
        primary: _controller!.value.exposureMode == ExposureMode.locked
            ? Colors.orange
            : Colors.blue);

    return SizeTransition(
        sizeFactor: _exposureModeControlRowAnimation!,
        child: ClipRect(
            child: Container(
                child: Column(children: [
          const Center(
              child: Text("Exposure Mode", style: TextStyle(fontSize: 18.0))),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                TextButton(
                    child: const Text('AUTO'),
                    style: styleAuto,
                    onPressed: () =>
                        _onSetExposureModeButtonPressed(ExposureMode.auto)),
                TextButton(
                    child: const Text('LOCKED'),
                    style: styleLocked,
                    onPressed: () =>
                        _onSetExposureModeButtonPressed(ExposureMode.locked)),
                TextButton(
                    child: const Text('RESET OFFSET'),
                    style: styleLocked,
                    onPressed: () {
                      _controller!.setExposureOffset(0.0);
                      _onExposureModeButtonPressed();
                      _showInSnackBar('Resetting exposure mode', false);
                    }),
                TextButton(
                    child: const Text('RESET POINT'),
                    style: styleLocked,
                    onPressed: () {
                      _controller!.setExposurePoint(null);
                      _onExposureModeButtonPressed();
                      _showInSnackBar('Resetting exposure point', false);
                    })
              ]),
          const Center(
              child: Text("Exposure Offset", style: TextStyle(fontSize: 18.0))),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(_minAvailableExposureOffset.toString()),
                Slider(
                    value: _currentExposureOffset,
                    min: _minAvailableExposureOffset,
                    max: _maxAvailableExposureOffset,
                    label: _currentExposureOffset.toString(),
                    onChanged: _minAvailableExposureOffset ==
                            _maxAvailableExposureOffset
                        ? null
                        : _setExposureOffset),
                Text(_maxAvailableExposureOffset.toString())
              ])
        ]))));
  }

  SizeTransition _focusModeControlRowWidget() {
    final ButtonStyle styleAuto = TextButton.styleFrom(
        primary: _controller!.value.focusMode == FocusMode.auto
            ? Colors.orange
            : Colors.blue);
    final ButtonStyle styleLocked = TextButton.styleFrom(
        primary: _controller!.value.focusMode == FocusMode.locked
            ? Colors.orange
            : Colors.blue);

    return SizeTransition(
        sizeFactor: _focusModeControlRowAnimation!,
        child: ClipRect(
            child: Column(children: [
          const Center(
              child: Text("Focus Mode", style: TextStyle(fontSize: 18.0))),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                TextButton(
                    child: const Text('AUTO'),
                    style: styleAuto,
                    onPressed: () =>
                        _onSetFocusModeButtonPressed(FocusMode.auto)),
                TextButton(
                    child: const Text('LOCKED'),
                    style: styleLocked,
                    onPressed: () =>
                        _onSetFocusModeButtonPressed(FocusMode.locked)),
                TextButton(
                    child: const Text('RESET'),
                    style: styleLocked,
                    onPressed: () {
                      _controller!.setFocusPoint(null);
                      _showInSnackBar('Resetting focus point', false);
                    })
              ])
        ])));
  }

  void _onViewFinderTap(TapDownDetails details, BoxConstraints constraints) {
    if (_controller != null) {
      final offset = Offset(details.localPosition.dx / constraints.maxWidth,
          details.localPosition.dy / constraints.maxHeight);
      _controller!.setExposurePoint(offset);
      _controller!.setFocusPoint(offset);
    }
  }

  Future<void> _onNewCameraSelected() async {
    await _controller?.stopImageStream();
    await _controller?.dispose();

    _controller = CameraController(_findCamera(), widget.resolutionPreset,
        imageFormatGroup: DeviceUtils.isIOS()
            ? ImageFormatGroup.bgra8888
            : ImageFormatGroup.yuv420,
        enableAudio: false);

    // If the controller is updated then update the UI.
    _controller!.addListener(() {
      ViewUtils.rebuild(this);

      if (_controller!.value.hasError) {
        _showInSnackBar('${_controller!.value.errorDescription}', true);
      }
    });

    try {
      await _controller!.initialize();
      await Future.wait([
        _controller!
            .getMinExposureOffset()
            .then((value) => _minAvailableExposureOffset = value),
        _controller!
            .getMaxExposureOffset()
            .then((value) => _maxAvailableExposureOffset = value)
      ]);

      _controller!.startImageStream(widget.onImage);
    } on CameraException catch (e) {
      _showCameraException(e);
    }

    ViewUtils.rebuild(this);
  }

  CameraDescription _findCamera() {
    CameraDescription? currentCamera = _controller?.description;
    CameraLensDirection? currentDir = currentCamera?.lensDirection;
    CameraLensDirection newDir = currentDir == null
        ? widget.lensDir
        : (CameraLensDirection.front == currentDir
            ? CameraLensDirection.back
            : CameraLensDirection.front);

    for (CameraDescription cameraDescription in _cameras!) {
      if (cameraDescription.lensDirection == newDir) {
        return cameraDescription;
      }
    }

    return _cameras![0]; // should never happen
  }

  void _onFlashModeButtonPressed() {
    if (_flashModeControlRowAnimationController!.value == 1.0) {
      _flashModeControlRowAnimationController!.reverse();
    } else {
      _flashModeControlRowAnimationController!.forward();
      _exposureModeControlRowAnimationController!.reverse();
      _focusModeControlRowAnimationController!.reverse();
    }
  }

  void _onExposureModeButtonPressed() {
    if (_exposureModeControlRowAnimationController!.value == 1.0) {
      _exposureModeControlRowAnimationController!.reverse();
    } else {
      _exposureModeControlRowAnimationController!.forward();
      _flashModeControlRowAnimationController!.reverse();
      _focusModeControlRowAnimationController!.reverse();
    }
  }

  void _onFocusModeButtonPressed() {
    if (_focusModeControlRowAnimationController!.value == 1.0) {
      _focusModeControlRowAnimationController!.reverse();
    } else {
      _focusModeControlRowAnimationController!.forward();
      _flashModeControlRowAnimationController!.reverse();
      _exposureModeControlRowAnimationController!.reverse();
    }
  }

  Future<void> _onCaptureOrientationLockButtonPressed() async {
    if (_controller != null) {
      try {
        if (_controller!.value.isCaptureOrientationLocked) {
          await _controller!.unlockCaptureOrientation();
          _showInSnackBar('Capture orientation unlocked', false);
        } else {
          await _controller!.lockCaptureOrientation();
          _showInSnackBar(
              'Capture orientation locked to ${_controller!.value.lockedCaptureOrientation.toString().split('.').last}',
              false);
        }
      } on CameraException catch (e) {
        _showCameraException(e);
      }
    }
  }

  void _onSetFlashModeButtonPressed(FlashMode mode) {
    _setFlashMode(mode).then((_) {
      _onFlashModeButtonPressed();
      ViewUtils.rebuild(this);
      _showInSnackBar(
          'Flash mode set to ${mode.toString().split('.').last}', false);
    });
  }

  void _onSetExposureModeButtonPressed(ExposureMode mode) {
    _setExposureMode(mode).then((_) {
      _onExposureModeButtonPressed();
      ViewUtils.rebuild(this);
      _showInSnackBar(
          'Exposure mode set to ${mode.toString().split('.').last}', false);
    });
  }

  void _onSetFocusModeButtonPressed(FocusMode mode) {
    _setFocusMode(mode).then((_) {
      _onFocusModeButtonPressed();
      ViewUtils.rebuild(this);
      _showInSnackBar(
          'Focus mode set to ${mode.toString().split('.').last}', false);
    });
  }

  Future<void> _setFlashMode(FlashMode mode) async {
    try {
      await _controller?.setFlashMode(mode);
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  Future<void> _setExposureMode(ExposureMode mode) async {
    try {
      await _controller?.setExposureMode(mode);
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  Future<void> _setExposureOffset(double offset) async {
    if (_controller != null) {
      ViewUtils.rebuild(this, fn: () => _currentExposureOffset = offset);

      try {
        offset = await _controller!.setExposureOffset(offset);
      } on CameraException catch (e) {
        _showCameraException(e);
        rethrow;
      }
    }
  }

  Future<void> _setFocusMode(FocusMode mode) async {
    try {
      await _controller?.setFocusMode(mode);
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  void _showCameraException(CameraException e) =>
      _showInSnackBar('Error: ${e.code}\n${e.description}', true);

  void _showInSnackBar(String text, bool error) =>
      ViewUtils.toast(text, error, context);

  bool _initialized() =>
      _cameras != null &&
      _controller != null &&
      _controller!.value.isInitialized;
}
