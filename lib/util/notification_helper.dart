import 'package:connectycube_flutter_call_kit/connectycube_flutter_call_kit.dart';
import 'package:health_connector/models/call_invite.dart';

import '../main.dart';

class NotificationHelper {
  NotificationHelper._();

  static bool isCallInvite(Map<String, dynamic> data) {
    if (data['callInvite'] != null &&
        data['callInvite'].toString().toLowerCase() == 'true') {
      return true;
    }
    return false;
  }

  static CallerData parseNotificationDataToCallerData(
          Map<String, dynamic> data) =>
      CallerData(
        data['hostName'],
        data['hostImage'],
        data['hostToken'],
        data['hostEmail'],
        data['hostUUID'],
        data['inviteType'],
        data['sessionToken'],
        data['roomId'],
        data['channelName'],
      );

  static void showCallNotification(CallerData callerData) {
    currentCallSessionId = DateTime.now().microsecondsSinceEpoch.toString();
    CallEvent callEvent = CallEvent(
        sessionId: currentCallSessionId, //callerData.sessionToken,
        callType: callerData.inviteType.toLowerCase() == "audio".toLowerCase()
            ? 0
            : 1,
        callerId: 0,
        callerName: callerData.hostName,
        opponentsIds: const {1, 2, 3, 4},
        userInfo: callerData.toJson());

    ConnectycubeFlutterCallKit.showCallNotification(callEvent);
  }
}
