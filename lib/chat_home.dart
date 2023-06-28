import 'package:flutter/material.dart';
import 'package:health_connector/chat_screen.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 200.0,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF8000FF), Color(0xFF00C2FF)],
                  stops: [0, 1],
                  begin: AlignmentDirectional(-1, 0),
                  end: AlignmentDirectional(1, 0),
                ),
                borderRadius: BorderRadius.vertical(
                    bottom: Radius.elliptical(500, 300.0)),
              ),
              child: const Align(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                      child: Text(
                        'Say Hello To DocBot!',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Text(
                      'Your new \ndigital healthcare assistant',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 8),
              child: Text(
                'How It Works',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.asset(
                  'assets/images/chatbot.png',
                  width: 250,
                  height: 250,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                'DocBot is here to answer your questions in a simple and intuitive way. \n\nHere are some tips to get you started:',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 18),
              child: Text(
                '*Speak to DocBot like you would your real doctor\n*The more information you provide, the better your results\n*Save your chats to view later\n*Ask followup questions\n*Be specific about what you are looking for help with\n*DocBot can recommend natural & at home remedies',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              width: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.0),
                gradient: const LinearGradient(
                  colors: [Color(0xFF8000FF), Color(0xFF00C2FF)],
                  stops: [0, 1],
                  begin: AlignmentDirectional(-1, 0),
                  end: AlignmentDirectional(1, 0),
                ),
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.transparent,
                  onSurface: Colors.transparent,
                  shadowColor: Colors.transparent,),
                onPressed: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ConversationPage()));
                  // Navigator.of(context).pushReplacementNamed(Constants.conversationPage);
                },
                child: const Center(
                  child: Text(
                    'BEGIN',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xffffffff),
                      letterSpacing: -0.3858822937011719,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
