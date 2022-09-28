import 'dart:convert';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:agora_uikit/agora_uikit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:health_connector/constants.dart';
import 'package:health_connector/main.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../log/logger.dart';
import '../../services/call_services.dart';
import '../../services/token_services.dart';

class VideoCallScreen extends StatefulWidget {
  final String? roomId;
  const VideoCallScreen({Key? key, this.roomId}) : super(key: key);

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  late final AgoraClient client;
  late final String videoToken;
  late final String appId;

  @override
  void dispose() {
    super.dispose();
    client.engine.destroy();
    bloc.setCallState(CallServicesCallState.idle);
  }

  Future<String> _getAppId() async {
    DocumentSnapshot queryDocumentSnapshot =
        await FirebaseFirestore.instance.collection("/agora").doc("app").get();
    return queryDocumentSnapshot.get("appID");
  }

  Future<Map<String, dynamic>> _getVideoToken() async {
    if (incomingCallEvent != null) {
      return {
        "rtcToken": incomingCallEvent!.userInfo!['sessionToken'],
        "channelName": incomingCallEvent!.userInfo!['channelName']
      };
    } else {
      return await Provider.of<AgoraTokenServices>(context, listen: false)
          .generateRTCToken(
              RtcCallType.video, RtcRole.publisher, RtcTokenType.uid);
    }
  }

  Future<String?> getToken() async {
    final response = await http.get(
      Uri.parse(Constants.getPublisherVideoURLWithUid(uid: 1)),
    );

    if (response.statusCode == 200) {
      var json = response.body;
      return jsonDecode(json)['rtcToken'];
    } else {
      return null;
    }
  }

  Future<bool> clientInitializer() async {
    var resp = await _getVideoToken();

    await Provider.of<AgoraTokenServices>(context, listen: false).sendInvite(
        FirebaseAuth.instance.currentUser!.uid,
        widget.roomId!,
        RtcCallType.video,
        resp['channelName'],
        Uri.encodeComponent(Uri.encodeComponent(resp['rtcToken'])));

    client = AgoraClient(
      agoraConnectionData: AgoraConnectionData(
        rtmEnabled: false,
        appId: await _getAppId(),
        channelName: resp['channelName'],
        tempToken: resp['rtcToken'],
      ),
      enabledPermission: [
        Permission.camera,
        Permission.microphone,
      ],
    );

    FirebaseAuth.instance.currentUser?.photoURL;
    client.initialize();

    return true;
  }

  Future<bool> incomingCallInitializer() async {
    var resp = await _getVideoToken();

    client = AgoraClient(
      agoraConnectionData: AgoraConnectionData(
        rtmEnabled: false,
        appId: await _getAppId(),
        channelName: resp['channelName'],
        tempToken: resp['rtcToken'],
      ),
      enabledPermission: [
        Permission.camera,
        Permission.microphone,
      ],
      agoraEventHandlers: AgoraRtcEventHandlers(
        leaveChannel: (state) {
          incomingCallEvent = null;
          bloc.callServicesEventSink.add(null);
          Navigator.of(context).pop();
        },
        joinChannelSuccess: (channel, uid, elapsed) {
          Logger.info('joinChannel Success');
        },
        userJoined: (uid, elapsed) {
          Logger.info("user joined");
        },
        userOffline: (uid, reason) {
          Logger.info("user offline");
          client.engine.leaveChannel();
          Navigator.of(context).pop();
        },
      ),
    );

    FirebaseAuth.instance.currentUser?.photoURL;
    client.initialize();

    return true;
  }

// Build your layout
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: clientInitializer(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              body: SafeArea(
                child: Stack(
                  children: [
                    AgoraVideoViewer(
                      client: client,
                      layoutType: Layout.floating,
                    ),
                    AgoraVideoButtons(client: client),
                  ],
                ),
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}
