import 'package:connectycube_flutter_call_kit/connectycube_flutter_call_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:agora_uikit/agora_uikit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:health_connector/constants.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../../services/token_services.dart';

class AudioCallScreen extends StatefulWidget {
  final String? roomId;
  const AudioCallScreen({Key? key, this.roomId}) : super(key: key);

  @override
  State<AudioCallScreen> createState() => _AudioCallScreenState();
}

class _AudioCallScreenState extends State<AudioCallScreen> {
  late final AgoraClient client;
  late final String audioToken;
  late final String appId;

  Future<String> _getAppId() async {
    DocumentSnapshot queryDocumentSnapshot =
        await FirebaseFirestore.instance.collection("/agora").doc("app").get();
    return queryDocumentSnapshot.get("appID");
  }

  Future<Map<String, dynamic>> _getAudioToken() async {
    if (incomingCallEvent != null) {
      return {
        "rtcToken": incomingCallEvent!.userInfo!['sessionToken'],
        "channelName": incomingCallEvent!.userInfo!['channelName']
      };
    } else {
      return await Provider.of<AgoraTokenServices>(context, listen: false)
          .generateRTCToken(
              RtcCallType.audio, RtcRole.publisher, RtcTokenType.uid);
    }
  }

  Future<bool> clientInitializer() async {
    var resp = await _getAudioToken();

    await Provider.of<AgoraTokenServices>(context, listen: false).sendInvite(
        FirebaseAuth.instance.currentUser!.uid,
        widget.roomId!,
        RtcCallType.audio,
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
    var resp = await _getAudioToken();

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
      agoraEventHandlers: AgoraRtcEventHandlers(leaveChannel: (state) {
        incomingCallEvent = null;
        bloc.callServicesEventSink.add(null);
        Navigator.of(context).pop();
      })
    );

    FirebaseAuth.instance.currentUser?.photoURL;
    client.initialize();

    return true;
  }

// Build your layout
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: incomingCallEvent != null? incomingCallInitializer() : clientInitializer(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              body: SafeArea(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    const Icon(
                      Icons.call,
                      size: 50,
                      color: Colors.deepPurpleAccent,
                    ),
                    Positioned(
                      child: AgoraVideoButtons(
                        client: client,
                        enabledButtons: const [
                          BuiltInButtons.callEnd,
                          BuiltInButtons.toggleMic,
                        ],
                      ),
                      bottom: 0,
                      left: 150,
                    ),
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
