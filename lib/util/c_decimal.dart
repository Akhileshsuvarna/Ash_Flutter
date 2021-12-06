import '../../util/utils.dart';

class CDecimal {
  const CDecimal._();

  static bool checkType(Object object) => object is double;

  static double? convertNoErr(Object? value) {
    try {
      return convert(value);
    } catch (e) {
      return null;
    }
  }

  static double? convert(Object? value) {
    if (value == null) {
      return null;
    } else if (value is double) {
      return value;
    } else if (value is num) {
      return toPrimitive(value);
    } else if (value is String) {
      try {
        return parse(value);
      } catch (e) {
        // nothing to do here
      }
    }

    throw 'ConversionError';
  }

  static double? parseNoErr(String? value) {
    try {
      return parse(value);
    } catch (e) {
      return null;
    }
  }

  static double? parse(String? value) {
    final String? tValue = Utils.trim(value);
    return Utils.isBlank(tValue) ? null : double.parse(tValue!);
  }

  static double toPrimitive(Object value) => (value as num).toDouble();
}
