import 'dart:convert';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:agora_uikit/agora_uikit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:health_connector/constants.dart';
import 'package:http/http.dart' as http;

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

  Future<String> _getAppId() async {
    DocumentSnapshot queryDocumentSnapshot =
        await FirebaseFirestore.instance.collection("/agora").doc("app").get();
    return queryDocumentSnapshot.get("appid");
  }

  Future<String> _getVideoToken() async {
    DocumentSnapshot queryDocumentSnapshot =
        await FirebaseFirestore.instance.collection("/agora").doc("app").get();
    return queryDocumentSnapshot.get("video");
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
    client = AgoraClient(
      agoraConnectionData: AgoraConnectionData(
          rtmEnabled: false,
          appId: await _getAppId(),
          channelName: 'video',
          tempToken: await _getVideoToken(),
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
          await getToken();
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
