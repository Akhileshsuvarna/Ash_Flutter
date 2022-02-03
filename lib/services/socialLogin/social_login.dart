// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
// import 'package:health_connector/log/logger.dart';
// import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class SocialLogin{

  /*void logInWithFacebook() async {
    final facebookLoginResult = await FacebookAuth.instance.login();
    final userData = await FacebookAuth.instance.getUserData();

    final facebookAuthCredential = FacebookAuthProvider.credential(facebookLoginResult.accessToken!.token);
    await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }*/

  /*Future<void> logInWithApple() async {
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );
    Logger.debug(credential);
  }*/
}