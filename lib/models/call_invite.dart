class CallerData {
  final String hostName;
  final String hostImage;
  final String hostToken;
  final String hostEmail;
  final String hostUUID;
  final String inviteType;
  final String sessionToken;
  final String roomId;
  final String channelName;
  CallerData(this.hostName, this.hostImage, this.hostToken, this.hostEmail,
      this.hostUUID, this.inviteType, this.sessionToken, this.roomId, this.channelName);

  toJson() => {
        "hostName": hostName,
        "hostImage": hostImage,
        "hostToken": hostToken,
        "hostEmail": hostEmail,
        "hostUUID": hostUUID,
        "inviteType": inviteType,
        "sessionToken": sessionToken,
        "roomId": roomId,
        "channelName": channelName
      };
}
