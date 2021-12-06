/// The external [log] functions to map.
///
/// Can be overwritten by any kind of function.
class Logger {
  const Logger._();

  static void Function(Object o, {StackTrace? stackTrace}) debug = consoleLog;

  static void Function(Object o, {StackTrace? stackTrace}) info = consoleLog;

  static void Function(Object o, {StackTrace? stackTrace}) warn = consoleLog;

  static void Function(Object o, {StackTrace? stackTrace}) error = consoleLog;

  static void consoleLog(Object o, {StackTrace? stackTrace}) {
    print(o);

    if (stackTrace != null) {
      print(stackTrace);
    }
  }
}
