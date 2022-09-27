import 'dart:async';
import 'dart:convert';

import 'package:health_connector/log/logger.dart';
import 'package:health_connector/services/web_services.dart';

import '../constants.dart';

enum RtcCallType { audio, video }

enum RtcRole { audience, publisher }

enum RtcTokenType { uid, userAccount }

abstract class IAgoraTokenServices {
  FutureOr<Map<String, dynamic>> generateRTCToken(
      RtcCallType callType, RtcRole role, RtcTokenType tokenType);
  Future<Map<String, dynamic>> generateRTEToken();
  Future<Map<String, dynamic>> generateRTMToken();
  Future<bool> pingServer();
  FutureOr<bool> sendInvite(String uid, String roomId, RtcCallType inviteType,
      String channelName, String agoraSessionToken);
}

class AgoraTokenServices extends IAgoraTokenServices {
  final String _baseUrl = Constants.tokenServerBaseUrl;
  late WebServices webServices;

  AgoraTokenServices() {
    webServices = WebServices(_baseUrl);
  }

  @override
  FutureOr<Map<String, dynamic>> generateRTCToken(
      RtcCallType callType, RtcRole role, RtcTokenType tokenType) async {
    // TODO(SKANDAR): check tokenType, right now we are using only uuid
    try {
      Map<String, String> res = {};
      var _cName = DateTime.now().millisecondsSinceEpoch.toString();
      var _path = Constants.agoraGetAudioChannelPath(channelName: _cName);
      var response = await webServices.get(_path);
      res.addAll({'rtcToken': json.decode(response.body)['rtcToken']});
      res.addAll({'channelName': _cName});
      return res;
    } catch (e, stackTrace) {
      Logger.error(e, stackTrace: stackTrace);
      return Future.error(e);
    }
  }

  @override
  Future<Map<String, dynamic>> generateRTEToken() {
    // TODO: implement generateRTEToken
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> generateRTMToken() {
    // TODO: implement generateRTMToken
    throw UnimplementedError();
  }

  @override
  Future<bool> pingServer() async {
    var response = await webServices.get('/ping');
    return json.decode(response.body)['message'] == 'pong';
  }

  @override
  Future<bool> sendInvite(String uid, String roomId, RtcCallType inviteType,
      String channelName, String agoraSessionToken) async {
    try {
      var _path = Constants.getAgoraInviteUrl(
          senderUid: uid,
          roomID: roomId,
          inviteType: inviteType,
          channelName: channelName,
          agoraSessionToken: agoraSessionToken);
      var response = await webServices.get(_path);
      if (response.statusCode == 404) {
        return false;
      }
      var responseBody = json.decode(response.body);
      return true;
    } catch (e, stackTrace) {
      Logger.error(e, stackTrace: stackTrace);
      return Future.error(e);
    }
  }
}
