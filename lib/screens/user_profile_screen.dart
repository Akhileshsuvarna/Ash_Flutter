import 'package:animated_button/animated_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health_connector/main.dart';
import 'package:health_connector/screens/leader_score_board.dart';
import 'package:health_connector/screens/login_screen.dart';

import 'package:health_connector/util/device_utils.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import '../constants.dart';
import '../globals.dart';
import '../models/exercise_transactions.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  User? user = FirebaseAuth.instance.currentUser;

  late Size _size;
  String lastExercisedTime = prefs.getString('lastExercisedTime') ?? "00/00/00";

  @override
  void initState() {
    super.initState();

    _startActivity();
  }

  _startActivity() async {
    lastExercisedTime = await Globals.getLastExercisePerformedDate();
    prefs.setString('lastExercisedTime', lastExercisedTime);
  }

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Constants.profileBackground,
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        // physics: const NeverScrollableScrollPhysics(),
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
                  GestureDetector(
                    onTap: () {
                      pushNewScreen(
                        context,
                        screen: LeaderScoreBoard(user: user!),
                        withNavBar: false,
                        pageTransitionAnimation:
                            PageTransitionAnimation.cupertino,
                      );
                    },
                    child: getprogressdetails(),
                  ),
                ],
              ),
            ),
            Container(
              // height: MediaQuery.of(context).size.height * 0.73,
              decoration: const BoxDecoration(
                color: Color(0xCCFFFFFF),
                borderRadius: BorderRadius.all(
                  Radius.circular(30),
                ),
              ),
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
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 10, 0, 5),
                          child: Text(
                            "Quick Service",
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(3, 0, 3, 3),
                    child: services(),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                          child: Text(
                            "Transaction",
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: _size.height / 2.6,
                    child: FutureBuilder(
                      future: Globals.getLastExerciseTransactions(),
                      builder: (BuildContext context,
                          AsyncSnapshot<dynamic> snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return Globals.progressIndicator();
                          case ConnectionState.none:
                            return Globals.progressIndicator();
                          case ConnectionState.active:
                            return Globals.progressIndicator();
                          case ConnectionState.done:
                            return snapshot.data != null
                                ? transactions(
                                    snapshot.data as List<ExerciseTransactions>)
                                : const Center(
                                    child: Text(
                                        'We are sorry for the inconvenience, our team is working on getting the right services for you'));
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: _size.height / 32),
                    child: AnimatedButton(
                      onPressed: () => Constants.logout(context),
                      child: Text(
                        'Logout',
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            color: Colors.white,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
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
          style: GoogleFonts.poppins(
            textStyle: const TextStyle(
                fontSize: 20.0,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.bold),
          ), // default text style
          children: <TextSpan>[
            TextSpan(
              text: (user!.displayName),
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF27A9E1),
                ),
              ),
            ),
          ],
        ),
      ),
      subtitle: Text(
        'Your latest updates are below.',
        style: GoogleFonts.poppins(
          textStyle: const TextStyle(
              fontSize: 14.0, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
    );
  }

  Widget getprogressdetails() {
    return Container(
      height: 150,
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
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 0, 10),
                child: Text(
                  "Progress",
                  textAlign: TextAlign.left,
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ),
            ],
          ),
          Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 0, 10),
                child: FutureBuilder(
                  future: Globals.getCurrentProgressScore(),
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.done:
                        return snapshot.data != null
                            ? Text(
                                '${snapshot.data} Points',
                                textAlign: TextAlign.left,
                                style: GoogleFonts.poppins(
                                  textStyle: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 32.0,
                                      fontWeight: FontWeight.w700),
                                ),
                              )
                            : Center(
                                child: Text(
                                    'We are sorry for the inconvenience, our team is working on getting the right services for you',
                                    style: GoogleFonts.poppins()));
                      default:
                        return Row(
                          children: [
                            const CircularProgressIndicator(),
                            const SizedBox(width: 20),
                            Text(
                              'Points',
                              textAlign: TextAlign.left,
                              style: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 30.0,
                                    fontFamily: 'Hind',
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        );
                    }
                  },
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 0, 10),
                child: FutureBuilder(
                  future: Globals.getLastExercisePerformedDate(),
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.done:
                        return snapshot.data != null
                            ? Text(
                                snapshot.data,
                                textAlign: TextAlign.left,
                                style: GoogleFonts.poppins(
                                  textStyle: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            : const Center(
                                child: Text(
                                    'We are sorry for the inconvenience, our team is working on getting the right services for you'));
                      default:
                        return Text(
                          'Loading...',
                          textAlign: TextAlign.left,
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold),
                          ),
                        );
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                child: Text(
                  "Score To Date",
                  textDirection: TextDirection.ltr,
                  textAlign: TextAlign.left,
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
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
              children: [
                const Icon(
                  Icons.voice_chat,
                  size: 38,
                  color: Colors.black,
                ),
                const SizedBox(height: 10),
                Text(
                  'Quick Call',
                  style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black)),
                  textAlign: TextAlign.center,
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
                const Icon(
                  Icons.contacts,
                  size: 38,
                  color: Colors.black,
                ),
                const SizedBox(height: 10),
                Text(
                  'Contacts',
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  textAlign: TextAlign.center,
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
                const FaIcon(
                  FontAwesomeIcons.houseChimneyMedical,
                  color: Color(0xFF1E2429),
                  size: 38,
                ),
                const SizedBox(height: 10),
                Text(
                  'Find Clinic',
                  style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black)),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget transactions(List<ExerciseTransactions> et) {
    return ListView.builder(
        itemCount: et.length,
        itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // if you need this
                ),
                color: Colors.grey[100],
                child: ListTile(
                  leading: const Icon(
                    Icons.check_circle_sharp,
                    color: Color(0xFF39D2C0),
                    size: 38,
                  ),
                  title: Text(
                    et[index].exerciseName,
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                          fontSize: 14.0, fontWeight: FontWeight.w600),
                    ),
                  ),
                  subtitle: Text(
                    'Complete',
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        fontSize: 12.0,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  trailing: Text.rich(
                    TextSpan(
                      text: '${et[index].score}/100' '\n',
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                            fontStyle: FontStyle.normal,
                            color: Color(0xFF662D90),
                            fontWeight: FontWeight.bold),
                      ), // default text style
                      children: <TextSpan>[
                        TextSpan(
                            text: 'Score',
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            )),
                      ],
                    ),
                  ),
                ),
              ),
            ));
  }
}
