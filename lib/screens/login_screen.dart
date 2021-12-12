import 'package:flutter/material.dart';
import 'package:health_connector/constants.dart';
import 'package:health_connector/util/device_utils.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Constants.appBackgroundColor,
      body: Center(
        child: Column(
          //TODO-Sikander confirm alignment on testing
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              //TODO-Sikander make this padding dynamic so that Top padding will always remain responsive for all screen sizes.
              padding: EdgeInsets.only(top: DeviceUtils.height(context) / 32),
              child: Image.asset(
                'assets/images/logo.png',
                scale: 0.8,
              ),
              // child: Container(
              //   width: 300,
              //   height: 400,
              //   decoration: const BoxDecoration(
              //     image: DecorationImage(
              //       image: AssetImage("assets/images/logo.png"),
              //       fit: BoxFit.cover,
              //     ),
              //   ),
              // ),
            ),
            Padding(
              //TODO-Sikander make this padding dynamic so that bottom padding will always remain responsive for all screen sizes.
              padding:
                  EdgeInsets.only(bottom: DeviceUtils.height(context) / 32),
              child: const Text(
                  'By signing in, you accept our Terms and Conditions'),
            ),
          ],
        ),
      ),
    );
  }
}
