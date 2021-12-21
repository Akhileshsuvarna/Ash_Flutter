import 'package:flutter/material.dart';
import 'package:health_connector/constants.dart';
import 'package:health_connector/util/device_utils.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final Function() onPressed;
  final Color color, textColor;
  final Widget? prefix;
  const RoundedButton({
    Key? key,
    required this.text,
    required this.onPressed,
    required this.color,
    this.textColor = Constants.primaryTextColor,
    this.prefix,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = DeviceUtils.size(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(29),
      child: TextButton(
        onPressed: onPressed(),
        child: Container(
          //width: size.width * 0.8,
          height: size.height * 0.075,
          //color: color,
          decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(size.height / 115.32),
              border: Border.all()),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              prefix != null
                  ? Padding(
                      padding: EdgeInsets.only(left: size.width / 40),
                      child: SizedBox(
                        height: size.height / 22,
                        child: prefix,
                      ),
                    )
                  : SizedBox(width: size.width / 15),
              //TODO - Sikander: make this padding responsive
              Padding(
                padding: const EdgeInsets.only(
                  left: 5.0,
                ),
                child: Text(
                  text,
                  style: TextStyle(
                      color: textColor,
                      fontFamily: 'Circular_Std_Bold',
                      fontSize: size.width / 28),
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
