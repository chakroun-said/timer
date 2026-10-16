import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class SoundService {
  static final SoundService _instance = SoundService._internal();

  late final AudioPlayer _bellPlayer;
  late final AudioPlayer _beepPlayer;

  factory SoundService() {
    return _instance;
  }

  SoundService._internal() {
    _bellPlayer = AudioPlayer();
    _beepPlayer = AudioPlayer();
    // Set release mode to keep players ready
    _bellPlayer.setReleaseMode(ReleaseMode.stop);
    _beepPlayer.setReleaseMode(ReleaseMode.stop);
    // Set volume to maximum
    _bellPlayer.setVolume(1.0);
    _beepPlayer.setVolume(1.0);
  }

  // Play bell sound (start)
  Future<void> playBellSound() async {
    try {
      if (kDebugMode) {
        print('Playing bell sound...');
      }
      await _bellPlayer.stop();
      await _bellPlayer.play(AssetSource('sounds/bell.mp3'));
      if (kDebugMode) {
        print('Bell sound played successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error playing bell sound: $e');
      }
    }
  }

  // Play beep sound (countdown)
  Future<void> playBeepSound() async {
    try {
      if (kDebugMode) {
        print('Playing beep sound...');
      }
      await _beepPlayer.stop();
      await _beepPlayer.play(AssetSource('sounds/beep.mp3'));
      if (kDebugMode) {
        print('Beep sound played successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error playing beep sound: $e');
      }
    }
  }

  void dispose() {
    _bellPlayer.dispose();
    _beepPlayer.dispose();
  }
}
