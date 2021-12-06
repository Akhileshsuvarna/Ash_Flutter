import 'package:flutter/material.dart'
    show
        BuildContext,
        ScaffoldMessenger,
        SnackBar,
        Text,
        TextStyle,
        SnackBarBehavior,
        Colors,
        RoundedRectangleBorder,
        BorderRadius,
        Radius,
        Navigator,
        Center,
        Column,
        MainAxisAlignment,
        CircularProgressIndicator,
        Widget,
        AlertDialog,
        showDialog,
        TextDirection,
        Directionality,
        State,
        VoidCallback;

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

  static void popup(Widget? title, Widget? content, BuildContext context) =>
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
              backgroundColor: Colors.white,
              shape: dialogShape,
              title: title,
              content: content));

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
