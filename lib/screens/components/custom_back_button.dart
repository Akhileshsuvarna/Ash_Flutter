import 'package:flutter/material.dart';

Widget customBackButton(BuildContext context, {Color? color}) => IconButton(
    color: color,
    icon: const BackButtonIcon(),
    onPressed: () => Navigator.maybePop(context));
