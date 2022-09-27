import 'dart:convert';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:agora_uikit/agora_uikit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:health_connector/constants.dart';
import 'package:health_connector/main.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../services/token_services.dart';

class VideoCallScreen extends StatefulWidget {
  const VideoCallScreen({Key? key}) : super(key: key);

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
  }

  String _getAppId() => Constants.agoraAppID;

  Future<Map<String, dynamic>> _getVideoToken() async {
    if (incomingCallEvent != null) {
      return {}; //incomingCallEvent!.sessionId;
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
    client = AgoraClient(
      agoraConnectionData: AgoraConnectionData(
          rtmEnabled: false,
          appId: _getAppId(),
          channelName: resp['channelName'],
          tempToken: resp['rtcToken'],
          uid: 0),
      enabledPermission: [
        Permission.camera,
        Permission.microphone,
      ],
    );

    await client.initialize();

    client.engine.setEventHandler(
      RtcEngineEventHandler(
        tokenPrivilegeWillExpire: (token) async {
          // await getToken();
          await client.engine.renewToken(token);
        },
        userJoined: (uid, elapsed) {
          print(' User joined: $uid || $elapsed');
        },
      ),
    );

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
