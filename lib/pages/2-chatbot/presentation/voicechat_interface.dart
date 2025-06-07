import 'package:finney/shared/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:finney/pages/2-chatbot/services/stt_service.dart';
import 'package:finney/pages/2-chatbot/services/tts_service.dart';
import 'package:finney/pages/2-chatbot/utils/robot_animation.dart'; 
import 'package:finney/shared/localization/locales.dart';
import 'package:flutter_localization/flutter_localization.dart';

class VoiceChatInterface extends StatefulWidget {
  final ChatUser currentUser;
  final Function(ChatMessage) onSend;
  final List<ChatMessage> messages;

  const VoiceChatInterface({
    super.key,
    required this.currentUser,
    required this.onSend,
    required this.messages,
  });

  @override
  State<VoiceChatInterface> createState() => _VoiceChatInterfaceState();
}

class _VoiceChatInterfaceState extends State<VoiceChatInterface> {
  final STTService _sttService = STTService();
  final TtsService _ttsService = TtsService();
  bool _isListening = false;
  String _lastWords = '';
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _initializeSpeechService();
  }

  Future<void> _initializeSpeechService() async {
    bool available = await _sttService.initialize();
    if (!available && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(LocaleData.voiceSttNotAvailable.getString(context)),),
      );
    }
  }

  void _updateWords(String words) {
    setState(() {
      _lastWords = words;
    });
  }

  Future<void> _toggleListening() async {
    if (_isProcessing) return;

    final isBengali = Localizations.localeOf(context).languageCode == 'bn';

    if (_isListening) {
      // Stop listening and process the query
      bool isNowListening = false;
      await _sttService.stopListening();
      setState(() {
        _isListening = isNowListening;
        _isProcessing = true;
      });

      if (_lastWords.isNotEmpty) {
        await _sendVoiceMessageToAI(_lastWords);
        await Future.delayed(const Duration(milliseconds: 1500));
      }

      setState(() {
        _isProcessing = false;
        _lastWords = '';
      });
    } else {
      // Start listening with language selection
      bool isNowListening = await _sttService.toggleListening(
        _updateWords,
        isBengali: isBengali,
      );
      setState(() {
        _isListening = isNowListening;
      });
    }
  }
  
  Future<void> _sendVoiceMessageToAI(String text) async {
    final message = ChatMessage(
      text: text,
      user: widget.currentUser,
      createdAt: DateTime.now(),
      customProperties: {
        'fromVoiceInput': true, 
      },
    );
    widget.onSend(message);
  }

  Future<void> _stopSpeech() async {
    await _ttsService.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.volume_off, color: Colors.redAccent),
            tooltip: "Stop Speech",
            onPressed: _stopSpeech,
          ),
        ],
      ),
      body: Stack(
        children: [
          RobotAnimationHeader(isTyping: _isProcessing),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_lastWords.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Card(
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          _lastWords,
                          style: const TextStyle(fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                Text(
                  _isListening
                      ? LocaleData.voiceListening.getString(context)
                      : _isProcessing
                          ? LocaleData.voiceProcessing.getString(context)
                          : LocaleData.voiceTapMic.getString(context),
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 50,
            child: Center(
              child: GestureDetector(
                onTap: _toggleListening,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: _isListening ? 55 : 65,
                  height: _isListening ? 55 : 65,
                  decoration: BoxDecoration(
                    color: _isProcessing 
                        ? Colors.orange 
                        : _isListening 
                            ? Colors.redAccent 
                            : AppColors.darkBlue,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        spreadRadius: 2,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Icon(
                    _isProcessing 
                        ? Icons.hourglass_top 
                        : _isListening 
                            ? Icons.stop 
                            : Icons.mic,
                    color: Colors.white,
                    size: 35,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  @override
  void dispose() {
    _sttService.dispose();
    _ttsService.stop();
    super.dispose();
  }
}