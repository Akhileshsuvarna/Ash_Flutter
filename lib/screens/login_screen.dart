import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:health_connector/constants.dart';
import 'package:health_connector/main.dart';
import 'package:health_connector/models/UserProfile.dart';
import 'package:health_connector/models/assets.dart';
import 'package:health_connector/services/social_sign_in.dart';
import 'package:health_connector/util/device_utils.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

import 'components/rounded_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Constants.appBackgroundColor,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            //TODO-Sikander confirm alignment on testing
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                //TODO-Sikander make this padding dynamic so that Top padding will always remain responsive for all screen sizes.
                padding: EdgeInsets.only(top: DeviceUtils.height(context) / 8),
                child: Image.asset(
                  'assets/images/logo.png',
                  scale: 1.0,
                ),
              ),

              //Continue with Google
              Platform.isAndroid
                  ? Padding(
                      padding: EdgeInsets.only(
                          top: 0.0,
                          left: _size.width / 16,
                          right: _size.width / 16),
                      child: RoundedButton(
                        color: Colors.white,
                        prefix: Image.asset(Assets.appLogo),
                        text: "Sign in with Google",
                        textColor: Colors.black,
                        onPressed: _signUpwithGoogle,
                      ),
                    )
                  : const SizedBox(height: 0),
              // Continue with Apple
              Platform.isIOS
                  ? Padding(
                      padding: EdgeInsets.only(
                        top: _size.height / 128,
                        left: _size.width / 16,
                        right: _size.width / 16,
                      ),
                      child: RoundedButton(
                        color: Colors.black,
                        prefix: Image.asset(Assets.socialLoginAppleLogo),
                        text: "Sign in with Apple",
                        textColor: Colors.white,
                        onPressed: _signUpwithApple,
                      ),
                    )
                  : const SizedBox(height: 0),

              const Padding(padding: EdgeInsets.only(bottom: 50)),
              // Padding(
              //   padding: EdgeInsets.only(
              //       left: DeviceUtils.width(context) / 8,
              //       right: DeviceUtils.width(context) / 8,
              //       top: DeviceUtils.height(context) / 8),
              //   child: _logInButton(),
              // ),
              // TODO-Sikander make this padding dynamic so that bottom padding will always remain responsive for all screen sizes.
              Padding(
                padding:
                    EdgeInsets.only(bottom: DeviceUtils.height(context) / 32),
                child: const Text(
                  'By signing in, you accept our Terms and Conditions',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _logInButton() => RoundedButton(
        text: "Login",
        prefix: Image.asset('assets/images/logo.png'),
        color: Constants.primaryColor,
        onPressed: () => _onLoginButtonPressed,
        textColor: Constants.primaryTextColor,
      );

  void _onLoginButtonPressed() =>
      Navigator.of(context).pushReplacementNamed(Constants.userHomeScreen);

  _signUpwithGoogle() async {
    {
      UserCredential? result = await signInWithGoogle();
      if (result != null) {
        _logIn(result);
      } else {
        Constants.showMessage(
            context, 'Sign in with google failed, please try again');
      }
    }
  }

  _signUpwithApple() async {
    {
      UserCredential? result = await signInWithApple();
      if (result != null) {
        _logIn(result);
      } else {
        Constants.showMessage(
            context, 'Sign in with google failed, please try again');
      }
    }
  }

  _logIn(UserCredential credential) async {
    userProfile = UserProfile(
        data: Data(
            createdAt: DateTime.now().toString(),
            email: credential.user!.email ?? '',
            firstName: credential.additionalUserInfo!.username ?? '',
            name: credential.user!.displayName ?? '',
            phoneNumber: credential.user!.phoneNumber ?? '',
            photoURL: credential.user!.photoURL ?? '',
            dateOfBirth: '',
            gender: '',
            address: '',
            firebaseToken: prefs.getString('fcmToken') ?? '',
            uuid: credential.user!.uid));

    await FirebaseChatCore.instance.createUserInFirestore(
      types.User(
          firstName: credential.user!.displayName,
          id: credential.user!.uid, // UID from Firebase Authentication
          imageUrl: credential.user!.photoURL,
          lastName: '',
          metadata: {"email": credential.user!.email ?? ""}),
    );

    await firebaseDatabase
        .ref()
        .child(Constants.dbRoot)
        .child('users')
        .child(userProfile.data!.uuid)
        .get()
        .then((snapshot) async {
      if (snapshot.exists) {
        // TODO (skandar)
        // update firebase user details.
        await prefs.setBool("isFirstTime", false);
      } else {
        await prefs.setBool("isFirstTime", true);

        await firebaseDatabase
            .ref()
            .child(Constants.dbRoot)
            .child('users')
            .child(userProfile.data!.uuid)
            .set(userProfile.data!.toJson());
      }
    });

    prefs.setString("userProfile", jsonEncode(userProfile.toJson()));
    prefs.setBool('_isLoggedIn', true);
    // TODO: Navigate to Home Screen
    await prefs.setBool("isFirstTime", true);

    if (prefs.getBool("isFirstTime") ?? true) {
      Navigator.of(context).pushReplacementNamed(Constants.questionScreen0);
    } else {
      Navigator.of(context).pushReplacementNamed(Constants.userHomeScreen);
    }
  }
}
