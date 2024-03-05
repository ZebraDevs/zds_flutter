import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:zds_flutter/zds_flutter.dart';

class AudioRecorderDemo extends StatefulWidget {
  const AudioRecorderDemo({super.key});

  @override
  State<AudioRecorderDemo> createState() => _AudioRecorderDemoState();
}

class _AudioRecorderDemoState extends State<AudioRecorderDemo> {
  Directory? directory;

  @override
  void initState() {
    if (!kIsWeb) {
      getDownloadsDirectory().then(
        (value) => setState(
          (() {
            directory = value;
          }),
        ),
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return const Center(child: Text('Audio recorder not supported on web'));
    }
    if (directory == null) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ZdsVoiceNoteRecorder(
            fileName: 'test',
            rootDirectory: directory?.path ?? '',
            maxDuration: const Duration(seconds: 5),
            onSubmit: (_) => print(_),
          ),
        ),
      );
    }
  }
}
