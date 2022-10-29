import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health_connector/main.dart';
import 'package:health_connector/models/questionaire.dart';

import 'package:health_connector/util/device_utils.dart';

import '../../constants.dart';

class QuestionScreen0 extends StatefulWidget {
  const QuestionScreen0({Key? key}) : super(key: key);

  @override
  _QuestionScreen0State createState() => _QuestionScreen0State();
}

class _QuestionScreen0State extends State<QuestionScreen0> {
  final List<String> _option = ["Male", "Female"];
  TextEditingController ageEditController = TextEditingController();
  TextEditingController heightEditController = TextEditingController();
  TextEditingController weightEditController = TextEditingController();

  // TODO(skandar): Wrong Naming Convention.
  String? _selectedGender;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.appBackgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
              left: DeviceUtils.width(context) / 150,
              top: DeviceUtils.height(context) / 60),
          child: Stack(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Stack(children: [
                    Padding(
                      padding: EdgeInsets.only(
                          left: DeviceUtils.width(context) / 150,
                          top: DeviceUtils.height(context) / 60),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios_new_sharp,
                            color: Color(0xFF662D90),
                            size: 25,
                          ),
                          onPressed: () {
                            Navigator.of(context)
                                .pushReplacementNamed(Constants.logIn);
                          },
                        ),
                      ),
                    ),
                    _prescriptionGif(),
                  ]),
                  _measurementsData(),
                  const SizedBox(height: 100),
                  continueButton(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _prescriptionGif() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: DeviceUtils.height(context) / 80),
          child: ClipRect(
              child: Align(
            alignment: Alignment.center,
            heightFactor: 1,
            child: Image.asset(
              'assets/images/prescription.gif',
              width: MediaQuery.of(context).size.height * 0.3,
              height: MediaQuery.of(context).size.height * 0.3,
              fit: BoxFit.fill,
              scale: 1.0,
            ),
          )),
        )
      ],
    );
  }

  Widget _measurementsData() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: DeviceUtils.width(context) / 35,
            right: DeviceUtils.width(context) / 35,
          ),
          child: SizedBox(
            // height:DeviceUtils.width(context) / 5,
            child: TextFormField(
              controller: ageEditController,
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                    color: Colors.black,
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold),
              ),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Constants.appBarColor),
                ),
                labelText: "Enter Your Age",
                labelStyle: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold),
                ),
                hintText: "Enter Your Age",
                hintStyle: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                    color: Colors.black,
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              autofocus: false,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
              left: DeviceUtils.width(context) / 35,
              right: DeviceUtils.width(context) / 35,
              top: DeviceUtils.height(context) / 60),
          child: SizedBox(
            // height:DeviceUtils.width(context) / ,
            child: TextFormField(
              controller: heightEditController,
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Constants.appBarColor),
                ),
                labelText: "Enter Your Height",
                labelStyle: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                    color: Colors.black,
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                hintText: "Enter Your Height",
                // icon: Icon(Icons.height),
                hintStyle: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                    color: Colors.black,
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              autofocus: false,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
              left: DeviceUtils.width(context) / 35,
              right: DeviceUtils.width(context) / 35,
              top: DeviceUtils.height(context) / 60),
          child: SizedBox(
            // height:DeviceUtils.width(context) / 5,
            child: TextFormField(
              controller: weightEditController,
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Constants.appBarColor),
                ),
                labelText: "Enter Your Weight",
                labelStyle: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                    color: Colors.black,
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                hintText: "Enter Your Weight",
                hintStyle: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                    color: Colors.black,
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              autofocus: false,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
              left: DeviceUtils.width(context) / 10,
              right: DeviceUtils.width(context) / 10,
              top: DeviceUtils.height(context) / 30),
          child: Container(
            // width: 100,
            // padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            decoration: BoxDecoration(
                color: const Color(0xFF662D90),
                borderRadius: BorderRadius.circular(10)),
            child: DropdownButton<String>(
              onChanged: (value) {
                setState(() {
                  _selectedGender = value;
                });
              },
              value: _selectedGender,
              underline: Container(),
              hint: Padding(
                padding: EdgeInsets.only(
                    left: DeviceUtils.width(context) / 20,
                    top: DeviceUtils.height(context) / 64),
                child: Text(
                  'Select Your Gender',
                  textAlign: TextAlign.start,
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              icon: Padding(
                padding: EdgeInsets.only(
                    right: DeviceUtils.width(context) / 20,
                    top: DeviceUtils.height(context) / 300),
                child: const Icon(
                  Icons.arrow_drop_down,
                  color: Colors.black38,
                ),
              ),
              isExpanded: true,
              items: _option
                  .map((e) => DropdownMenuItem(
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            e,
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        value: e,
                      ))
                  .toList(),
              selectedItemBuilder: (BuildContext context) => _option
                  .map((e) => Center(
                        child: Text(
                          e,
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  ///Navigate to next question screen
  Widget continueButton() {
    return Padding(
      padding: EdgeInsets.only(
        left: DeviceUtils.width(context) / 3.5,
        // top: DeviceUtils.height(context) / 1.15,
      ),
      child: Row(
        children: [
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: DeviceUtils.width(context) / 2.5,
              child: ElevatedButton(
                onPressed: () {
                  if (ageEditController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                        'Please enter your Age before going to the next question',
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ));
                    return;
                  } else if (heightEditController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                        'Please enter your height before going to the next question',
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ));
                    return;
                  } else if (weightEditController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                        'Please enter your weight before going to the next question',
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ));
                    return;
                  } else if (_selectedGender == null) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                        'Please select gender before going to the next question',
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ));
                    return;
                  } else {
                    // TODO(skandar): Data not being stored anywhere. Inaccible for Screen destruction.
                    questionaireData = Questionaire(
                        age: int.parse(ageEditController.text),
                        height: int.parse(heightEditController.text),
                        weight: int.parse(weightEditController.text),
                        gender: _selectedGender);
                    Navigator.of(context)
                        .pushReplacementNamed(Constants.questionScreen1);
                  }
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  elevation: 10,
                  primary: Colors.white,
                ),
                child: Text(
                  'Continue',
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      color: Color(0xFF28A9E1),
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
