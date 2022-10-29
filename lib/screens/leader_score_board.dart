import 'package:animated_button/animated_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:health_connector/util/utils.dart';

import '../constants.dart';
import '../globals.dart';
import '../log/logger.dart';
import '../models/user_score.dart';
import '../util/converter.dart';
import '../util/device_utils.dart';
import 'components/custom_back_button.dart';

class LeaderScoreBoard extends StatefulWidget {
  const LeaderScoreBoard({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  createState() => _StateLeaderScoreBoard();
}

class _StateLeaderScoreBoard extends State<LeaderScoreBoard> {
  late Size _size;
  final ValueNotifier<double> _myStars = ValueNotifier<double>(0.0);
  final ValueNotifier<String> _myRank = ValueNotifier<String>("");

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Leaderboards',
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
              color: Converter.hexToColor('#303030'),
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w500,
              fontSize: 20,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading:
            customBackButton(context, color: Converter.hexToColor('#303030')),
      ),
      backgroundColor: Constants.profileBackground,
      // extendBodyBehindAppBar: true,
      body: Column(
        children: [
          // SizedBox(height: _size.height / 16),
          // profiledetails(),
          Padding(
            padding: EdgeInsets.fromLTRB((DeviceUtils.width(context) / 36),
                (DeviceUtils.height(context) / 64), 16.0, 24),
            child: myBoard(),
          ),
          // Padding(
          //   padding: EdgeInsets.only(left: _size.width / 20),
          //   child: Row(
          //     children: [
          //       Text(
          //         'Top Scores',
          //         style: GoogleFonts.poppins(
          //           textStyle: TextStyle(
          //             fontSize: 14.0,
          //             fontWeight: FontWeight.w400,
          //             fontStyle: FontStyle.normal,
          //             color: Converter.hexToColor('#424242'),
          //           ), // default text style
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          // Padding(
          //   padding: EdgeInsets.only(left: _size.width / 20),
          //   child: Row(
          //     children: [
          //       Card(
          //         child: Column(
          //           children: [
          //             0 > 1
          //                 ?
          //                 // Icon(Icons.account_circle_sharp,size: 70, ),
          //                 const CircleAvatar(
          //                     backgroundImage: NetworkImage(''),
          //                     radius: 30.0,

          //                     // backgroundImage: AssetImage("assets/images/profile.png"),
          //                     backgroundColor: Colors.transparent,
          //                   )
          //                 : const Icon(
          //                     Icons.account_circle_sharp,
          //                     size: 70,
          //                   ),
          //             Text.rich(
          //               TextSpan(
          //                 text: (0 > 1 ? "data[index].name" : "Anonymous"),
          //                 style: GoogleFonts.poppins(
          //                   textStyle: TextStyle(
          //                     fontSize: 14.0,
          //                     fontWeight: FontWeight.w400,
          //                     fontStyle: FontStyle.normal,
          //                     color: Converter.hexToColor('#303030'),
          //                   ), // default text style
          //                 ),
          //               ),
          //             ),

          //           ],
          //         ),
          //       ),
          //       Card(),
          //       Card(),
          //     ],
          //   ),
          // ),

          Expanded(
            child: SingleChildScrollView(
              child: FutureBuilder(
                future: Globals.getLeaderScoreBoard(),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return const CircularProgressIndicator();
                    case ConnectionState.none:
                      return const CircularProgressIndicator();

                    case ConnectionState.active:
                      return const CircularProgressIndicator();

                    case ConnectionState.done:
                      updateRank(snapshot.data);
                      return _scoreBoard(snapshot.data);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _scoreBoard(List<UserScore> data) {
    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: data.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(
              left: _size.width / 32,
              right: _size.width / 32,
            ),
            child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: ListTile(
                isThreeLine: true,
                leading: data[index].photoUrl.length > 1
                    ?
                    // Icon(Icons.account_circle_sharp,size: 70, ),
                    CircleAvatar(
                        backgroundImage: NetworkImage(data[index].photoUrl),
                        radius: 30.0,

                        // backgroundImage: AssetImage("assets/images/profile.png"),
                        backgroundColor: Colors.transparent,
                      )
                    : const Icon(
                        Icons.account_circle_sharp,
                        size: 70,
                      ),
                subtitle: Text.rich(
                  TextSpan(
                    text: (data[index].name.length > 1
                        ? data[index].name
                        : "Anonymous"),
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        color: Converter.hexToColor('#303030'),
                      ), // default text style
                    ),
                  ),
                ),
                // subtitle: Text.rich(
                //   TextSpan(
                //     text: '',
                //     style: GoogleFonts.poppins(
                //       textStyle: const TextStyle(
                //         fontSize: 20.0,
                //         fontWeight: FontWeight.bold,
                //         // color: Color(0xFF27A9E1),
                //       ),
                //     ),
                //   ),
                // ),
                // trailing: myRank(1),
                trailing: Column(children: [
                  const SizedBox(height: 8),
                  AnimatedButton(
                    width: 64,
                    height: 40,
                    onPressed: () {
                      Utils.speak(
                          '${data[index].name} rank at number ${index + 1}');
                    },
                    child: Text(
                      (index + 1).toString(),
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ]),
              ),
            ),
          );
        });
  }

  Widget profiledetails() => Padding(
        padding: EdgeInsets.only(right: _size.width / 12),
        child: ListTile(
          leading: widget.user.photoURL != null
              ?
              // Icon(Icons.account_circle_sharp,size: 70, ),
              CircleAvatar(
                  backgroundImage: NetworkImage(widget.user.photoURL!),
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
              text: (widget.user.displayName),
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF27A9E1),
                ), // default text style
              ),
            ),
          ),
          subtitle: Text.rich(
            TextSpan(
              text: 'You rank',
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  // color: Color(0xFF27A9E1),
                ),
              ),
            ),
          ),
          // trailing: myRank(1),
          trailing: ValueListenableBuilder<String>(
            builder: (BuildContext context, String value, Widget? child) =>
                _myRank.value.isNotEmpty
                    ? Text(
                        _myRank.value,
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            fontSize: 32.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF27A9E1),
                          ),
                        ),
                      )
                    : SizedBox(
                        height: _size.height / 16,
                        width: _size.height / 16,
                        child: const CircularProgressIndicator()),
            valueListenable: _myRank,
          ),
        ),
      );

  Widget myRating(double rating) => RatingBar.builder(
        initialRating: rating,
        minRating: 0,
        direction: Axis.horizontal,
        allowHalfRating: true,
        itemCount: 3,
        ignoreGestures: true,
        itemPadding: const EdgeInsets.symmetric(horizontal: 24.0),
        itemBuilder: (context, _) => const Icon(
          Icons.star,
          color: Colors.amber,
        ),
        onRatingUpdate: (rating) {
          Logger.debug('New rating: $rating');
        },
      );

  void updateRank(List<UserScore> data) async {
    await Future.delayed(const Duration(seconds: 1));

    int myScore = 0;
    for (int i = 0; i < data.length; i++) {
      if (data[i].uuid == widget.user.uid) {
        _myRank.value = (i + 1).toString();
        myScore = data[i].score;
      }
    }

    var myPosition = (myScore / data[0].score) * 100;
    _myStars.value = (myPosition / 100) * 3;
  }

  Widget myBoard() {
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
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
              ValueListenableBuilder<double>(
                builder: (BuildContext context, double value, Widget? child) =>
                    myRating(_myStars.value),
                valueListenable: _myStars,
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
}
