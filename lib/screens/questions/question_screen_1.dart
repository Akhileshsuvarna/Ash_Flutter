import 'package:flutter/material.dart';
import 'package:health_connector/main.dart';
import 'package:health_connector/util/device_utils.dart';

import '../../constants.dart';

class QuestionScreen1 extends StatefulWidget {
  const QuestionScreen1({Key? key}) : super(key: key);

  @override
  _QuestionScreen1State createState() => _QuestionScreen1State();
}

class _QuestionScreen1State extends State<QuestionScreen1> {
  int _questionIndex = 0;
  int _answerIndex = 0;

  TextEditingController editController = TextEditingController();

  String? _selectedAnswer;

  ///
  ///Redirect to next index question-answer
  ///
  void _nextQuestion() async {
    setState(() {
      if (_questionIndex == 4 && _answerIndex == 4) {
        if (_selectedAnswer?.toLowerCase() ==
                _answer[_answerIndex]['answers']![1].toLowerCase() ||
            _selectedAnswer == _answer[_answerIndex]['answers']![2]) {
          _questionIndex = 6;
          _answerIndex = 6;
          _selectedAnswer = null;
          return;
        } else if (_selectedAnswer == _answer[_answerIndex]['answers']![0]) {
          _questionIndex = 5;
          _answerIndex = 5;
          _selectedAnswer = null;
          return;
        }
      }
      if (_questionIndex == 5 && _answerIndex == 5 && _selectedAnswer != null) {
        //TODO upload Questionaire data to firebase here from questionareData object.
        firebaseDatabase
            .ref()
            .child(Constants.dbRoot)
            .child('users')
            .child(userProfile.data!.uuid)
            .child('questionnaireData')
            .set(questionaireData.toJson())
            .then((value) => Navigator.of(context)
                .pushReplacementNamed(Constants.userHomeScreen));
      } else if (_questionIndex == 6 &&
          _answerIndex == 6 &&
          _selectedAnswer != null) {
        Navigator.of(context).pushReplacementNamed(Constants.userHomeScreen);
      } else {
        if (_questionIndex < 5 && _answerIndex < 5) {
          _questionIndex++;
          _answerIndex++;
        }
        _selectedAnswer = null;
      }
    });
  }

