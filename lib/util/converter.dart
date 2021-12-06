import 'package:flutter/material.dart'
    show Color, TextAlign, TextDirection, FontStyle, Orientation;
import 'package:flutter/services.dart' show DeviceOrientation;

import 'enum_utils.dart';
import 'utils.dart';

class Converter {
  const Converter._();

  static Color? hexToColor(String hexStr) {
    if (Utils.isBlank(hexStr)) {
      return null;
    }

    hexStr = hexStr.toUpperCase().replaceAll("#", "");
    return hexStr.length == 6 ? Color(int.parse("FF$hexStr", radix: 16)) : null;
  }

  static TextAlign? toTextAlign(String? code) =>
      EnumUtils.toEnum(code, TextAlign.values, false);

  static TextDirection? toTextDirection(String? code) =>
      EnumUtils.toEnum(code, TextDirection.values, false);

  static FontStyle? toFontStyle(String? code) =>
      EnumUtils.toEnum(code, FontStyle.values, false);

  static Orientation? toOrientation(String? code) =>
      EnumUtils.toEnum(code, Orientation.values, false);

  static DeviceOrientation? toDeviceOrientation(String? code) =>
      EnumUtils.toEnum(code, DeviceOrientation.values, false);
}
