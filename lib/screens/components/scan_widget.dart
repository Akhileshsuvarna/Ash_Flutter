import 'package:flutter/material.dart';
import 'package:health_connector/enums/enums.dart';

Widget scanWidget(
        {required Size size,
        required BuildContext context,
        required String text,
        required String imagePath,
        required ScanType type}) =>
    ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: size.width / 2,
        height: size.height / 4.5,
        // color: Colors.black,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.fill,
          ),
          // shape: BoxShape.circle,
        ),
        child: Column(
          children: [
            Text(text),
          ],
        ),
      ),
    );
