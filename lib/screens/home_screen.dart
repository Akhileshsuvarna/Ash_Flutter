import 'package:connectycube_flutter_call_kit/connectycube_flutter_call_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_connector/constants.dart';
import 'package:health_connector/screens/Agora/VideoCallScreen.dart';
import 'package:health_connector/screens/exercises_screen.dart';
import 'package:health_connector/screens/user_profile_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import '../breathing.dart';
import '../chat_home.dart';
import '../log/logger.dart';
import '../main.dart';
import '../services/call_services.dart';
import 'Agora/AudioCallScreen.dart';
import 'FireStoreChat/InboxScreen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PersistentTabController persistentTabController =
      PersistentTabController(initialIndex: 0);
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    _listenForIncomingcalls();
  }

  @override
  void dispose() {
    super.dispose();

    Logger.info("HomeScreen was disposed");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.connectionState == ConnectionState.active &&
                snapshot.data == null) {
              //TODO(skandar) Show some loader animation and some Good Bye / see you again message.

              WidgetsBinding.instance.addPostFrameCallback(
                (_) => Navigator.of(context, rootNavigator: true)
                    .pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return const LoginPage();
                    },
                  ),
                  (_) => false,
                ),
              );

              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.connectionState == ConnectionState.active &&
                snapshot.data != null) {
              return StreamBuilder(
                stream: bloc.streamState,
                initialData: incomingCallEvent == null
                    ? CallServicesCallState.idle
                    : incomingCallEvent!.callType == 0
                        ? CallServicesCallState.incomingAudioCall
                        : CallServicesCallState.incomingVideoCall,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.data as CallServicesCallState ==
                      CallServicesCallState.idle) {
                    return _homeScreen(context);
                  } else if (snapshot.data as CallServicesCallState ==
                      CallServicesCallState.incomingVideoCall) {
                    //
                    if (incomingCallEvent != null) {
                      WidgetsBinding.instance.addPostFrameCallback(
                        (_) => Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) {
                              return VideoCallScreen(
                                  roomId:
                                      incomingCallEvent!.userInfo!['roomId']);
                            },
                          ),
                        ),
                      );
                    }
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.data as CallServicesCallState ==
                      CallServicesCallState.incomingAudioCall) {
                    if (incomingCallEvent != null) {
                      WidgetsBinding.instance.addPostFrameCallback(
                        (_) => Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) {
                              return AudioCallScreen(
                                  roomId:
                                      incomingCallEvent!.userInfo!['roomId']);
                            },
                          ),
                        ),
                      );
                    }
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return _homeScreen(context);
                  }
                },
              );
            } else {
              return const Center(
                  child: Text('unKnownSate please contact Admin'));
            }
          }),
    );
  }

  PersistentTabView _homeScreen(BuildContext context) {
    return PersistentTabView(
      context,
      controller: persistentTabController,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineInSafeArea: true,
      backgroundColor: Colors.white,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: false,
      navBarHeight: MediaQuery.of(context).viewInsets.bottom > 0
          ? 0.0
          : kBottomNavigationBarHeight,
      hideNavigationBarWhenKeyboardShows: false,
      margin: const EdgeInsets.all(0.0),
      popActionScreens: PopActionScreensType.all,
      bottomScreenMargin: 0.0,
      decoration: NavBarDecoration(
          colorBehindNavBar: Colors.indigo,
          borderRadius: BorderRadius.circular(20.0)),
      popAllScreensOnTapOfSelectedTab: true,
      itemAnimationProperties: const ItemAnimationProperties(
        duration: Duration(milliseconds: 400),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: const ScreenTransitionAnimation(
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle: NavBarStyle.style6,
      onItemSelected: (index) {
        setState(() {
          debugPrint('$index');
          selectedIndex = index;
        });
      },
    );
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.accessibility_sharp),
        title: selectedIndex == 0 ? "Exercises" : null,
        activeColorPrimary: Constants.selectedTab,
        inactiveColorPrimary: Constants.unSelectedTab,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.video_call),
        title: selectedIndex == 1 ? ("Video Chat") : null,
        activeColorPrimary: Constants.selectedTab,
        inactiveColorPrimary: Constants.unSelectedTab,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.chat),
        title: selectedIndex == 2 ? ("Chat") : null,
        activeColorPrimary: Constants.selectedTab,
        inactiveColorPrimary: Constants.unSelectedTab,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.self_improvement),
        title: selectedIndex == 3 ? ("Meditate") : null,
        activeColorPrimary: Constants.selectedTab,
        inactiveColorPrimary: Constants.unSelectedTab,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.account_circle_sharp),
        title: selectedIndex == 4 ? ("Profile") : null,
        activeColorPrimary: Constants.selectedTab,
        inactiveColorPrimary: Constants.unSelectedTab,
      ),
    ];
  }

  List<Widget> _buildScreens() {
    return [
      const ExercisePage(),
      // const VideoScreen(),
      const RoomsPage(),
      //RoomsPage is Inbox Screen
      const ChatScreen(),
      //ChatScreen
      BreathingGame(),
      //BreathingGame
      const UserProfileScreen()
      //UserProfileScreen
    ];
  }

  void _listenForIncomingcalls() {}
}
