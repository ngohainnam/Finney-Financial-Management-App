import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  final flutterTts = FlutterTts();

  Future<void> setLanguage(bool isBengali) async {
    await flutterTts.setLanguage(isBengali ? "bn-BD" : "en-US");
  }

  Future<void> speak(String content) async {
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.speak(content);
  }

  Future<void> stop() async {
    await flutterTts.stop();
  }
}