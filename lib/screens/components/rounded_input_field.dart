import 'package:flutter/material.dart';

class RoundedInputField extends StatelessWidget {
  final String labelText;
  final IconData? icon;
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;
  final bool isPassword;
  final TextEditingController? textEditingController;
  final TextInputType keyboardType;
  final Function() onTap;
  final Color cursorColor;
  final Color borderColor;
  final Color borderFocusColor;
  final Color fillColor;
  final Color labelTextColor;
  const RoundedInputField(
      {Key? key,
      required this.labelText,
      this.icon,
      this.onChanged,
      this.focusNode,
      this.isPassword = false,
      this.textEditingController,
      this.keyboardType = TextInputType.text,
      required this.onTap,
      this.cursorColor = Colors.black,
      this.borderColor = Colors.black,
      this.borderFocusColor = Colors.black,
      this.fillColor = Colors.transparent,
      this.labelTextColor = Colors.black})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return TextField(
        //focusNode: focusNode,
        obscureText: isPassword,
        onChanged: onChanged,
        cursorColor: cursorColor,
        controller: textEditingController,
        keyboardType: keyboardType,
        onTap: onTap,
        style: TextStyle(
            color: labelTextColor,
            fontFamily: 'Circular Std Book',
            fontSize: size.width / 22.5),
        decoration: InputDecoration(
            border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.all(Radius.circular(size.height / 116.32)),
                borderSide: BorderSide(color: borderColor)),
            focusedBorder: OutlineInputBorder(
                borderRadius:
                    BorderRadius.all(Radius.circular(size.height / 116.32)),
                borderSide: BorderSide(color: borderFocusColor)),
            prefixIcon: Padding(
                padding: EdgeInsets.only(left: size.width / 36),
                child: icon != null ? Icon(icon, color: Colors.white) : null),
            labelText: labelText,
            labelStyle: TextStyle(
                color: labelTextColor,
                fontFamily: 'Circular Std Book',
                fontSize: size.width / 25.71),
            alignLabelWithHint: true,
            fillColor: fillColor,
            filled: true));
  }
}
