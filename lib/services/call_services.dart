import 'dart:async';

import 'package:connectycube_flutter_call_kit/connectycube_flutter_call_kit.dart';

enum CallServicesCallState {
  idle,
  incomingAudioCall,
  incomingVideoCall,
  ongoingAudioCall,
  ongoingVideoCall,
  outgoingAudioCall,
  outgoingVideoCall
}

class CallServices {
  CallServicesCallState _callState = CallServicesCallState.idle;

  final _callServicesStateController =
      StreamController<CallServicesCallState>.broadcast();

  StreamSink<CallServicesCallState> get _emitState {
    print('emitstate was called');
    return _callServicesStateController.sink;
  }

  // Public Field
  Stream<CallServicesCallState> get streamState =>
      _callServicesStateController.stream;

  final _callServicesEventController = StreamController<CallEvent>();

  // Public Field
  Sink<CallEvent?> get callServicesEventSink =>
      _callServicesEventController.sink;

  set callServicesEventSinkAdd(CallEvent event) =>
      _callServicesEventController.add(event);

  CallServices() {
    _callServicesEventController.stream.listen(_mapEventToState);
  }

  _mapEventToState(CallEvent? event) {
    if (event == null) {
      _callState = CallServicesCallState.idle;
    } else if (event.userInfo!['inviteType'] == 'video') {
      _callState = CallServicesCallState.incomingVideoCall;
    } else if (event.userInfo!['inviteType'] == 'audio') {
      _callState = CallServicesCallState.incomingAudioCall;
    }

    //TODO implement other call states

    _emitState.add(_callState);

    print('current call state is $_callState');
  }

  void dispose() {
    _callServicesStateController.close();
    _callServicesEventController.close();
  }
}
