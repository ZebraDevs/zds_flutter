import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'package:zds_flutter/zds_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

const lorem =
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Quis vel eros donec ac odio tempor orci dapibus. Ullamcorper a lacus vestibulum sed. Purus semper eget duis at tellus at urna condimentum. Duis at consectetur lorem donec massa sapien. Lacus vestibulum sed arcu non odio. Morbi tincidunt ornare massa eget. Massa tempor nec feugiat nisl pretium fusce. Ipsum faucibus vitae aliquet nec ullamcorper. Viverra nibh cras pulvinar mattis nunc sed blandit libero. Elit ut aliquam purus sit amet luctus venenatis lectus.\n';

const testAudioPath = 'notification.wav';
const testVideoPath = 'video.mp4';
const testImgPath = 'sleeping_zebra.png';

class _ChatExampleObj {
  final ZdsMessage message;
  final bool isLocalUser;
  final bool shouldShake;
  final bool highlight;
  final bool showFilePreview;

  _ChatExampleObj({
    required this.message,
    this.isLocalUser = true,
    this.shouldShake = false,
    this.highlight = false,
    this.showFilePreview = true,
  });
}

class ChatDemo extends StatefulWidget {
  const ChatDemo({super.key});

  @override
  State<ChatDemo> createState() => _ChatDemoState();
}

class _ChatDemoState extends State<ChatDemo> {
  void showToast(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showZdsToast(
      ZdsToast(
        multiLine: true,
        title: Text('$text callback'),
        leading: const Icon(ZdsIcons.check_circle),
        actions: [
          IconButton(
            onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
            icon: const Icon(ZdsIcons.close),
          ),
        ],
      ),
    );
  }

  Future<void> copyAssetToDevice(String fileName) async {
    final path = await rootBundle.load('assets/' + fileName);

    if (tmpDir == null) {
      final _dir = (await getTemporaryDirectory()).path;
      setState(() {
        tmpDir = _dir;
      });
    }

    final file = File('${tmpDir}/${fileName}');
    await file.create(recursive: true);
    final x = await file.writeAsBytes(path.buffer.asUint8List(path.offsetInBytes, path.lengthInBytes));

    print(x);
  }

