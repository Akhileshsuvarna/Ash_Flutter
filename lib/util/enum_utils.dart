import '../log/logger.dart';
import 'utils.dart';

class EnumUtils {
  const EnumUtils._();

  static bool isValid<T>(String? code, Iterable<T> enums) =>
      toEnum(code, enums, false) != null;

  static T? toEnum<T>(String? code, Iterable<T> enums, bool throwOnMismatch) =>
      Utils.isBlank(enums) ? null : _toEnum(code, enums, throwOnMismatch);

  static List<T>? toEnums<T>(
      String? csv, Iterable<T> enums, bool throwOnMismatch) {
    if (Utils.isBlank(enums)) {
      return null;
    }

    List<String>? codes = Utils.splitByCommaAsList(csv);
    List<T> values = [];

    if (!Utils.isBlank(codes)) {
      for (String code in codes!) {
        T? value = _toEnum(code, enums, throwOnMismatch);

        if (value != null && !values.contains(value)) {
          values.add(value);
        }
      }
    }

    return Utils.isBlank(values) ? null : values;
  }

  static T? _toEnum<T>(String? code, Iterable<T> enums, bool throwOnMismatch) {
    if (Utils.isBlank(code)) {
      return null;
    }

    try {
      final String tCode = code!.trim();
      return enums.firstWhere((e) => Utils.equalsIgnoreCase(getName(e), tCode));
    } catch (e) {
      final String msg = "Unknown value: $code";

      if (throwOnMismatch) {
        throw msg;
      }

      Logger.warn(msg);
      return null;
    }
  }

  static String? getName(dynamic value) =>
      value == null ? null : value.toString().split(".").last;
}
