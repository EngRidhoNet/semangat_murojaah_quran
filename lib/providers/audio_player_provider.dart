import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class AudioPlayerProvider with ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();
  String? _currentlyPlaying;
  bool _isPlaying = false;

  bool get isPlaying => _isPlaying;
  String? get currentlyPlaying => _currentlyPlaying;

  AudioPlayerProvider() {
    _audioPlayer.onPlayerComplete.listen((_) {
      _isPlaying = false;
      _currentlyPlaying = null;
      notifyListeners();
    });
  }

  Future<void> playAudio(String url) async {
    if (_currentlyPlaying == url && _isPlaying) {
      await _audioPlayer.pause();
      _isPlaying = false;
    } else if (_currentlyPlaying == url && !_isPlaying) {
      await _audioPlayer.resume();
      _isPlaying = true;
    } else {
      await _audioPlayer.stop();
      await _audioPlayer.play(UrlSource(url));
      _currentlyPlaying = url;
      _isPlaying = true;
    }
    notifyListeners();
  }

  Future<void> stopAudio() async {
    await _audioPlayer.stop();
    _isPlaying = false;
    _currentlyPlaying = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