  bool loading = true;
  String? img;
  List? children;
  Map childWidgets = {};
  String? tmpDir;
  final ItemScrollController controller = ItemScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      try {
        final _img = await rootBundle.loadString('assets/b64image.txt');
        setState(() => img = _img);
      } catch (e) {
        print(e);
      }
      try {
        await Future.wait([
          copyAssetToDevice(testAudioPath),
          copyAssetToDevice(testVideoPath),
          copyAssetToDevice(testImgPath),
        ]);
      } catch (e) {
        print(e);
      }
      setState(() => loading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return Center(child: CircularProgressIndicator());
    children ??= [
      _ChatExampleObj(
        isLocalUser: false,
        shouldShake: true,
        highlight: true,
        message: ZdsMessage(
          status: ZdsChatMessageStatus.delivered,
          content: 'Hello There https://bbc.co.uk',
          senderColor: Colors.blueAccent.shade200,
          senderName: 'Obi-Wan Kenobi',
          time: DateTime.now(),
        ),
      ),
      _ChatExampleObj(
        isLocalUser: false,
        message: ZdsMessage(
          content: 'General Kenobi',
          time: DateTime.now(),
          senderName: 'Grievous',
          status: ZdsChatMessageStatus.delivered,
          senderColor: Colors.grey.shade600,
        ),
      ),
      _ChatExampleObj(
        isLocalUser: false,
        message: ZdsMessage(
          content: '$lorem $lorem $lorem $lorem $lorem',
          time: DateTime.now(),
          senderName: 'Grievous',
          status: ZdsChatMessageStatus.delivered,
          senderColor: Colors.grey.shade600,
        ),
      ),
      _ChatExampleObj(
        message: ZdsMessage(
          status: ZdsChatMessageStatus.delivered,
          time: DateTime.now(),
          isForwarded: true,
          content: 'Something Something',
          tags: ['Tag 1', 'Tag 2'],
        ),
      ),
      _ChatExampleObj(
        message: ZdsMessage(
          time: DateTime.now(),
          isInfo: true,
          content: 'Info Message',
          status: ZdsChatMessageStatus.read,
        ),
      ),
      _ChatExampleObj(
        isLocalUser: false,
        message: ZdsMessage(
          status: ZdsChatMessageStatus.delivered,
          time: DateTime.now(),
          isDeleted: true,
          senderName: 'Peter',
        ),
      ),
      _ChatExampleObj(
        isLocalUser: false,
        message: ZdsMessage(
          status: ZdsChatMessageStatus.delivered,
          time: DateTime.now(),
          content: '😂😅🦓',
        ),
      ),
      _ChatExampleObj(
        isLocalUser: false,
        message: ZdsMessage(
          time: DateTime.now(),
          content: 'It’s an old code, but it checks out.',
          status: ZdsChatMessageStatus.read,
          replyMessageInfo: ZdsMessage(
            content: 'General Kenobi',
            senderName: 'Grevious',
            status: ZdsChatMessageStatus.read,
            time: DateTime.now(),
          ),
          reacts: {
            '😂': 2,
            '😅': 2,
            '🦓': 1,
          },
        ),
      ),
      _ChatExampleObj(
        message: ZdsMessage(
          time: DateTime.now(),
          content: 'It’s an old code, but it checks out.',
          status: ZdsChatMessageStatus.read,
          replyMessageInfo: ZdsMessage(
            content: 'General Kenobi',
            senderName: 'Grevious',
            status: ZdsChatMessageStatus.read,
            time: DateTime.now(),
          ),
          reacts: {'😂': 2, '😅': 2, '🦓': 1},
        ),
      ),
      _ChatExampleObj(
        message: ZdsMessage.imageNetwork(
          time: DateTime.now(),
          url: Uri.parse(
              'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e1/Hovawart_puppy_9_and_half_week.JPG/360px-Hovawart_puppy_9_and_half_week.JPG'),
          text: 'woof',
          status: ZdsChatMessageStatus.read,
        ),
        showFilePreview: true,
      ),
      _ChatExampleObj(
        message: ZdsMessage.videoNetwork(
          time: DateTime.now(),
          url: Uri.parse('https://sample-videos.com/video321/mp4/720/big_buck_bunny_720p_1mb.mp4'),
          text: 'bun video',
          status: ZdsChatMessageStatus.read,
        ),
      ),
      _ChatExampleObj(
        message: ZdsMessage.attachment(
          time: DateTime.now(),
          text: 'Important file. Guard it with your life.',
          attachment: ZdsChatAttachment(type: ZdsChatAttachmentType.docNetwork, name: 'Blueprints.pdf'),
          status: ZdsChatMessageStatus.read,
        ),
        isLocalUser: false,
      ),
      _ChatExampleObj(
        message: ZdsMessage.imageBase64(
          time: DateTime.now(),
          imageName: 'big.png',
          image: img ?? '',
          status: ZdsChatMessageStatus.read,
        ),
      ),
      _ChatExampleObj(
        isLocalUser: false,
        message: ZdsMessage.audioNetwork(
          time: DateTime.now(),
          url: Uri.parse('https://download.samplelib.com/mp3/sample-3s.mp3'),
          status: ZdsChatMessageStatus.read,
          text: 'Network file',
        ),
      ),
      _ChatExampleObj(
        isLocalUser: false,
        message: ZdsMessage.audioLocal(
          time: DateTime.now(),
          filePath: '${tmpDir}/${testAudioPath}',
          status: ZdsChatMessageStatus.read,
          text: 'Local audio file',
        ),
      ),
      _ChatExampleObj(
        message: ZdsMessage.videoLocal(
          time: DateTime.now(),
          filePath: '${tmpDir}/${testVideoPath}',
          status: ZdsChatMessageStatus.read,
          text: 'Local video',
        ),
      ),
      _ChatExampleObj(
        message: ZdsMessage.imageLocal(
          time: DateTime.now(),
          filePath: '${tmpDir}/${testImgPath}',
          status: ZdsChatMessageStatus.read,
          text: 'Local image Zebby',
        ),
      )
    ];

    return Scaffold(
      bottomNavigationBar: ZdsMessageInput(
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
          onSubmit: (value) {
            setState(
              () => children?.add(_ChatExampleObj(
                message: ZdsMessage.text(
                  status: ZdsChatMessageStatus.sent,
                  time: DateTime.now(),
                  content: value,
                ),
              )),
            );
            Future.delayed(Duration.zero).then((value) {
              controller.scrollTo(index: children!.length + 2, duration: Durations.extralong4);
            });
          }),
      body: ScrollablePositionedList.builder(
        itemScrollController: controller,
        initialScrollIndex: children!.length,
        physics: ClampingScrollPhysics(),
        itemBuilder: (context, index) {
          childWidgets[index] ??= ZdsChatMessage(
            message: children?[index].message,
            highlight: children?[index].highlight,
            isLocalUser: children?[index].isLocalUser,
            onLinkTapped: (link) => launchUrl(Uri.parse(link)),
            showFilePreview: children?[index].showFilePreview,
            shouldShake: children?[index].shouldShake,
            onFileDownload: () => showToast(context, 'Download'),
            onLongPress: () => showToast(context, 'Long press'),
            onReactTapped: () => showToast(context, 'Reacts tapped'),
            onReplyTap: (_) => showToast(context, 'Reply tapped'),
            onTagTapped: () => showToast(context, 'Tag tapped'),
          );
          return childWidgets[index];
        },
        itemCount: children!.length,
      ),
    );
  }
}
