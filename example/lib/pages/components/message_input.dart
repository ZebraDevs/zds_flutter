import 'package:flutter/material.dart';
import 'package:zds_flutter/zds_flutter.dart';

class MessageInputDemo extends StatelessWidget {
  const MessageInputDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return ZdsMessageInput(
      placeholder: 'Type a message...',
      allowVoiceNotes: true,
      voiceNoteFileName: 'temp',
      onUploadFiles: (_) {
        ScaffoldMessenger.of(context).showZdsToast(
          ZdsToast(
            title: Text('Files uploaded'),
            actions: [
              IconButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                },
                icon: const Icon(ZdsIcons.close),
              ),
            ],
            color: ZdsToastColors.success,
          ),
        );
      },
      allowAttachments: true,
    );
  }
}
