class ChatModel {
  String? recipientId;
  String? text;
  List<Buttons>? buttons;

  ChatModel({this.recipientId, this.text, this.buttons});

  ChatModel.fromJson(Map<String, dynamic> json) {
    recipientId = json['recipient_id'];
    text = json['text'];
    if (json['buttons'] != null) {
      buttons = <Buttons>[];
      json['buttons'].forEach((v) {
        buttons!.add(new Buttons.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['recipient_id'] = this.recipientId;
    data['text'] = this.text;
    if (this.buttons != null) {
      data['buttons'] = this.buttons!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Buttons {
  String? title;
  String? payload;

  Buttons({this.title, this.payload});

  Buttons.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    payload = json['payload'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['payload'] = this.payload;
    return data;
  }
}