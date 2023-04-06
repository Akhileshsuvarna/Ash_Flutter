// // import '/flutter_flow/flutter_flow_theme.dart';
// // import '/flutter_flow/flutter_flow_util.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';
//
// // import 'chat_screen1_model.dart';
// // export 'chat_screen1_model.dart';
//
// class ChatScreen1Widget extends StatefulWidget {
//   const ChatScreen1Widget({Key? key}) : super(key: key);
//
//   @override
//   _ChatScreen1WidgetState createState() => _ChatScreen1WidgetState();
// }
//
// class _ChatScreen1WidgetState extends State<ChatScreen1Widget> {
//   // late ChatScreen1Model _model;
//
//   final scaffoldKey = GlobalKey<ScaffoldState>();
//   final _unfocusNode = FocusNode();
//
//   @override
//   void initState() {
//     super.initState();
//     // _model = createModel(context, () => ChatScreen1Model());
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
//           child: Container(
//             width: double.infinity,
//             height: double.infinity,
//             decoration: BoxDecoration(
//               color: Color(0xFF8000FF),
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.max,
//               children: [
//                 Column(
//                   mainAxisSize: MainAxisSize.max,
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     Padding(
//                       padding: EdgeInsetsDirectional.fromSTEB(15, 15, 15, 12),
//                       child: Row(
//                         mainAxisSize: MainAxisSize.max,
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Icon(
//                             Icons.arrow_back,
//                             color: Colors.white,
//                             size: 24,
//                           ),
//                           Text(
//                             'AI Healthcare \nAssistant',
//                             textAlign: TextAlign.center,
//                             style: FlutterFlowTheme.of(context)
//                                 .bodyMedium
//                                 .override(
//                               fontFamily: 'Poppins',
//                               color: Colors.white,
//                               fontSize: 18,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                           Icon(
//                             Icons.cleaning_services_outlined,
//                             color: Colors.white,
//                             size: 24,
//                           ),
//                         ],
//                       ),
//                     ),
//                     Align(
//                       alignment: AlignmentDirectional(0, 0),
//                       child: Container(
//                         width: double.infinity,
//                         height: 700,
//                         decoration: BoxDecoration(
//                           color:
//                           FlutterFlowTheme.of(context).secondaryBackground,
//                           borderRadius: BorderRadius.only(
//                             bottomLeft: Radius.circular(0),
//                             bottomRight: Radius.circular(0),
//                             topLeft: Radius.circular(40),
//                             topRight: Radius.circular(40),
//                           ),
//                         ),
//                         child: ListView(
//                           padding: EdgeInsets.zero,
//                           scrollDirection: Axis.vertical,
//                           children: [
//                             Text(
//                               'DocBot',
//                               textAlign: TextAlign.center,
//                               style: FlutterFlowTheme.of(context)
//                                   .bodyMedium
//                                   .override(
//                                 fontFamily: 'Poppins',
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                             Text(
//                               'March 28th, 2023',
//                               textAlign: TextAlign.center,
//                               style: FlutterFlowTheme.of(context)
//                                   .bodyMedium
//                                   .override(
//                                 fontFamily: 'Poppins',
//                                 fontSize: 10,
//                               ),
//                             ),
//                             Padding(
//                               padding:
//                               EdgeInsetsDirectional.fromSTEB(15, 15, 0, 15),
//                               child: Row(
//                                 mainAxisSize: MainAxisSize.max,
//                                 children: [
//                                   Container(
//                                     width: 50,
//                                     height: 50,
//                                     clipBehavior: Clip.antiAlias,
//                                     decoration: BoxDecoration(
//                                       shape: BoxShape.circle,
//                                     ),
//                                     child: Image.asset(
//                                       'assets/images/Rectangle_5.png',
//                                       fit: BoxFit.contain,
//                                     ),
//                                   ),
//                                   Padding(
//                                     padding: EdgeInsetsDirectional.fromSTEB(
//                                         10, 0, 0, 0),
//                                     child: Container(
//                                       width: 290,
//                                       height: 50,
//                                       decoration: BoxDecoration(
//                                         color: Color(0xFF8000FF),
//                                         borderRadius: BorderRadius.circular(10),
//                                       ),
//                                       child: Padding(
//                                         padding: EdgeInsetsDirectional.fromSTEB(
//                                             0, 0, 8, 0),
//                                         child: Column(
//                                           mainAxisSize: MainAxisSize.max,
//                                           mainAxisAlignment:
//                                           MainAxisAlignment.spaceEvenly,
//                                           crossAxisAlignment:
//                                           CrossAxisAlignment.end,
//                                           children: [
//                                             Align(
//                                               alignment:
//                                               AlignmentDirectional(0, 0),
//                                               child: Text(
//                                                 'Hello, my name is DocBot!',
//                                                 textAlign: TextAlign.center,
//                                                 style:
//                                                 FlutterFlowTheme.of(context)
//                                                     .bodyMedium
//                                                     .override(
//                                                   fontFamily: 'Poppins',
//                                                   color: Colors.white,
//                                                   fontSize: 12,
//                                                 ),
//                                               ),
//                                             ),
//                                             Text(
//                                               '11:36 AM',
//                                               textAlign: TextAlign.end,
//                                               style:
//                                               FlutterFlowTheme.of(context)
//                                                   .bodyMedium
//                                                   .override(
//                                                 fontFamily: 'Poppins',
//                                                 color: Colors.white,
//                                                 fontSize: 10,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             Padding(
//                               padding:
//                               EdgeInsetsDirectional.fromSTEB(15, 0, 0, 15),
//                               child: Row(
//                                 mainAxisSize: MainAxisSize.max,
//                                 children: [
//                                   Container(
//                                     width: 50,
//                                     height: 50,
//                                     clipBehavior: Clip.antiAlias,
//                                     decoration: BoxDecoration(
//                                       shape: BoxShape.circle,
//                                     ),
//                                     child: Image.asset(
//                                       'assets/images/Rectangle_5.png',
//                                       fit: BoxFit.contain,
//                                     ),
//                                   ),
//                                   Padding(
//                                     padding: EdgeInsetsDirectional.fromSTEB(
//                                         10, 0, 0, 0),
//                                     child: Container(
//                                       width: 290,
//                                       height: 50,
//                                       decoration: BoxDecoration(
//                                         color: Color(0xFF8000FF),
//                                         borderRadius: BorderRadius.circular(10),
//                                       ),
//                                       child: Padding(
//                                         padding: EdgeInsetsDirectional.fromSTEB(
//                                             12, 0, 12, 0),
//                                         child: Column(
//                                           mainAxisSize: MainAxisSize.max,
//                                           mainAxisAlignment:
//                                           MainAxisAlignment.spaceEvenly,
//                                           crossAxisAlignment:
//                                           CrossAxisAlignment.end,
//                                           children: [
//                                             Align(
//                                               alignment:
//                                               AlignmentDirectional(0, 0),
//                                               child: InkWell(
//                                                 onTap: () async {},
//                                                 child: Text(
//                                                   'What type of symptoms are you experiencing today?',
//                                                   textAlign: TextAlign.center,
//                                                   style: FlutterFlowTheme.of(
//                                                       context)
//                                                       .bodyMedium
//                                                       .override(
//                                                     fontFamily: 'Poppins',
//                                                     color: Colors.white,
//                                                     fontSize: 12,
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                             Text(
//                                               '11:36 AM',
//                                               textAlign: TextAlign.end,
//                                               style:
//                                               FlutterFlowTheme.of(context)
//                                                   .bodyMedium
//                                                   .override(
//                                                 fontFamily: 'Poppins',
//                                                 color: Colors.white,
//                                                 fontSize: 10,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             Padding(
//                               padding:
//                               EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
//                               child: Container(
//                                 width: 100,
//                                 height: 40,
//                                 decoration: BoxDecoration(
//                                   color: FlutterFlowTheme.of(context)
//                                       .secondaryBackground,
//                                   boxShadow: [
//                                     BoxShadow(
//                                       blurRadius: 4,
//                                       color: Color(0x33000000),
//                                       offset: Offset(0, 2),
//                                     )
//                                   ],
//                                   borderRadius: BorderRadius.circular(8),
//                                 ),
//                                 child: Padding(
//                                   padding: EdgeInsetsDirectional.fromSTEB(
//                                       8, 0, 8, 0),
//                                   child: Row(
//                                     mainAxisSize: MainAxisSize.max,
//                                     mainAxisAlignment:
//                                     MainAxisAlignment.spaceEvenly,
//                                     children: [
//                                       InkWell(
//                                         onTap: () async {},
//                                         child: Text(
//                                           'Physical',
//                                           style: FlutterFlowTheme.of(context)
//                                               .bodyMedium
//                                               .override(
//                                             fontFamily: 'Poppins',
//                                             fontWeight: FontWeight.w600,
//                                           ),
//                                         ),
//                                       ),
//                                       Container(
//                                         width: 100,
//                                         height: 30,
//                                         decoration: BoxDecoration(
//                                           color: Color(0xFF00C2FF),
//                                           boxShadow: [
//                                             BoxShadow(
//                                               blurRadius: 1,
//                                               color: Color(0x33000000),
//                                               offset: Offset(0, 2),
//                                               spreadRadius: 1,
//                                             )
//                                           ],
//                                           borderRadius:
//                                           BorderRadius.circular(5),
//                                         ),
//                                         alignment: AlignmentDirectional(0, 0),
//                                         child: Text(
//                                           'Mental',
//                                           textAlign: TextAlign.center,
//                                           style: FlutterFlowTheme.of(context)
//                                               .bodyMedium
//                                               .override(
//                                             fontFamily: 'Poppins',
//                                             color: Colors.white,
//                                           ),
//                                         ),
//                                       ),
//                                       Text(
//                                         'Both',
//                                         style: FlutterFlowTheme.of(context)
//                                             .bodyMedium
//                                             .override(
//                                           fontFamily: 'Poppins',
//                                           fontWeight: FontWeight.w600,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             Padding(
//                               padding:
//                               EdgeInsetsDirectional.fromSTEB(15, 15, 0, 15),
//                               child: Row(
//                                 mainAxisSize: MainAxisSize.max,
//                                 children: [
//                                   Container(
//                                     width: 50,
//                                     height: 50,
//                                     clipBehavior: Clip.antiAlias,
//                                     decoration: BoxDecoration(
//                                       shape: BoxShape.circle,
//                                     ),
//                                     child: Image.asset(
//                                       'assets/images/Rectangle_5.png',
//                                       fit: BoxFit.contain,
//                                     ),
//                                   ),
//                                   Padding(
//                                     padding: EdgeInsetsDirectional.fromSTEB(
//                                         10, 0, 0, 0),
//                                     child: Container(
//                                       width: 290,
//                                       height: 50,
//                                       decoration: BoxDecoration(
//                                         color: Color(0xFF8000FF),
//                                         borderRadius: BorderRadius.circular(10),
//                                       ),
//                                       child: Padding(
//                                         padding: EdgeInsetsDirectional.fromSTEB(
//                                             0, 0, 8, 0),
//                                         child: Column(
//                                           mainAxisSize: MainAxisSize.max,
//                                           mainAxisAlignment:
//                                           MainAxisAlignment.spaceEvenly,
//                                           crossAxisAlignment:
//                                           CrossAxisAlignment.end,
//                                           children: [
//                                             Align(
//                                               alignment:
//                                               AlignmentDirectional(0, 0),
//                                               child: InkWell(
//                                                 onTap: () async {},
//                                                 child: Text(
//                                                   'Are you male or female?',
//                                                   textAlign: TextAlign.center,
//                                                   style: FlutterFlowTheme.of(
//                                                       context)
//                                                       .bodyMedium
//                                                       .override(
//                                                     fontFamily: 'Poppins',
//                                                     color: Colors.white,
//                                                     fontSize: 12,
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                             Text(
//                                               '11:36 AM',
//                                               textAlign: TextAlign.end,
//                                               style:
//                                               FlutterFlowTheme.of(context)
//                                                   .bodyMedium
//                                                   .override(
//                                                 fontFamily: 'Poppins',
//                                                 color: Colors.white,
//                                                 fontSize: 10,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             Padding(
//                               padding:
//                               EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
//                               child: Container(
//                                 width: 80,
//                                 height: 40,
//                                 decoration: BoxDecoration(
//                                   color: FlutterFlowTheme.of(context)
//                                       .secondaryBackground,
//                                   boxShadow: [
//                                     BoxShadow(
//                                       blurRadius: 4,
//                                       color: Color(0x33000000),
//                                       offset: Offset(0, 2),
//                                     )
//                                   ],
//                                   borderRadius: BorderRadius.circular(8),
//                                 ),
//                                 child: Padding(
//                                   padding: EdgeInsetsDirectional.fromSTEB(
//                                       8, 0, 8, 0),
//                                   child: Row(
//                                     mainAxisSize: MainAxisSize.min,
//                                     mainAxisAlignment:
//                                     MainAxisAlignment.spaceEvenly,
//                                     children: [
//                                       InkWell(
//                                         onTap: () async {},
//                                         child: Text(
//                                           'Male',
//                                           style: FlutterFlowTheme.of(context)
//                                               .bodyMedium
//                                               .override(
//                                             fontFamily: 'Poppins',
//                                             fontWeight: FontWeight.w600,
//                                           ),
//                                         ),
//                                       ),
//                                       Container(
//                                         width: 100,
//                                         height: 30,
//                                         decoration: BoxDecoration(
//                                           color: Color(0xFF00C2FF),
//                                           boxShadow: [
//                                             BoxShadow(
//                                               blurRadius: 1,
//                                               color: Color(0x33000000),
//                                               offset: Offset(0, 2),
//                                               spreadRadius: 1,
//                                             )
//                                           ],
//                                           borderRadius:
//                                           BorderRadius.circular(5),
//                                         ),
//                                         alignment: AlignmentDirectional(0, 0),
//                                         child: Text(
//                                           'Female',
//                                           textAlign: TextAlign.center,
//                                           style: FlutterFlowTheme.of(context)
//                                               .bodyMedium
//                                               .override(
//                                             fontFamily: 'Poppins',
//                                             color: Colors.white,
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             Padding(
//                               padding:
//                               EdgeInsetsDirectional.fromSTEB(15, 15, 0, 15),
//                               child: Row(
//                                 mainAxisSize: MainAxisSize.max,
//                                 children: [
//                                   Container(
//                                     width: 50,
//                                     height: 50,
//                                     clipBehavior: Clip.antiAlias,
//                                     decoration: BoxDecoration(
//                                       shape: BoxShape.circle,
//                                     ),
//                                     child: Image.asset(
//                                       'assets/images/Rectangle_5.png',
//                                       fit: BoxFit.contain,
//                                     ),
//                                   ),
//                                   Padding(
//                                     padding: EdgeInsetsDirectional.fromSTEB(
//                                         10, 0, 0, 0),
//                                     child: Container(
//                                       width: 290,
//                                       height: 50,
//                                       decoration: BoxDecoration(
//                                         color: Color(0xFF8000FF),
//                                         borderRadius: BorderRadius.circular(10),
//                                       ),
//                                       child: Padding(
//                                         padding: EdgeInsetsDirectional.fromSTEB(
//                                             12, 0, 12, 0),
//                                         child: Column(
//                                           mainAxisSize: MainAxisSize.max,
//                                           mainAxisAlignment:
//                                           MainAxisAlignment.spaceEvenly,
//                                           crossAxisAlignment:
//                                           CrossAxisAlignment.end,
//                                           children: [
//                                             Align(
//                                               alignment:
//                                               AlignmentDirectional(0, 0),
//                                               child: InkWell(
//                                                 onTap: () async {},
//                                                 child: Text(
//                                                   'How old are you? Please type  or record your response below',
//                                                   textAlign: TextAlign.center,
//                                                   style: FlutterFlowTheme.of(
//                                                       context)
//                                                       .bodyMedium
//                                                       .override(
//                                                     fontFamily: 'Poppins',
//                                                     color: Colors.white,
//                                                     fontSize: 12,
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                             Text(
//                                               '11:36 AM',
//                                               textAlign: TextAlign.end,
//                                               style:
//                                               FlutterFlowTheme.of(context)
//                                                   .bodyMedium
//                                                   .override(
//                                                 fontFamily: 'Poppins',
//                                                 color: Colors.white,
//                                                 fontSize: 10,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 Container(
//                   width: double.infinity,
//                   height: 65,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                   ),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.max,
//                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     children: [
//                       Container(
//                         width: 300,
//                         height: 40,
//                         decoration: BoxDecoration(
//                           boxShadow: [
//                             BoxShadow(
//                               blurRadius: 4,
//                               color: Color(0x33000000),
//                               offset: Offset(0, 2),
//                             )
//                           ],
//                           gradient: LinearGradient(
//                             colors: [Color(0xFF00C2FF), Color(0xFF8000FF)],
//                             stops: [0, 1],
//                             begin: AlignmentDirectional(-1, 0),
//                             end: AlignmentDirectional(1, 0),
//                           ),
//                           borderRadius: BorderRadius.circular(30),
//                         ),
//                         child: Padding(
//                           padding: EdgeInsetsDirectional.fromSTEB(12, 0, 12, 0),
//                           child: Row(
//                             mainAxisSize: MainAxisSize.max,
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Icon(
//                                 Icons.mic,
//                                 color: Colors.white,
//                                 size: 20,
//                               ),
//                               Expanded(
//                                 child: Padding(
//                                   padding: EdgeInsetsDirectional.fromSTEB(
//                                       8, 0, 0, 0),
//                                   child: Text(
//                                     'Start typing...',
//                                     textAlign: TextAlign.start,
//                                     style: FlutterFlowTheme.of(context)
//                                         .bodyMedium
//                                         .override(
//                                       fontFamily: 'Poppins',
//                                       color: Colors.white,
//                                       fontSize: 10,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               Icon(
//                                 Icons.send,
//                                 color: Colors.white,
//                                 size: 20,
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       Icon(
//                         Icons.add_circle,
//                         color: Color(0xFF8000FF),
//                         size: 35,
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
