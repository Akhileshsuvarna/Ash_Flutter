import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_connector/constants.dart';
import 'package:health_connector/screens/exercises_screen.dart';
import 'package:health_connector/screens/user_profile_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'FireStoreChat/InboxScreen.dart';

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
  }

  _monitorLoginState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PersistentTabView(
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
      ),
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
        icon: const Icon(Icons.account_circle_sharp),
        title: selectedIndex == 2 ? ("Profile") : null,
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
      const UserProfileScreen()
    ];
  }
}