  ///
  ///Implemented at back button , for going to previous question
  ///
  void _previousQuestion() async {
    if (_questionIndex == 0 && _answerIndex == 0) {
      Navigator.of(context).pushReplacementNamed(Constants.questionScreen0);
    } else {
      setState(() {
        _questionIndex--;
        _answerIndex--;
        _selectedAnswer = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Constants.appBackgroundColor,
        body: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        left: DeviceUtils.width(context) / 150,
                        top: DeviceUtils.height(context) / 60),
                    child: Stack(children: [
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
                              _previousQuestion();
                            },
                          ),
                        ),
                      ),
                      gif(),
                    ]),
                  ),
                  questionCard(),
                  _questionIndex != 1 ? dropDown() : textField(),
                ],
              ),
              continueButton(),
            ],
          ),
        ));
  }

  ///set gif
  Widget gif() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: DeviceUtils.height(context) / 30),
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

  ///display question in card
  Widget questionCard() {
    return Padding(
      padding: EdgeInsets.only(
        left: DeviceUtils.width(context) / 30,
        right: DeviceUtils.width(context) / 30,
      ),
      child: Card(
        elevation: 7.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // if you need this
        ),
        color: Color(0xFFF5F5F5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                      left: DeviceUtils.width(context) / 30,
                      top: DeviceUtils.height(context) / 50),
                  child: const Text("Welcome,",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Color(0xFF662D90),
                          fontSize: 20.0,
                          fontFamily: 'Lexend Deca',
                          fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      right: DeviceUtils.width(context) / 30,
                      top: DeviceUtils.height(context) / 50),
                  child: Text(_questions[_questionIndex]['count']!,
                      textDirection: TextDirection.ltr,
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                          color: Color(0xFF662D90),
                          fontSize: 20.0,
                          fontFamily: 'Lexend Deca',
                          fontWeight: FontWeight.bold)),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: DeviceUtils.width(context) / 30,
                  right: DeviceUtils.width(context) / 30,
                  top: DeviceUtils.height(context) / 50),
              child: Align(
                alignment: Alignment.center,

                ///print question according to the Index
                child: Text(_questions[_questionIndex]['question']!,
                    // "How many areas of concern do you have?",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFF313131),
                      fontSize: 20,
                      fontFamily: 'Lexend Deca',
                      fontWeight: FontWeight.w500,
                    )),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: DeviceUtils.width(context) / 30,
                  right: DeviceUtils.width(context) / 30,
                  top: DeviceUtils.height(context) / 25,
                  bottom: DeviceUtils.height(context) / 30),
              child: const Align(
                alignment: Alignment.center,
                child: Text("Choose from the following list below.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Color(0xFF313131),
                        fontSize: 20,
                        fontFamily: 'Lexend Deca',
                        fontWeight: FontWeight.w500)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///dropdown Widget
  Widget dropDown() {
    return Padding(
      padding: EdgeInsets.only(
          left: DeviceUtils.width(context) / 10,
          right: DeviceUtils.width(context) / 10,
          top: DeviceUtils.height(context) / 30),
      child: Container(
        decoration: BoxDecoration(
            color: Color(0xFF662D90), borderRadius: BorderRadius.circular(10)),
        child: DropdownButtonFormField<String>(
          decoration: const InputDecoration(
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent))),
          onChanged: (value) {
            setState(() {
              _selectedAnswer = value;
            });
          },
          value: _selectedAnswer,
          hint: Padding(
            padding: EdgeInsets.only(
                left: DeviceUtils.width(context) / 20,
                top: DeviceUtils.height(context) / 200),
            child: const Text(
              'Please select...',
              textAlign: TextAlign.start,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.0,
                  fontFamily: 'Lexend Deca',
                  fontWeight: FontWeight.bold),
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
          validator: (value) => value == null ? 'field required' : null,
          // The list of options
          items: _answer[_answerIndex]['answers']!
              .map((e) => DropdownMenuItem(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        e,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14.0,
                            fontFamily: 'Lexend Deca',
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    value: e,
                  ))
              .toList(),

          selectedItemBuilder: (BuildContext context) =>
              _answer[_answerIndex]['answers']!
                  .map((e) => Center(
                        child: Text(
                          e,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14.0,
                              fontFamily: 'Lexend Deca',
                              fontWeight: FontWeight.bold),
                        ),
                      ))
                  .toList(),
        ),
      ),
    );
  }

  Widget textField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.only(
              left: DeviceUtils.width(context) / 35,
              right: DeviceUtils.width(context) / 35,
              top: DeviceUtils.height(context) / 30),
          child: SizedBox(
            // height:DeviceUtils.width(context) / 5,
            child: TextFormField(
              controller: editController,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14.0,
                  fontFamily: 'Lexend Deca',
                  fontWeight: FontWeight.bold),
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Constants.appBarColor),
                ),
                labelText: "Enter your areas of concern",
                labelStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 14.0,
                    fontFamily: 'Lexend Deca',
                    fontWeight: FontWeight.bold),
                hintText: "Enter your areas of concern",
                hintStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 14.0,
                    fontFamily: 'Lexend Deca',
                    fontWeight: FontWeight.bold),
              ),
              autofocus: false,
            ),
          ),
        ),
      ],
    );
  }

  Widget continueButton() {
    return Padding(
      padding: EdgeInsets.only(
        left: DeviceUtils.width(context) / 3.5,
        top: DeviceUtils.height(context) / 1.2,
      ),
      child: Row(
        children: [
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: DeviceUtils.width(context) / 2.5,
              child: ElevatedButton(
                  onPressed: () {
                    if (_questionIndex == 0 || _questionIndex > 1) {
                      if (_selectedAnswer == null) {
                        //  TODO(skandar): Code duplication. snackbar functionavailable in Constants.
                        //  TODO(skandar): Move snackBar to utils instead of constants.
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text(
                            'Please select an answer before going to the next question',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.0,
                                fontFamily: 'Lexend Deca',
                                fontWeight: FontWeight.bold),
                          ),
                        ));
                        return;
                      } else {
                        if (_questionIndex == 0) {
                          questionaireData.numberOfAreasOfConcerns =
                              _selectedAnswer;
                        } else if (_questionIndex == 2) {
                          questionaireData.painDuration = _selectedAnswer;
                        } else if (_questionIndex == 3) {
                          questionaireData.firstTimeOrOngoing = _selectedAnswer;
                        } else if (_questionIndex == 4) {
                          questionaireData.levelOfActivity = _selectedAnswer;
                        } else if (_questionIndex == 5) {
                          questionaireData.nonExercisingReason =
                              _selectedAnswer;
                        }
                      }
                    } else if (_questionIndex == 1) {
                      if (editController.text.isEmpty) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text(
                            'Please write an answer before going to the next question',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.0,
                                fontFamily: 'Lexend Deca',
                                fontWeight: FontWeight.bold),
                          ),
                        )); //
                        return;
                      } else {
                        questionaireData.areasOfConcern = editController.text;
                      }
                    }
                    _nextQuestion();
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    elevation: 10,
                    primary: Colors.white,
                  ),
                  child: const Text('Continue',
                      style: TextStyle(
                          color: Color(0xFF28A9E1),
                          fontSize: 20.0,
                          fontFamily: 'Lexend Deca',
                          fontWeight: FontWeight.bold))),
            ),
          ),
        ],
      ),
    );
  }
}

///List of Questions
const _questions = [
  {
    'question': 'How many areas of concern do you have?',
    'count': '1/5',
  },
  {
    'question': 'What are your areas of concern?',
    'count': '2/5',
  },
  {
    'question': 'How long have you had this pain for?',
    'count': '3/5',
  },
  {
    'question': 'Is this the first time you’ve had this pain or is it ongoing?',
    'count': '4/5',
  },
  {
    'question': 'What is your current level of activity?',
    'count': '5/5',
  },
  {
    'question': 'Why are you not currently exercising?',
    'count': '5(a)',
  },
  {
    'question': 'How many times per week do you exercise?',
    'count': '5(b)',
  },
];

///List  of answer
const _answer = [
  {
    'answers': [" 0-1", "2-3", "  >3"], //A-1
  },
  {
    'answers': [" "], //A-2
  },
  {
    'answers': [" 0-6 weeks", "7-12 weeks", ">12 weeks"], //A-3
  },
  {
    'answers': [" First time", "Ongoing "], //A-4
  },
  {
    'answers': [
      " No exercise",
      "Physiotherapy guided exercise",
      "Independent exercise"
    ], //A-5
  },
  {
    'answers': [" Due to pain", "Do not have the resources "], //A-5(a)
  },
  {
    'answers': ["0-1", "2-4 ", ">4"], //A-5(b)
  },
];
