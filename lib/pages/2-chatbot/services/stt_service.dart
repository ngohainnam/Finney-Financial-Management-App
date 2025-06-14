import 'package:speech_to_text/speech_to_text.dart';

class STTService {
  final SpeechToText _speechToText = SpeechToText();
  bool _isInitialized = false;
  String _lastWords = '';
  bool _isListening = false;

  // Getters
  bool get isInitialized => _isInitialized;
  bool get isListening => _isListening;
  String get lastWords => _lastWords;

  // Initialize the speech recognition service
  Future<bool> initialize() async {
    if (_isInitialized) return true;
    try {
      _isInitialized = await _speechToText.initialize();
      return _isInitialized;
    } catch (e) {
      _isInitialized = false;
      return false;
    }
  }

  // Start listening for speech input with language selection
  Future<void> startListening(Function(String) onWordsChanged, {required bool isBengali}) async {
    if (!_isInitialized) {
      await initialize();
    }

    if (_isInitialized) {
      final locales = await _speechToText.locales();
      final localeId = isBengali
          ? locales.firstWhere((l) => l.localeId.startsWith('bn'), orElse: () => locales.first).localeId
          : locales.firstWhere((l) => l.localeId.startsWith('en'), orElse: () => locales.first).localeId;

      await _speechToText.listen(
        onResult: (result) {
          _lastWords = result.recognizedWords;
          onWordsChanged(_lastWords);
        },
        localeId: localeId,
      );
      _isListening = true;
    }
  }

  // Stop listening for speech input
  Future<void> stopListening() async {
    await _speechToText.stop();
    _isListening = false;
  }

  // Toggle listening state with language selection
  Future<bool> toggleListening(Function(String) onWordsChanged, {required bool isBengali}) async {
    if (_isListening) {
      await stopListening();
      return false;
    } else {
      await startListening(onWordsChanged, isBengali: isBengali);
      return true;
    }
  }

  // Clean up resources
  void dispose() {
    _speechToText.stop();
  }
}