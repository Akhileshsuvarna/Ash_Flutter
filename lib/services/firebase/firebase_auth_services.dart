import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:health_connector/log/logger.dart';
import 'package:health_connector/models/firebase_models.dart';
import 'package:health_connector/models/handler_response.dart';

class FirebaseAuthServices {
  HandlerResponse response = HandlerResponse();
  Future<String> firebasecreateUserWithEmailAndPassword(
      String email, String password) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email.trim(), password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Logger.debug('The password provided is too weak.');
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        Logger.debug('The account already exists for that email.');
        return 'The account already exists for that email.';
      }
    } catch (e, stackTrace) {
      Logger.error(e, stackTrace: stackTrace);
      return e.toString();
    }
    return 'Verification E-mail Sent to: ' + email;
  }

  Future<String> firebaseSignInwithEmailandLink(
      String email, String password) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email.trim(), password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Logger.debug('The password provided is too weak.');
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        Logger.debug('The account already exists for that email.');
        return 'The account already exists for that email.';
      }
    } catch (e, stackTrace) {
      Logger.error(e, stackTrace: stackTrace);
      return e.toString();
    }
    return 'Verification e-mail sent to: $email';
  }

  Future<void> signInWithEmailAndLink(String email) async {
    return await FirebaseAuth.instance.sendSignInLinkToEmail(
        email: email,
        actionCodeSettings: ActionCodeSettings(
            url: "https://wraptor.page.link",
            androidInstallApp: false,
            androidMinimumVersion: "1",
            androidPackageName: "com.wraptor.wraptorclient",
            handleCodeInApp: true));
  }

  Future<void> firebasesignInWithEmailAndPassword() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: "barry.allen@example.com", password: "SuperSecretPassword!");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Logger.debug('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        Logger.debug('Wrong password provided for that user.');
      }
    }
  }

  Future<HandlerResponse> phoneAuth(String phone) async {
    AuthResponse _res;
    var completer = Completer<HandlerResponse>();
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (PhoneAuthCredential credential) {
        Logger.debug('User Succesfully Verified');
        response.message = 'User Succesfully Verified';
        response.success = true;
        completer.complete(response);
      },
      verificationFailed: (FirebaseAuthException e) {
        Logger.debug('Verification Failed: e.message');
        response.success = false;
        response.message = 'verification Failed: ${e.message}';
        completer.complete(response);
      },
      codeSent: (String verificationId, int? resendToken) {
        Logger.debug('Code Sent !');
        _res = AuthResponse(
            verificationID: verificationId, resendToken: resendToken!);

        response.message = 'codeSent';
        response.dataObject = _res;
        completer.complete(response);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        response.message = "codeAutoRetrievalTimeout";
        completer.complete(response);
      },
    );

    return completer.future;
  }

  Future<HandlerResponse> phoneVerify(
      String smsCode, String verificationId) async {
    HandlerResponse _response = HandlerResponse();
    try {
      UID _uid = UID();
      // Create a PhoneAuthCredential with the code
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: smsCode);

      // Sign the user in (or link) with the credential
      var _res = await FirebaseAuth.instance.signInWithCredential(credential);
      _uid.uid = _res.user!.uid;
      _response.success = true;
      _response.message = "Success";
      _response.dataObject = _uid;
    } on FirebaseAuthException catch (e, stackTrace) {
      Logger.error(e, stackTrace: stackTrace);
      _response.success = false;
      _response.message =
          'Error code = ${e.code} || Error message =  ${e.message} ';
    }
    return _response;
  }
}
