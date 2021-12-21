import 'handler_response.dart';

class AuthResponse extends HandlerModel {
  late String verificationID;
  late int resendToken;
  AuthResponse({required this.verificationID, required this.resendToken});
}

class UID extends HandlerModel {
  late String uid;
}
