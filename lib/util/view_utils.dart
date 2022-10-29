import 'package:circular_progress_indicator/circular_progress_indicator.dart';
import 'package:flutter/material.dart'
    show
        AlertDialog,
        BorderRadius,
        BuildContext,
        Center,
        CircularProgressIndicator,
        Color,
        Colors,
        Column,
        Directionality,
        GestureDetector,
        MainAxisAlignment,
        Navigator,
        Radius,
        RoundedRectangleBorder,
        ScaffoldMessenger,
        SnackBar,
        SnackBarBehavior,
        State,
        Text,
        TextDirection,
        TextStyle,
        VoidCallback,
        Widget,
        showDialog;
import 'package:flutter/src/widgets/container.dart';

import '../constants.dart';

class ViewUtils {
  static const RoundedRectangleBorder dialogShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(10.0)));

  const ViewUtils._();

  static void rebuild(State state, {VoidCallback? fn}) {
    if (state.mounted) {
      // ignore: invalid_use_of_protected_member
      state.setState(fn ?? () {});
    }
  }

  static void toast(String text, bool error, BuildContext context) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          shape: dialogShape,
          behavior: SnackBarBehavior.floating,
          backgroundColor: error ? Colors.redAccent : Colors.greenAccent,
          duration: Duration(seconds: error ? 5 : 3),
          content: Text(text, style: const TextStyle(color: Colors.white))));

  static void popup(
    Widget? title,
    BuildContext context, {
    Widget? content,
    bool barrierDismissible = false,
    Color boxColor = Colors.transparent,
    List<Widget>? actions,
  }) =>
      showDialog(
        context: context,
        barrierDismissible: barrierDismissible,
        builder: (context) => AlertDialog(
          backgroundColor: boxColor,
          shape: dialogShape,
          title: title,
          content: content,
          actions: actions,
        ),
      );

  static void customCircularProgressPopup(BuildContext context) => popup(
        customProgressIndicatorWidget(),
        context,
      );

  static Widget customProgressIndicatorWidget({double size = 200}) =>
      CustomProgressIndicator(
        height: size,
        width: size,
        fourthArcColor: Constants.primaryColor,
        firstArcColor: Colors.blue,
        secondArcColor: Colors.white,
        thirdArcColor: Colors.white,
        backgroundColor: Colors.transparent,
      );

  static void pop(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  static void popAll(BuildContext context) =>
      Navigator.popUntil(context, (route) => route.isFirst);

  static Center createLoader() => Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
            CircularProgressIndicator(),
            Text(Constants.loading)
          ]));

  static TextDirection getTextDirection(bool ltr) =>
      ltr ? TextDirection.ltr : TextDirection.rtl;

  static Directionality wrapDirectionality(bool ltr, Widget child) =>
      Directionality(textDirection: getTextDirection(ltr), child: child);
}
