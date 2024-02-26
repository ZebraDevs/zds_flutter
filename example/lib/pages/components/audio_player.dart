import 'package:flutter/material.dart';
import 'package:zds_flutter/zds_flutter.dart';

class AudioPlayerDemo extends StatefulWidget {
  const AudioPlayerDemo({super.key});

  @override
  State<AudioPlayerDemo> createState() => _AudioPlayerDemoState();
}

class _AudioPlayerDemoState extends State<AudioPlayerDemo> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ZdsAudioPlayer(
          assetPath: "assets/notification.wav",
        ),
      ),
    );
  }
}
