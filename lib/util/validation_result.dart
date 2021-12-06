import 'utils.dart';

class ValidationResult {
  ValidationResult(this.isValid, String message)
      : this.message = isValid
            ? Utils.toDefault(
                message, 'Exercise Configuration validated successfully')!
            : 'Exercise Configuration validation failed';

  final bool isValid;
  final String message;
}
