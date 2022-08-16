import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health_connector/screens/components/custom_back_button.dart';
import 'package:health_connector/util/converter.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import '../../constants.dart';
import 'chat.dart';
import 'util.dart';
import 'package:loading_overlay/loading_overlay.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({Key? key}) : super(key: key);

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  bool isFetchingData = false;
  int selectedIndex = -1;
  late types.User selectedUser;

  void _handlePressed(types.User otherUser, BuildContext context) async {
    final room = await FirebaseChatCore.instance.createRoom(otherUser);
    Navigator.of(context).pop();
    pushNewScreen(context,
        screen: ChatPage(
          room: room,
          chatUserName: otherUser.firstName,
        ),
        withNavBar: false);
  }

  Widget _buildAvatar(types.User user) {
    final color = getUserAvatarNameColor(user);
    final hasImage = user.imageUrl != null;
    final name = getUserName(user);

    return Container(
      margin: const EdgeInsets.only(right: 16),
      child: CircleAvatar(
        backgroundColor: hasImage ? Colors.transparent : color,
        backgroundImage: hasImage ? NetworkImage(user.imageUrl!) : null,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants.appBackgroundColor,
        elevation: 0,
        leading:
            customBackButton(context, color: Converter.hexToColor('#303030')),
        title: Text(
          'Add Friends To Chat',
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.normal,
              color: Converter.hexToColor('#303030'),
            ), // default text style
          ),
        ),
      ),
      body: LoadingOverlay(
        isLoading: false,
        child: StreamBuilder<List<types.User>>(
          stream: FirebaseChatCore.instance.users(),
          initialData: const [],
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(
                  bottom: 200,
                ),
                child: const Text('No users'),
              );
            }

            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final user = snapshot.data![index];

                return ListTile(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                      selectedUser = user;
                    },
                    leading: _buildAvatar(user),
                    title: Text(
                      getUserName(user),
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          // fontSize: 22.0,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal,
                          // color: Colors.white,
                        ), // default text style
                      ),
                    ),
                    subtitle: Text(
                      user.metadata?['email'] ?? "",
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal,
                          color: Colors.grey,
                        ), // default text style
                      ),
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        setState(() {
                          selectedIndex = index;
                        });
                        selectedUser = user;
                      },
                      icon: Icon(
                        selectedIndex == index
                            ? Icons.check_box
                            : Icons.check_box_outline_blank,
                        color: selectedIndex == index
                            ? Converter.hexToColor('#27A9E1')
                            : Colors.grey,
                      ),
                    ));

                // return InkWell(
                //   onTap: () {
                //     setState(() {
                //       isFetchingData = true;
                //     });
                //     _handlePressed(user, context);
                //   },
                //   child: Container(
                //     padding: const EdgeInsets.symmetric(
                //       horizontal: 16,
                //       vertical: 8,
                //     ),
                //     // child: Expanded(
                //     //   flex: 1,
                //     child: Column(
                //       children: [
                //         Row(
                //           children: [
                //             _buildAvatar(user),
                //             Text(getUserName(user)),
                //           ],
                //         ),
                //         const Divider(
                //           height: 8,
                //         )
                //       ],
                //     ),
                //     // ),
                //   ),
                // );
              },
            );
          },
        ),
      ),
      bottomSheet: GestureDetector(
        onTap: () {
          _handlePressed(selectedUser, context);
        },
        child: Container(
          height: MediaQuery.of(context).size.height / 8,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Converter.hexToColor('#27A9E1'),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10.0),
              topRight: Radius.circular(10.0),
            ),
          ),
          child: Center(
            child: Text(
              "Invite to chat",
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.normal,
                  color: Colors.white,
                ), // default text style
              ),
            ),
          ),
        ),
      ),
    );
  }
}
