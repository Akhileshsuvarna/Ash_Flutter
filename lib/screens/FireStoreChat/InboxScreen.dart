import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import '../../constants.dart';
import '../Agora/AudioCallScreen.dart';
import '../Agora/VideoCallScreen.dart';
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

class _RoomsPageState extends State<RoomsPage> {
  bool _error = false;
  bool _initialized = false;
  User? _user;

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
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
        backgroundImage: hasImage ? NetworkImage(room.imageUrl!) : null,
        radius: 20,
        child: !hasImage
            ? Text(
                name.isEmpty ? '' : name[0].toUpperCase(),
                style: const TextStyle(color: Colors.white),
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
      return Container();
    }

    if (!_initialized) {
      return Container();
    }

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
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            // SizedBox(
                            //   width: 12,
                            // ),
                            // Icon(
                            //   Icons.settings,
                            //   color: Colors.black,
                            //   size: 30,
                            // ),
                            // Spacer(),
                            Text(
                              "Inbox",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 34,
                              ),
                            ),
                            // Spacer(),
                            // Icon(
                            //   Icons.search,
                            //   color: Colors.black,
                            //   size: 30,
                            // ),
                            // SizedBox(
                            //   width: 12,
                            // ),
                          ],
                        ),
                        const SizedBox(
                          height: 22,
                        ),
                        Row(
                          children: [
                            const SizedBox(
                              width: 25,
                            ),
                            GestureDetector(
                              onTap: () {
                                pushNewScreen(context,
                                    screen: const AudioCallScreen(),
                                    withNavBar: false);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Constants.primaryColor,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(16)),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Row(
                                      children: const [
                                        Icon(
                                          Icons.call,
                                          color: Colors.white,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "Audio",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                pushNewScreen(context,
                                    screen: const VideoCallScreen(),
                                    withNavBar: false);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Constants.primaryColor,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(16)),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Row(
                                      children: const [
                                        Icon(
                                          Icons.video_call_outlined,
                                          color: Colors.white,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "Video",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 25,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
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
                                child: const Text('Press + to Start a Chat'),
                              );
                            }

                            return Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, index) {
                                  final room = snapshot.data![index];
                                  return InkWell(
                                    onTap: () {
                                      pushNewScreen(context,
                                          screen: ChatPage(room: room),
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
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5))
                                                // boxShadow: const [
                                                //   BoxShadow(
                                                //     color: Colors.black12,
                                                //     offset:  Offset(
                                                //       0.0,
                                                //       0.0,
                                                //     ),
                                                //     blurRadius: 8.0,
                                                //     spreadRadius: 0.5,
                                                //   ), //BoxShadow
                                                //   BoxShadow(
                                                //     color: Colors.white,
                                                //     offset:  Offset(0.0, 0.0),
                                                //     blurRadius: 0.0,
                                                //     spreadRadius: 0.0,
                                                //   ), //BoxShadow
                                                // ],
                                                ),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 0,
                                              vertical: 0,
                                            ),
                                            child: ListTile(
                                              leading: _buildAvatar(room),
                                              title: Text(
                                                room.name ?? '',
                                                style: TextStyle(
                                                    fontStyle: FontStyle.normal,
                                                    fontFamily: 'Lexend Deca',
                                                    color: Colors.black,
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              subtitle: FutureBuilder(
                                                  future: _getLastMessage(room),
                                                  builder: (context, snapshot) {
                                                    if (snapshot.hasData) {
                                                      return Text(snapshot.data
                                                          as String);
                                                    } else {
                                                      return Container();
                                                    }
                                                  }),
                                              trailing: Container(
                                                child: const Icon(
                                                  Icons.arrow_forward_ios,
                                                  size: 15,
                                                ),
                                                height: 30,
                                                width: 30,
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                15))),
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
                          children: const [
                            Icon(
                              Icons.chat,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "New Chat!  ",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                    onTap: _user == null
                        ? null
                        : () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                fullscreenDialog: true,
                                builder: (context) => const UsersPage(),
                              ),
                            );
                          },
                  ),
                )
              ],
            ),
          );
  }
}
