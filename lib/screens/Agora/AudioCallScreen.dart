import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:agora_uikit/agora_uikit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AudioCallScreen extends StatefulWidget {
  const AudioCallScreen({Key? key}) : super(key: key);

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
    return queryDocumentSnapshot.get("appid");
  }

  Future<String> _getAudioToken() async {
    DocumentSnapshot queryDocumentSnapshot =
        await FirebaseFirestore.instance.collection("/agora").doc("app").get();
    return queryDocumentSnapshot.get("audio");
  }

  Future<bool> clientInitializer() async {
    client = AgoraClient(
      agoraConnectionData: AgoraConnectionData(
        rtmEnabled: false,
        appId: await _getAppId(),
        channelName: 'audio',
        tempToken: await _getAudioToken(),
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
                  fit: StackFit.expand,
                  children: [
                    Icon(
                      Icons.call,
                      size: 50,
                      color: Colors.deepPurpleAccent,
                    ),
                    Positioned(
                      child: AgoraVideoButtons(
                        client: client,
                        enabledButtons: const [
                          BuiltInButtons.callEnd,
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
