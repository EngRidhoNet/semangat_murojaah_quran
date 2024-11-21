import 'package:flutter/material.dart';
import 'package:my_quran/providers/audio_player_provider.dart';
import 'package:provider/provider.dart';

class AudioPlayerWidget extends StatelessWidget {
  final Map<String, String> audioSources;

  const AudioPlayerWidget({
    Key? key,
    required this.audioSources,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final audioProvider = context.watch<AudioPlayerProvider>();

    return PopupMenuButton<String>(
      icon: Icon(
        audioProvider.isPlaying &&
                audioProvider.currentlyPlaying != null &&
                audioSources.containsValue(audioProvider.currentlyPlaying)
            ? Icons.pause_circle_filled
            : Icons.play_circle_outline,
        color: Theme.of(context).primaryColor,
      ),
      onSelected: (String url) {
        audioProvider.playAudio(url);
      },
      itemBuilder: (BuildContext context) {
        return audioSources.entries.map((entry) {
          return PopupMenuItem<String>(
            value: entry.value,
            child: Text('Qori ${entry.key}'),
          );
        }).toList();
      },
    );
  }
}
