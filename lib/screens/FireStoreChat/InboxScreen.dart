import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health_connector/globals.dart';
import 'package:health_connector/util/converter.dart';
import 'package:health_connector/util/view_utils.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import '../../constants.dart';
import '../login_screen.dart';
import 'chat.dart';
import 'users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'util.dart';

class RoomsPage extends StatefulWidget {
  const RoomsPage({Key? key}) : super(key: key);

  @override
  _RoomsPageState createState() => _RoomsPageState();
}

class _RoomsPageState extends State<RoomsPage> with WidgetsBindingObserver {
  bool _error = false;
  bool _initialized = false;
  User? _user;
  late Size _size;
  bool _hasUserOpenedPermissionSettings = false;

  @override
  void initState() {
    if (Platform.isAndroid) {
      WidgetsBinding.instance.addObserver(this);
    }
    initializeFlutterFire();
    checkReceivingCallinBackgroundPermission();
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // check permissions when app is resumed
  // this is when permissions are changed in app settings outside of app
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (Platform.isAndroid && state == AppLifecycleState.resumed) {
      if (_hasUserOpenedPermissionSettings &&
          await Constants.isSystemAlertWindowPermissionGranted()) {
        Navigator.of(context, rootNavigator: true).pop();
      }
    }
  }

  void checkReceivingCallinBackgroundPermission() async {
    if (!await Constants.isSystemAlertWindowPermissionGranted()) {
      //TODO(skandar) Show some Dialouge before opening settings and Guide user on what todo.

      ViewUtils.popup(
          Text(
            'Permission request',
            style: GoogleFonts.poppins(
              textStyle: const TextStyle(
                fontSize: 22,
                fontStyle: FontStyle.normal,
              ),
            ),
          ),
          content: Text(
            'Please allow Health Connector app to Display over other apps. \n\nIf permission not allowed call functionality will not work properly.',
            style: GoogleFonts.poppins(
              textStyle: const TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.normal,
              ),
            ),
          ),
          context,
          boxColor: Colors.white,
          barrierDismissible: true,
          actions: [
            GestureDetector(
              onTap: () {
                _hasUserOpenedPermissionSettings = true;
                Constants.openSettingsForSystemAlertWindowPermission();
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 16, bottom: 8),
                child: Text(
                  'Open Settings.',
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                        fontSize: 18,
                        fontStyle: FontStyle.normal,
                        color: Constants.primaryColor),
                  ),
                ),
              ),
            ),
          ]);
    }
  }

  void initializeFlutterFire() async {
    try {
      await Firebase.initializeApp();
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        setState(() {
          _user = user;
        });
      });
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      setState(() {
        _error = true;
      });
    }
  }

  Widget _buildAvatar(types.Room room) {
    var color = Colors.transparent;

    if (room.type == types.RoomType.direct) {
      try {
        final otherUser = room.users.firstWhere(
          (u) => u.id != _user!.uid,
        );

        color = getUserAvatarNameColor(otherUser);
      } catch (e) {
        // Do nothing if other user is not found
      }
    }

    final hasImage = room.imageUrl != null;
    final name = room.name ?? '';

    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: CircleAvatar(
        backgroundColor: hasImage ? Colors.transparent : color,
        // backgroundImage: null,
        backgroundImage:
            hasImage ? _getNetWorkImage(room.imageUrl ?? "") : null,
        radius: 20,
        child: !hasImage
            ? name.isEmpty
                ? const Icon(
                    Icons.account_circle,
                    color: Colors.white,
                  )
                : Text(
                    name.isEmpty ? '' : name[1].toUpperCase(),
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(color: Colors.white),
                    ),
                  )
            : null,
      ),
    );
  }

  Future<String> _getLastMessage(types.Room room) async {
    int i;
    QuerySnapshot collectionReference = await FirebaseFirestore.instance
        .collection("rooms/${room.id}/messages")
        .orderBy("createdAt")
        .get();
    // s.sort((a, b) => (a.get("createdAt")).compareTo(b.get("createdAt")),);

    if (collectionReference.docs.isNotEmpty) {
      for (i = collectionReference.docs.length - 1; i > -1; i = i - 1) {
        if (await collectionReference.docs[i].get("authorId") ==
            FirebaseAuth.instance.currentUser!.uid) {
          continue;
        } else {
          if (await collectionReference.docs[i].get("type") == "text") {
            return await collectionReference.docs[i].get("text");
          } else {
            continue;
          }
        }
      }
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    if (_error) {
      return Globals.progressIndicator();
    }

    if (!_initialized) {
      return Globals.progressIndicator();
    }
    _size = MediaQuery.of(context).size;
    return _user == null
        ? Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(
              bottom: 200,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Not authenticated'),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        fullscreenDialog: true,
                        builder: (context) => const LoginPage(),
                      ),
                    );
                  },
                  child: const Text('Login'),
                ),
              ],
            ),
          )
        : SafeArea(
            child: Stack(
              children: [
                Column(
                  children: [
                    Column(
                      children: [
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(width: 12),
                            const Icon(
                              Icons.settings,
                              color: Colors.black,
                              size: 30,
                            ),
                            const Spacer(),
                            Text(
                              "Inbox",
                              style: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 34,
                                ),
                              ),
                            ),
                            const Spacer(),
                            const Icon(
                              Icons.search_outlined,
                              color: Colors.black,
                              size: 30,
                            ),
                            const SizedBox(width: 12),
                          ],
                        ),
                        const SizedBox(
                          height: 22,
                        ),
                        // Row(
                        //   children: [
                        //     const SizedBox(
                        //       width: 25,
                        //     ),
                        //     GestureDetector(
                        //       onTap: () {
                        //         pushNewScreen(context,
                        //             screen: const AudioCallScreen(),
                        //             withNavBar: false);
                        //       },
                        //       child: Padding(
                        //         padding: const EdgeInsets.all(8.0),
                        //         child: Container(
                        //           decoration: const BoxDecoration(
                        //             color: Constants.primaryColor,
                        //             borderRadius:
                        //                 BorderRadius.all(Radius.circular(16)),
                        //           ),
                        //           child: Padding(
                        //             padding: const EdgeInsets.all(10.0),
                        //             child: Row(
                        //               children: [
                        //                 const Icon(
                        //                   Icons.call,
                        //                   color: Colors.white,
                        //                 ),
                        //                 const SizedBox(
                        //                   width: 10,
                        //                 ),
                        //                 Text(
                        //                   "Audio",
                        //                   style: GoogleFonts.poppins(
                        //                     textStyle: const TextStyle(
                        //                       color: Colors.white,
                        //                       fontSize: 18,
                        //                       fontWeight: FontWeight.bold,
                        //                     ),
                        //                   ),
                        //                 ),
                        //               ],
                        //             ),
                        //           ),
                        //         ),
                        //       ),
                        //     ),
                        //     const Spacer(),
                        //     GestureDetector(
                        //       onTap: () {
                        //         pushNewScreen(context,
                        //             screen: const VideoCallScreen(),
                        //             withNavBar: false);
                        //       },
                        //       child: Padding(
                        //         padding: const EdgeInsets.all(8.0),
                        //         child: Container(
                        //           decoration: const BoxDecoration(
                        //             color: Constants.primaryColor,
                        //             borderRadius:
                        //                 BorderRadius.all(Radius.circular(16)),
                        //           ),
                        //           child: Padding(
                        //             padding: const EdgeInsets.all(10.0),
                        //             child: Row(
                        //               children: [
                        //                 const Icon(
                        //                   Icons.video_call_outlined,
                        //                   color: Colors.white,
                        //                 ),
                        //                 const SizedBox(
                        //                   width: 10,
                        //                 ),
                        //                 Text(
                        //                   "Video",
                        //                   style: GoogleFonts.poppins(
                        //                     textStyle: const TextStyle(
                        //                       color: Colors.white,
                        //                       fontSize: 18,
                        //                       fontWeight: FontWeight.bold,
                        //                     ),
                        //                   ),
                        //                 ),
                        //               ],
                        //             ),
                        //           ),
                        //         ),
                        //       ),
                        //     ),
                        //     const SizedBox(width: 25),
                        //   ],
                        // ),
                        const SizedBox(height: 20),
                        StreamBuilder<List<types.Room>>(
                          stream: FirebaseChatCore.instance.rooms(),
                          initialData: const [],
                          builder: (context, snapshot) {
                            if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return Container(
                                alignment: Alignment.center,
                                margin: const EdgeInsets.only(
                                  bottom: 200,
                                ),
                                child: Globals.progressIndicator(),
                              );
                            }

                            return SingleChildScrollView(
                              child: Container(
                                height: _size.height / 1.5,
                                padding: const EdgeInsets.all(4.0),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index) {
                                    final room = snapshot.data![index];
                                    return InkWell(
                                      onTap: () {
                                        pushNewScreen(context,
                                            screen: ChatPage(
                                                room: room,
                                                chatUserName:
                                                    _getUserName(room)),
                                            withNavBar: false);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 4.0, left: 8.0, right: 8),
                                        child: Column(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Colors.grey.shade300
                                                    .withOpacity(0.5),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(5)),
                                                boxShadow: const [
                                                  BoxShadow(
                                                    color: Colors.black12,
                                                    offset: Offset(
                                                      0.0,
                                                      0.0,
                                                    ),
                                                    blurRadius: 8.0,
                                                    spreadRadius: 0.5,
                                                  ), //BoxShadow
                                                  BoxShadow(
                                                    color: Colors.white,
                                                    offset: Offset(0.0, 0.0),
                                                    blurRadius: 0.0,
                                                    spreadRadius: 0.0,
                                                  ), //BoxShadow
                                                ],
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 0,
                                                vertical: 0,
                                              ),
                                              child: ListTile(
                                                leading: _buildAvatar(room),
                                                title: Text(
                                                  (room.name != null &&
                                                          room.name!.isNotEmpty)
                                                      ? room.name!
                                                      : _getUserName(room)
                                                          .substring(0, 5),
                                                  style: GoogleFonts.poppins(
                                                    textStyle: TextStyle(
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        color: Converter
                                                            .hexToColor(
                                                                '#1D2429'),
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                ),
                                                subtitle: FutureBuilder(
                                                    future:
                                                        _getLastMessage(room),
                                                    builder:
                                                        (context, snapshot) {
                                                      if (snapshot.hasData) {
                                                        return Text(
                                                          snapshot.data
                                                              as String,
                                                          style: GoogleFonts
                                                              .poppins(
                                                            textStyle:
                                                                TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontSize: 13.5,
                                                              color: Converter
                                                                  .hexToColor(
                                                                '#57636c',
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      } else {
                                                        return Container();
                                                      }
                                                    }),
                                                trailing: Container(
                                                  child: const Icon(
                                                    Icons.arrow_forward_ios,
                                                    color: Colors.black,
                                                    size: 15,
                                                  ),
                                                  height: 30,
                                                  width: 30,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey[300],
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                      Radius.circular(15),
                                                    ),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.grey
                                                            .withOpacity(0.5),
                                                        spreadRadius: 1,
                                                        blurRadius: 1,
                                                        offset: const Offset(
                                                          0.5,
                                                          1.5,
                                                        ), // changes position of shadow
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            // const Divider(
                                            //   height: 10,
                                            // ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                Positioned(
                  bottom: 90,
                  right: 25,
                  child: InkWell(
                    child: Container(
                      decoration: const BoxDecoration(
                          color: Constants.primaryColor,
                          borderRadius: BorderRadius.all(Radius.circular(22))),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.chat,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              "Create Chat!  ",
                              style: GoogleFonts.poppins(
                                  textStyle: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    onTap: _user == null
                        ? null
                        : () {
                            // Navigator.of(context).push(
                            //   MaterialPageRoute(
                            //     fullscreenDialog: true,
                            //     builder: (context) => const UsersPage(),
                            //   ),
                            // );
                            pushNewScreen(
                              context,
                              screen: const UsersPage(),
                              withNavBar: false,
                              pageTransitionAnimation:
                                  PageTransitionAnimation.cupertino,
                            );
                          },
                  ),
                )
              ],
            ),
          );
  }

  String _getUserName(types.Room room) {
    var user = room.users.firstWhere(
        (element) => element.id != FirebaseAuth.instance.currentUser!.uid);

    if (user.firstName != null && user.firstName!.isNotEmpty) {
      return user.firstName!;
    } else if (user.lastName != null && user.lastName!.isNotEmpty) {
      return user.lastName!;
    } else {
      return user.id;
    }
  }
}

ImageProvider _getNetWorkImage(String url) {
  if (url != "") {
    return NetworkImage(url);
  } else {
    return const AssetImage('assets/images/logo.png');
  }
}
