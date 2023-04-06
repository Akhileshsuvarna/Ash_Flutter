// ignore_for_file: avoid_print

import 'package:connectycube_sdk/connectycube_sdk.dart';

import '../constants.dart';

/// The external [log] functions to map.
///
/// Can be overwritten by any kind of function.
class Logger {
  List<String> logs = []; //TODO(skandar) preserve all logs
  factory Logger() => Logger();

  static void Function(Object o, {StackTrace? stackTrace}) debug = consoleLog;

  static void Function(Object o, {StackTrace? stackTrace}) info = consoleLog;

  static void Function(Object o, {StackTrace? stackTrace}) warn = consoleLog;

  static void Function(Object o, {StackTrace? stackTrace}) error = consoleLog;

  static void consoleLog(Object o, {StackTrace? stackTrace}) {
    if (Constants.isDebug) {
      print(o.toString());

      if (stackTrace != null) {
        if (Constants.isDebug) {
          print(stackTrace.toString());
        }
      }
    }
  }
}
