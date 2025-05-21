import 'package:flutter/material.dart';

class SettingsNotifier {
  static final SettingsNotifier _instance = SettingsNotifier._internal();
  factory SettingsNotifier() => _instance;
  SettingsNotifier._internal();

  final ValueNotifier<String> textSizeNotifier = ValueNotifier<String>('Medium');

  void updateTextSize(String textSize) {
    textSizeNotifier.value = textSize;
  }
}