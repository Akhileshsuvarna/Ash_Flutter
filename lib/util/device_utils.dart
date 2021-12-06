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

import 'dart:io' show Platform;

import 'package:flutter/material.dart'
    show
        BuildContext,
        MediaQuery,
        MediaQueryData,
        Size,
        NavigationMode,
        Orientation,
        EdgeInsets,
        Brightness,
        kToolbarHeight;
import 'package:flutter/services.dart' show MethodChannel;

import '../log/logger.dart';

class DeviceUtils {
  // TODO How do we know these numbers? Are they correct?
  static const double screenLarge = 1440.0;
  static const double screenNormal = 1080.0;
  static const double screenSmall = 720.0;

  const DeviceUtils._();

  static MediaQueryData mediaQuery(BuildContext context) =>
      MediaQuery.of(context);

  static Size size(BuildContext context) => mediaQuery(context).size;

  static double width(BuildContext context) => size(context).width;

  static double widthInPx(BuildContext context) =>
      width(context) * pixelRatio(context);

  static double height(BuildContext context) => size(context).height;

  static double heightNoToolbar(BuildContext context) =>
      height(context) - kToolbarHeight;

  static bool isLargeDevice(BuildContext context) =>
      widthInPx(context) >= screenLarge;

  static bool isNormalDevice(BuildContext context) {
    final double threshold = widthInPx(context);
    return threshold >= screenNormal && threshold < screenLarge;
  }

  static bool isSmallDevice(BuildContext context) =>
      widthInPx(context) <= screenSmall;

  static double aspectRatio(BuildContext context) => size(context).aspectRatio;

  static bool accessibleNavigation(BuildContext context) =>
      mediaQuery(context).accessibleNavigation;

  static bool alwaysUse24HourFormat(BuildContext context) =>
      mediaQuery(context).alwaysUse24HourFormat;

  static bool boldText(BuildContext context) => mediaQuery(context).boldText;

  static double pixelRatio(BuildContext context) =>
      mediaQuery(context).devicePixelRatio;

  static bool disableAnimations(BuildContext context) =>
      mediaQuery(context).disableAnimations;

  static bool highContrast(BuildContext context) =>
      mediaQuery(context).highContrast;

  static bool invertColors(BuildContext context) =>
      mediaQuery(context).invertColors;

  static NavigationMode navigationMode(BuildContext context) =>
      mediaQuery(context).navigationMode;

  static Orientation orientation(BuildContext context) =>
      mediaQuery(context).orientation;

  static bool isOrientation(Orientation value, BuildContext context) =>
      orientation(context) == value;

  static bool isPortrait(BuildContext context) =>
      isOrientation(Orientation.portrait, context);

  static bool isLandscape(BuildContext context) =>
      isOrientation(Orientation.landscape, context);

  static EdgeInsets padding(BuildContext context) =>
      mediaQuery(context).padding;

  static Brightness platformBrightness(BuildContext context) =>
      mediaQuery(context).platformBrightness;

  static EdgeInsets systemGestureInsets(BuildContext context) =>
      mediaQuery(context).systemGestureInsets;

  static double textScaleFactor(BuildContext context) =>
      mediaQuery(context).textScaleFactor;

  static EdgeInsets viewInsets(BuildContext context) =>
      mediaQuery(context).viewInsets;

  static EdgeInsets viewPadding(BuildContext context) =>
      mediaQuery(context).viewPadding;

  static bool isAndroid() => Platform.isAndroid;

  static bool isIOS() => Platform.isIOS;

  static bool isMobile() => isAndroid() || isIOS();

  static Future<T?> invokeMethod<T>(String channel, String method) async {
    try {
      return await MethodChannel(channel).invokeMethod(method);
    } catch (e) {
      Logger.error("Error invoking method '$method' of channel '$channel': $e");
      return null;
    }
  }
}
