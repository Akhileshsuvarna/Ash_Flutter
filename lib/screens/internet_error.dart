import 'dart:async';
import 'package:animated_button/animated_button.dart';
import 'package:flutter/material.dart';
import 'package:health_connector/globals.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../constants.dart';
import '../main.dart';

class InternetError extends StatefulWidget {
  const InternetError({Key? key}) : super(key: key);
  @override
  _InternetErrorState createState() => _InternetErrorState();
}

class _InternetErrorState extends State<InternetError> {
  late StreamSubscription<ConnectivityResult> subscription;
  ConnectivityResult? connectivityStatus;

  late double _height;
  late double _width;

  Widget connectivityIcon() {
    if (connectivityStatus != null &&
        connectivityStatus == ConnectivityResult.mobile) {
      return Icon(Icons.signal_cellular_connected_no_internet_4_bar_sharp,
          color: Colors.black, size: _width / 2);
    } else if (connectivityStatus != null &&
        connectivityStatus == ConnectivityResult.wifi) {
      return Icon(Icons.signal_wifi_connected_no_internet_4_sharp,
          color: Colors.black, size: _width / 2);
    } else {
      return Icon(Icons.signal_wifi_connected_no_internet_4_sharp,
          color: Colors.black, size: _width / 2);
    }
  }

  @override
  void initState() {
    super.initState();
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      setState(() {
        connectivityStatus = result;
      });
      tryAgain();
    });
    start();
  }

  start() async {
    Globals.getConnectivityStatus().then((value) {
      setState(() {
        connectivityStatus = value;
      });
    });
  }

  @override
  dispose() {
    super.dispose();
    subscription.cancel();
  }

  // TODO-Sikander fix me
  // Future<void> navigationPage() async {
  //   var status = prefs.getBool('_isLoggedIn') ?? false;
  //   var isFirstTime = prefs.getBool('_isFirstTime') ?? true;

  //   if (isFirstTime) {
  //     Navigator.of(context).pushReplacementNamed(STORY_SCREEN);
  //   } else {
  //     if (status) {
  //       Navigator.of(context).pushReplacementNamed(HOME_SCREEN);
  //     } else {
  //       Navigator.of(context).pushReplacementNamed(SIGN_IN);
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    return Material(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        // backgroundColor: Colors.yellow,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              connectivityIcon(),
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text('Oops, No Internte Connection '),
              ),
              Padding(
                child: AnimatedButton(
                  child: const Text(
                    'Try Again',
                    style: TextStyle(color: Colors.white),
                  ),
                  height: 60,
                  onPressed: () {
                    tryAgain();
                  },
                  color: const Color(0xffff0000),
                  // width: _width / 2,
                  duration: 5,
                ),
                padding: const EdgeInsets.only(
                  // left: _width / 22,
                  // right: _width / 22,
                  bottom: 25,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void tryAgain() {
    Globals.lookupInternet().then((value) {
      if (value) {
        // TODO-Sikander fix me
        Navigator.of(context).pushReplacementNamed(Constants.logIn);
      } else {
        snackBar(message: "No internet connection");
      }
    });
  }

  void snackBar({required String message}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}
