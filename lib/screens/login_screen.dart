import 'package:Health_Connector/constants.dart';
import 'package:flutter/material.dart';

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
      body: Column(
        //TODO-Sikander confirm alignment on testing
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            //TODO-Sikander make this padding dynamic so that Top padding will always remain responsive for all screen sizes.
            padding: EdgeInsets.only(top: 20),
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/wraptor/background_texture.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
