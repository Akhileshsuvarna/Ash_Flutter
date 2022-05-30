import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:health_connector/util/device_utils.dart';

import '../constants.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    testFirebase();
    super.initState();
  }

  testFirebase() async {
    final initApp = await Firebase.initializeApp();
    print(initApp);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.profileBackground,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB((DeviceUtils.width(context) / 36),
                  (DeviceUtils.height(context) / 16), 16.0, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  profiledetails(),
                  const SizedBox(
                    height: 10,
                  ),
                  getprogressdetails(),
                ],
              ),
            ),
            Container(
              // height: MediaQuery.of(context).size.height * 0.73,
              decoration: const BoxDecoration(
                  color: Color(0xCCFFFFFF),
                  borderRadius: BorderRadius.all(
                    Radius.circular(30),
                  )),
              // padding: const EdgeInsets.only(bottom: kBottomNavigationBarHeight ),
              padding: const EdgeInsetsDirectional.fromSTEB(
                  15, 0, 15, kBottomNavigationBarHeight),
              child: Column(
                children: <Widget>[
                  SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const <Widget>[
                            Padding(
                              padding: EdgeInsets.fromLTRB(20, 10, 0, 5),
                              child: Text("Quick Service",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontFamily: 'Lexend Deca',
                                      fontWeight: FontWeight.w600)),
                            ),
                          ])),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(3, 0, 3, 3),
                    child: services(),
                  ),
                  SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const <Widget>[
                            Padding(
                              padding: EdgeInsets.fromLTRB(20, 0, 0, 5),
                              child: Text("Transaction",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15.0,
                                      fontFamily: 'Lexend Deca',
                                      fontWeight: FontWeight.w600)),
                            ),
                          ])),
                  Transections(),
                ],
              ),
            ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget profiledetails() {
    return ListTile(
      leading: user!.photoURL != null
          ?
          // Icon(Icons.account_circle_sharp,size: 70, ),
          CircleAvatar(
              backgroundImage: NetworkImage(user!.photoURL!),
              radius: 30.0,

              // backgroundImage: AssetImage("assets/images/profile.png"),
              backgroundColor: Colors.transparent,
            )
          : const Icon(
              Icons.account_circle_sharp,
              size: 70,
            ),
      title: Text.rich(
        TextSpan(
          text: 'Welcome, ',
          style: const TextStyle(
              fontSize: 20.0,
              fontStyle: FontStyle.normal,
              fontFamily: 'Lexend Deca',
              fontWeight: FontWeight.bold), // default text style
          children: <TextSpan>[
            TextSpan(
                text: (user!.displayName),
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF27A9E1),
                )),
          ],
        ),
      ),
      subtitle: const Text(
        'Your latest updated are below.',
        style: TextStyle(
            fontSize: 14.0,
            fontFamily: 'Lexend Deca',
            fontWeight: FontWeight.bold,
            color: Colors.black),
      ),
    );
  }

  Widget getprogressdetails() {
    return Container(
      height: 130,
      width: 500,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        gradient: LinearGradient(
            begin: Alignment(-1, 1),
            end: Alignment(1, -1),
            stops: [
              0.0,
              1
            ],
            // begin: const FractionalOffset(0.0, 0.0),
            // end: const FractionalOffset(0.5, 0.0),
            // stops: [0.0, 0.5],
            colors: [
              Color(0xFF662D90),
              Color(0xFF27A9E1),
            ]),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //mainAxisSize: MainAxisSize.max,
            children: const <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 0, 10),
                child: Text("Progress",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.0,
                        fontFamily: 'Lexend Deca',
                        fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //mainAxisSize: MainAxisSize.max,
            children: const <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 0, 10),
                child: Text("7,630 Points",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30.0,
                        fontFamily: 'Hind',
                        fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //mainAxisSize: MainAxisSize.max,
            children: const <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 0, 10),
                child: Text("01/04/22",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.0,
                        fontFamily: 'Lexend Deca',
                        fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                child: Text("Score To Date",
                    textDirection: TextDirection.ltr,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.0,
                        fontFamily: 'Lexend Deca',
                        fontWeight: FontWeight.bold)),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget services() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // if you need this
            side: BorderSide(
              color: Colors.grey.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Container(
            color: Colors.white,
            height: MediaQuery.of(context).size.width / 4,
            width: MediaQuery.of(context).size.width / 3.8,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                ListTile(
                  title: Icon(
                    Icons.add_call,
                    size: 40,
                  ),
                  subtitle: Text(
                    'Call',
                    style: TextStyle(
                        fontFamily: 'Lexend Deca',
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 5),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // if you need this
            side: BorderSide(
              color: Colors.grey.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Container(
            color: Colors.white,
            height: MediaQuery.of(context).size.width / 4,
            width: MediaQuery.of(context).size.width / 3.8,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                ListTile(
                  title: Icon(
                    Icons.accessibility_sharp,
                    size: 40,
                  ),
                  subtitle: Text(
                    'Exercise',
                    style: TextStyle(
                        fontFamily: 'Lexend Deca',
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 5),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // if you need this
            side: BorderSide(
              color: Colors.grey.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Container(
            color: Colors.white,
            height: MediaQuery.of(context).size.width / 4,
            width: MediaQuery.of(context).size.width / 3.8,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ListTile(
                  title: ClipRect(
                      child: Align(
                    alignment: Alignment.topCenter,
                    heightFactor: 1,
                    child: Image.asset(
                      "assets/images/Celebration.png",
                    ),
                  )),
                  subtitle: const Padding(
                    padding: EdgeInsets.fromLTRB(0, 6, 0, 0),
                    child: Text(
                      'Results',
                      style: TextStyle(
                          fontFamily: 'Lexend Deca',
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget Transections() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10), // if you need this
            ),
            color: Colors.grey[100],
            child: const ListTile(
              leading: CircleAvatar(
                radius: 20.0,
                backgroundImage:
                    AssetImage("assets/images/ic_sharp-check-circle.png"),
                backgroundColor: Colors.transparent,
              ),
              title: Text("CAT COW",
                  style: TextStyle(
                      fontSize: 14.0,
                      fontFamily: 'Lexend Deca',
                      fontWeight: FontWeight.w600)),
              subtitle: Text('Complete',
                  style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.black,
                      fontFamily: 'Lexend Deca',
                      fontWeight: FontWeight.w600)),
              trailing: Text.rich(
                TextSpan(
                  text: '87/100' '\n',
                  style: TextStyle(
                      fontStyle: FontStyle.normal,
                      fontFamily: 'Lexend Deca',
                      color: Color(0xFF662D90),
                      fontWeight: FontWeight.bold), // default text style
                  children: <TextSpan>[
                    TextSpan(
                        text: 'Score',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        )),
                  ],
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10), // if you need this
            ),
            color: Colors.grey[100],
            child: const ListTile(
              leading: CircleAvatar(
                radius: 20.0,
                backgroundImage:
                    AssetImage("assets/images/ic_sharp-check-circle.png"),
                backgroundColor: Colors.transparent,
              ),
              title: Text("Sphinx",
                  style: TextStyle(
                      fontSize: 14.0,
                      fontFamily: 'Lexend Deca',
                      fontWeight: FontWeight.w600)),
              subtitle: Text('Complete',
                  style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.black,
                      fontFamily: 'Lexend Deca',
                      fontWeight: FontWeight.w600)),
              trailing: Text.rich(
                TextSpan(
                  text: '95/100' '\n',
                  style: TextStyle(
                      fontStyle: FontStyle.normal,
                      fontFamily: 'Lexend Deca',
                      color: Color(0xFF662D90),
                      fontWeight: FontWeight.bold), // default text style
                  children: <TextSpan>[
                    TextSpan(
                        text: 'Score',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        )),
                  ],
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10), // if you need this
            ),
            color: Colors.grey[100],
            child: const ListTile(
              leading: CircleAvatar(
                radius: 20.0,
                backgroundImage:
                    AssetImage("assets/images/ic_sharp-check-circle.png"),
                backgroundColor: Colors.transparent,
              ),
              title: Text("Plank",
                  style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.black,
                      fontStyle: FontStyle.normal,
                      fontFamily: 'Lexend Deca',
                      fontWeight: FontWeight.w600)),
              subtitle: Text('Complete',
                  style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.black,
                      fontWeight: FontWeight.w600)),
              trailing: Text.rich(
                TextSpan(
                  text: '80/100' '\n',
                  style: TextStyle(
                      fontStyle: FontStyle.normal,
                      fontFamily: 'Lexend Deca',
                      color: Color(0xFF662D90),
                      fontWeight: FontWeight.bold), // default text style
                  children: <TextSpan>[
                    TextSpan(
                        text: 'Score',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        )),
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
