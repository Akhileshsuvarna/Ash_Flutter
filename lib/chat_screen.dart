import 'dart:convert';
import 'dart:math';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';
import 'main.dart';
import 'models/ChatUsers.dart';
import 'models/DataState.dart';
import 'models/chat_buttons.dart';
import 'models/chat_model.dart';
import 'services/http_provider.dart';

class ConversationPage extends StatefulWidget {
  const ConversationPage({Key? key}) : super(key: key);

  @override
  _ConversationPageState createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  int count = 1, buttonContentLength = 0;
  List<bool> isTapped = [false];
  int? buttonVal = 0;
  stt.SpeechToText? _speech;
  bool _isListening = false;
  List<ChatButtons> InkWellItem = [];
  final TextEditingController? textEditingController = TextEditingController();
  double _confidence = 1.0;
  DataState<ChatModel> messagemodel = DataState<ChatModel>.idle();
  bool isReceived = true;
  List<ChatMessage> messages = [
    ChatMessage(messageContent: "Hello, My name is DocBot", messageType: false),
  ];
  String userName = String.fromCharCodes(
      List.generate(5, (index) => Random().nextInt(33) + 89));

  @override
  void initState() {
    super.initState();
    HttpProvider.postMessage(
            sender: userName, message: 'Hello, My name is DocBot')
        .then((value) {
      // final Map<String, dynamic> responseData = json.decode(value.body);
      messagemodel = DataState.data(
        data: ChatModel.fromJson(json.decode(value.body)[0]),
      );

      setState(() {
        messages.add(ChatMessage(
          messageContent: messagemodel.data?.text,
          messageType: false,
          buttonContent: messagemodel.data?.buttons,
        ));
        if (value.body.toString().contains('buttons')) {
          buttonVal = messagemodel.data?.buttons?.length;
          for (int n = 0; n < buttonVal!; n++) {
            isTapped.add(false);
            buttonContentLength = messages[n].buttonContent?.length ?? 0;
            for (int m = 0; m < buttonContentLength; m++) {
              InkWellItem.add(
                ChatButtons(buttons:messages[n].buttonContent!),
              );
            }
          }
          messages.add(ChatMessage(
              messageContent: messagemodel.data?.text,
              messageType: true,
              button: true,
              buttonContent: messagemodel.data?.buttons));
        }
      });
    });
    _speech = stt.SpeechToText();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              stops: [0.1, 0.5, 0.7, 0.9],
              colors: [
                Color(0xFF8000FF),
                Color(0xFF8000FF),
                Colors.white,
                Colors.white,
              ],
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(15, 15, 15, 12),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      color: Colors.white,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const Text(
                      'AI Healthcare \nAssistant',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    IconButton(
                      color: Colors.white,
                      onPressed: () {
                        setState(() {
                          messages.clear();
                          messages.add(
                            ChatMessage(
                                messageContent: "Hello, My name is DocBot",
                                messageType: false),
                          );
                          userName = String.fromCharCodes(List.generate(
                              5, (index) => Random().nextInt(33) + 89));
                          HttpProvider.postMessage(
                                  sender: userName,
                                  message: 'Hello, My name is DocBot')
                              .then((value) {
                            print('Resp${value.body}');
                            // final Map<String, dynamic> responseData = json.decode(value.body);
                            messagemodel = DataState.data(
                              data: ChatModel.fromJson(
                                  json.decode(value.body)[0]),
                            );
                            setState(() {
                              messages.add(ChatMessage(
                                messageContent: messagemodel.data?.text,
                                messageType: true,
                                buttonContent: messagemodel.data?.buttons,
                              ));
                              buttonVal = messagemodel.data?.buttons?.length;
                              for (int n = 0; n < buttonVal!; n++) {
                                isTapped.add(false);
                              }
                              messages.add(ChatMessage(
                                  messageContent: messagemodel.data?.text,
                                  messageType: true,
                                  button: true));
                            });
                          });
                        });
                      },
                      icon: const Icon(Icons.cleaning_services_outlined,
                          size: 24),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                height: 50,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(0),
                    bottomRight: Radius.circular(0),
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: const Center(
                  child: Text(
                    'DocBot',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: ListView.builder(
                      physics: const ScrollPhysics(),
                      itemCount: messages.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                            padding: const EdgeInsets.only(
                                left: 14, right: 14, top: 10, bottom: 10),
                            child: messages[index].button
                                ? Column(
                                  children: [
                                    for (int i = 0;
                                        i < InkWellItem.last.buttons!.length;
                                        i++)
                                      Container(
                                        margin: const EdgeInsets.only(bottom: 10),
                                          height: 30,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                              color: Colors.blue,
                                              width: 2,
                                            ), //Border.all
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            boxShadow: const [
                                              BoxShadow(
                                                blurRadius: 4,
                                                color: Color(0x33000000),
                                                offset: Offset(0, 2),
                                              )
                                            ],
                                          ),
                                          child: InkWell(
                                            onTap: () async {
                                              setState(() {
                                                print('Clocked');
                                              });
                                              HttpProvider.postMessage(
                                                sender: userName,
                                                message:
                                                    InkWellItem[i].buttons![i].title! ??
                                                        '',
                                              ).then((value) {
                                                messagemodel =
                                                    DataState.data(
                                                  data: ChatModel.fromJson(
                                                      json.decode(
                                                          value.body)[0]),
                                                );
                                                setState(() {
                                                  messages.add(ChatMessage(
                                                      messageContent:
                                                          messagemodel
                                                              .data?.text,
                                                      messageType: false));
                                                });
                                              });
                                            },
                                            child: Container(
                                              height: 30,
                                              alignment:
                                                  const AlignmentDirectional(
                                                      0, 0),
                                              decoration: isTapped[i]
                                                  ? BoxDecoration(
                                                      color: const Color(
                                                          0xFF00C2FF),
                                                      boxShadow: const [
                                                        BoxShadow(
                                                          blurRadius: 1,
                                                          color: Color(
                                                              0x33000000),
                                                          offset:
                                                              Offset(0, 2),
                                                          spreadRadius: 1,
                                                        )
                                                      ],
                                                      borderRadius:
                                                          BorderRadius
                                                              .circular(5),
                                                    )
                                                  : const BoxDecoration(),
                                              child: Text(
                                                InkWellItem.last.buttons![i].title!.toUpperCase() ?? '',
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontFamily: 'Poppins',
                                                  color: Colors.purple,
                                                  fontWeight:
                                                      FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          )),
                                  ],
                                )
                                : Align(
                                    alignment: (messages[index].messageType
                                        ? Alignment.topLeft
                                        : Alignment.topRight),
                                    child: Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            messages[index].messageType
                                                ? MainAxisAlignment.end
                                                : MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          messages[index].messageType
                                              ? const SizedBox()
                                              : Container(
                                                  width: 50,
                                                  height: 50,
                                                  clipBehavior:
                                                      Clip.antiAlias,
                                                  decoration:
                                                      const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Image.asset(
                                                    'assets/images/chatbot.png',
                                                    fit: BoxFit.contain,
                                                  ),
                                                ),
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(10, 0, 10, 0),
                                              child: Container(
                                                height: 50,
                                                decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xFF8000FF),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                              .fromSTEB(
                                                          0, 0, 8, 0),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .end,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal:
                                                                    8.0),
                                                        child: Align(
                                                          alignment:
                                                              const AlignmentDirectional(
                                                                  0, 0),
                                                          child: Text(
                                                            messages[index]
                                                                .messageContent
                                                                .toString(),
                                                            textAlign:
                                                                TextAlign
                                                                    .start,
                                                            style:
                                                                const TextStyle(
                                                              fontFamily:
                                                                  'Poppins',
                                                                  fontSize: 16,
                                                              color: Colors
                                                                  .white,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      // const Text(
                                                      //   '11:36 AM',
                                                      //   textAlign:
                                                      //       TextAlign.end,
                                                      //   style: TextStyle(
                                                      //     fontFamily:
                                                      //         'Poppins',
                                                      //     color: Colors.white,
                                                      //     fontSize: 10,
                                                      //   ),
                                                      // ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          messages[index].messageType
                                              ? Container(
                                                  width: 50,
                                                  height: 50,
                                                  clipBehavior:
                                                      Clip.antiAlias,
                                                  decoration:
                                                      const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Image.asset(
                                                    'assets/images/chatbot.png',
                                                    fit: BoxFit.contain,
                                                  ))
                                              : const SizedBox(),
                                        ],
                                      ),
                                    )));
                      }),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 50),
                width: double.infinity,
                height: 65,
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      width: 300,
                      height: 40,
                      decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 4,
                            color: Color(0x33000000),
                            offset: Offset(0, 2),
                          )
                        ],
                        gradient: const LinearGradient(
                          colors: [Color(0xFF00C2FF), Color(0xFF8000FF)],
                          stops: [0, 1],
                          begin: AlignmentDirectional(-1, 0),
                          end: AlignmentDirectional(1, 0),
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(12, 0, 12, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: AvatarGlow(
                                animate: _isListening,
                                glowColor: Theme.of(context).primaryColor,
                                endRadius: 16.0,
                                showTwoGlows: false,
                                duration: const Duration(milliseconds: 2000),
                                repeatPauseDuration:
                                    const Duration(milliseconds: 100),
                                repeat: true,
                                child: FloatingActionButton(
                                  onPressed: _listen,
                                  child: Icon(
                                    _isListening ? Icons.mic : Icons.mic_none,
                                    size: 14,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      8, 0, 0, 0),
                                  child: TextField(
                                    controller: textEditingController,
                                    style: const TextStyle(color: Colors.white),
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintStyle: TextStyle(color: Colors.white,
                                        fontFamily:
                                        'Poppins',),
                                      hintText: 'Start typing...',
                                    ),
                                  )),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.send,
                                color: Colors.white,
                                size: 20,
                              ),
                              onPressed: () {
                                setState(() {
                                  messages.add(ChatMessage(
                                      messageContent:
                                          textEditingController?.text ?? '',
                                      messageType: true));

                                  HttpProvider.postMessage(
                                          sender: userName,
                                          message:
                                              textEditingController?.text ?? '')
                                      .then((value) {
                                    print('Resp${value.body}');
                                    // final Map<String, dynamic> responseData = json.decode(value.body);
                                    messagemodel = DataState.data(
                                      data: ChatModel.fromJson(
                                          json.decode(value.body)[0]),
                                    );
                                    setState(() {
                                      if (value.body
                                          .toString()
                                          .contains('buttons')) {
                                        messages.add(ChatMessage(
                                          messageContent:
                                              messagemodel.data?.text,
                                          messageType: false,
                                          button: true,
                                          buttonContent:
                                              messagemodel.data?.buttons,
                                        ));
                                        buttonVal = 0;
                                        buttonVal =
                                            messagemodel.data?.buttons?.length;
                                        // InkWellItem.clear();
                                        int lastVal = (messages.length) - 1;
                                        for (int n = 0; n < buttonVal!; n++) {
                                          isTapped.add(false);
                                          InkWellItem.add(
                                            ChatButtons(
                                              buttons: messages[lastVal].buttonContent,),
                                          );
                                        }
                                      } else {
                                        messages.add(ChatMessage(
                                          messageContent:
                                              messagemodel.data?.text,
                                          messageType: false,
                                          buttonContent:
                                              messagemodel.data?.buttons,
                                        ));
                                      }
                                    });
                                  });

                                  textEditingController?.clear();
                                  count++;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          filePicker(context);
                        });
                      },
                      icon: const Icon(
                        Icons.add_circle,
                        color: Color(0xFF8000FF),
                        size: 35,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _postNotification() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'default_notification_channel_id',
      'Default',
      importance: Importance.max,
      priority: Priority.max,
    );
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
        0, 'Image successfully loaded', '', notificationDetails);
  }

  filePicker(BuildContext context) async {
    final result = await Permission.storage.request();

    if (result == PermissionStatus.granted) {
      final FilePickerResult? result =
          await FilePicker.platform.pickFiles(type: FileType.image);

      final path = result?.files.single.path;

      if (path != null) {
        _postNotification();
        setState(() {
          print('Success${path}');
          // _filepath = path;
        });
      }
    }
  }

  void _listen() async {
    if (!_isListening) {
      bool? available = await _speech?.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available!) {
        setState(() => _isListening = true);
        _speech?.listen(
          onResult: (val) => setState(() {
            textEditingController?.text = val.recognizedWords;
            if (val.hasConfidenceRating && val.confidence > 0) {
              _confidence = val.confidence;
            }
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech?.stop();
    }
  }
}
