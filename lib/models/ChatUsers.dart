import 'chat_model.dart';

class ChatMessage{
  String? messageContent;
  bool messageType;
  bool button;
  List<Buttons>? buttonContent;
  ChatMessage({required this.messageContent, required this.messageType,this.button=false,this.buttonContent});
}