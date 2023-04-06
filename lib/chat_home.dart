// // import '/flutter_flow/flutter_flow_theme.dart';
// // import '/flutter_flow/flutter_flow_util.dart';
// // import '/flutter_flow/flutter_flow_widgets.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';
//
// // import 'home_page_model.dart';
// // export 'home_page_model.dart';
//
// class HomePageWidget extends StatefulWidget {
//   const HomePageWidget({Key? key}) : super(key: key);
//
//   @override
//   _HomePageWidgetState createState() => _HomePageWidgetState();
// }
//
// class _HomePageWidgetState extends State<HomePageWidget> {
//   // late HomePageModel _model;
//
//   final scaffoldKey = GlobalKey<ScaffoldState>();
//   final _unfocusNode = FocusNode();
//
//   @override
//   void initState() {
//     super.initState();
//     // _model = createModel(context, () => HomePageModel());
//   }
//
//   @override
//   void dispose() {
//     // _model.dispose();
//
//     _unfocusNode.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: scaffoldKey,
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: GestureDetector(
//           onTap: () => FocusScope.of(context).requestFocus(_unfocusNode),
//           child: Column(
//             mainAxisSize: MainAxisSize.max,
//             children: [
//               Container(
//                 width: double.infinity,
//                 height: 157.7,
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [Color(0xFF8000FF), Color(0xFF00C2FF)],
//                     stops: [0, 1],
//                     begin: AlignmentDirectional(-1, 0),
//                     end: AlignmentDirectional(1, 0),
//                   ),
//                   borderRadius: BorderRadius.only(
//                     bottomLeft: Radius.circular(200),
//                     bottomRight: Radius.circular(200),
//                     topLeft: Radius.circular(0),
//                     topRight: Radius.circular(0),
//                   ),
//                 ),
//                 child: Align(
//                   alignment: AlignmentDirectional(0, 0),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.max,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Align(
//                         alignment: AlignmentDirectional(0, -0.4),
//                         child: Padding(
//                           padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
//                           child: Text(
//                             'Say Hello To DocBot!',
//                             style: TextStyle(
//                               fontFamily: 'Poppins',
//                               color: Colors.white,
//                               fontSize: 20,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ),
//                       ),
//                       Text(
//                         'Your new \ndigital healthcare assistant',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           fontFamily: 'Poppins',
//                           color: Colors.white,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               Align(
//                 alignment: AlignmentDirectional(0, 0),
//                 child: Padding(
//                   padding: EdgeInsetsDirectional.fromSTEB(0, 15, 0, 0),
//                   child: Text(
//                     'How It Works',
//                     style: TextStyle(
//                       fontFamily: 'Poppins',
//                       fontSize: 24,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
//                 child: Image.asset(
//                   'assets/images/Rectangle_5.png',
//                   width: 278,
//                   height: 272.4,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
//                 child: Text(
//                   'DocBot is here to answer your questions in a simple and intuitive way. \n\nHere are some tips to get you started:',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     fontFamily: 'Poppins',
//                     fontSize: 12,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
//                 child: Text(
//                   '*Speak to DocBot like you would your real doctor\n*The more information you provide, the better your results\n*Save your chats to view later\n*Ask followup questions\n*Be specific about what you are looking for help with\n*DocBot can recommend natural & at home remedies',
//                   textAlign: TextAlign.center,
//                   style: FlutterFlowTheme.of(context).bodyMedium.override(
//                     fontFamily: 'Poppins',
//                     fontSize: 12,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
//                 child: ElevatedButton(
//                   onPressed: () {
//                     print('Button pressed ...');
//                   },
//                   text: 'BEGIN',
//                   child: FFButtonOptions(
//                     width: 130,
//                     height: 40,
//                     padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
//                     iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
//                     color: FlutterFlowTheme.of(context).primary,
//                     textStyle: FlutterFlowTheme.of(context).titleSmall.override(
//                       fontFamily: 'Poppins',
//                       color: Colors.white,
//                       fontSize: 16,
//                     ),
//                     borderSide: BorderSide(
//                       color: Colors.transparent,
//                       width: 1,
//                     ),
//                     borderRadius: BorderRadius.circular(22),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
