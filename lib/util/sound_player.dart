import 'package:flutter_beep/flutter_beep.dart' show FlutterBeep;

class SoundPlayer {
  const SoundPlayer._();

  static Future<void> beep(bool success) => FlutterBeep.beep(success);

  static Future<void> playSound(int soundId) =>
      FlutterBeep.playSysSound(soundId);
}
