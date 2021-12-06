import 'package:flutter/material.dart' show BuildContext;
import 'package:permission_handler/permission_handler.dart';

import 'enum_utils.dart';

// TODO Add missing permission(s) when required
// TODO Support multiple permissions request at once?
// E.g. Map<Permission, PermissionStatus> statuses = await [Permission.location, Permission.storage].request();
class Permissions {
  const Permissions._();

  static Future<bool> openSettings() async => openAppSettings();

  static Future<bool> location(BuildContext context) async =>
      _permit(Permission.location, context);

  static Future<bool> camera(BuildContext context) async =>
      _permit(Permission.camera, context);

  static Future<bool> storage(BuildContext context) async =>
      _permit(Permission.storage, context);

  static Future<bool> _permit(
      Permission permission, BuildContext context) async {
    PermissionStatus status = await permission.status;

    if (status.isDenied) {
      status = await permission.request();
    }

    if (status.isGranted || status.isLimited) {
      return true;
    }

    return false;
  }
}
