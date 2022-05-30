import 'package:flutter/material.dart';
import 'package:agora_uikit/agora_uikit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VideoCallScreen extends StatefulWidget {
  const VideoCallScreen({Key? key}) : super(key: key);

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  late final AgoraClient client;
  late final String videoToken;
  late final String appId;

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

  Future<bool> clientInitializer() async {
    client = AgoraClient(
      agoraConnectionData: AgoraConnectionData(
        rtmEnabled: false,
        appId: await _getAppId(),
        channelName: 'video',
        tempToken: await _getVideoToken(),
      ),
      enabledPermission: [
        Permission.camera,
        Permission.microphone,
      ],
    );

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
                    AgoraVideoViewer(client: client),
                       AgoraVideoButtons(
                        client: client,
                      ),
                  ],
                ),
              ),
            );
          } else {
            return const Center(child:  CircularProgressIndicator());
          }
        });
  }
}
