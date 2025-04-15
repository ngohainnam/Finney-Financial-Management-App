import 'package:flutter_tts/flutter_tts.dart';
import 'package:finney/helpers/voice_helper.dart';

class VoiceHelper {
  static final FlutterTts _tts = FlutterTts();

  static Future<void> speak(String text) async {
    await _tts.setLanguage("bn-BD");
    await _tts.setPitch(1.0);
    await _tts.setSpeechRate(0.45);
    await _tts.speak(text);
  }

  static Future<void> stop() async {
    await _tts.stop();
  }
}
