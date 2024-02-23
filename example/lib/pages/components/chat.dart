import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:zds_flutter/zds_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatDemo extends StatelessWidget {
  const ChatDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ZdsChatMessage(
            isLocalUser: false,
            shouldShake: true,
            searchTerm: 'Hello',
            highlight: true,
            message: ZdsMessage(
              status: ZdsChatMessageStatus.delivered,
              content: 'Hello There http://bbc.co.uk',
              senderColor: Colors.blueAccent.shade200,
              senderName: 'Obi-Wan Kenobi',
              time: DateTime.now(),
            ),
            onLinkTapped: (link) {
              if (!kIsWeb) {
                launchUrl(Uri.parse(link));
              }
            },
          ),
          ZdsChatMessage(
            isLocalUser: false,
            message: ZdsMessage(
              content: 'General Kenobi',
              time: DateTime.now(),
              senderName: 'Grievous',
              status: ZdsChatMessageStatus.delivered,
              senderColor: Colors.grey.shade600,
            ),
          ),
          ZdsChatMessage(
            isLocalUser: false,
            message: ZdsMessage(
              content:
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Quis vel eros donec ac odio tempor orci dapibus. Ullamcorper a lacus vestibulum sed. Purus semper eget duis at tellus at urna condimentum. Duis at consectetur lorem donec massa sapien. Lacus vestibulum sed arcu non odio. Morbi tincidunt ornare massa eget. Massa tempor nec feugiat nisl pretium fusce. Ipsum faucibus vitae aliquet nec ullamcorper. Viverra nibh cras pulvinar mattis nunc sed blandit libero. Elit ut aliquam purus sit amet luctus venenatis lectus.\nTellus elementum sagittis vitae et. Tellus in metus vulputate eu scelerisque felis. Ut consequat semper viverra nam libero justo laoreet. Vel fringilla est ullamcorper eget nulla facilisi etiam dignissim diam. Nam aliquam sem et tortor consequat id porta. Ultricies integer quis auctor elit sed vulputate. Nulla porttitor massa id neque. Eu volutpat odio facilisis mauris sit amet massa vitae. Tellus orci ac auctor augue mauris augue. Montes nascetur ridiculus mus mauris vitae ultricies. Vivamus arcu felis bibendum ut.\nEst ullamcorper eget nulla facilisi etiam dignissim diam quis. A erat nam at lectus urna duis convallis. Neque convallis a cras semper auctor neque vitae tempus. Aliquam etiam erat velit scelerisque in dictum non consectetur a. Semper quis lectus nulla at volutpat. Odio euismod lacinia at quis risus sed vulputate odio. Diam maecenas sed enim ut sem viverra aliquet. Velit ut tortor pretium viverra suspendisse potenti. Mi proin sed libero enim sed faucibus turpis in eu. Sollicitudin aliquam ultrices sagittis orci a. Nunc pulvinar sapien et ligula ullamcorper malesuada proin libero nunc. Non blandit massa enim nec dui. Quis enim lobortis scelerisque fermentum dui.\nElementum eu facilisis sed odio. Aliquam ut porttitor leo a diam sollicitudin. Amet nisl purus in mollis nunc. Imperdiet sed euismod nisi porta lorem mollis aliquam. Tellus in hac habitasse platea dictumst vestibulum rhoncus est pellentesque. Maecenas ultricies mi eget mauris. Accumsan in nisl nisi scelerisque eu ultrices vitae auctor. Eu feugiat pretium nibh ipsum consequat nisl vel pretium. A pellentesque sit amet porttitor eget dolor. Enim nunc faucibus a pellentesque sit amet porttitor eget. Lorem dolor sed viverra ipsum nunc aliquet. Ullamcorper morbi tincidunt ornare massa eget. Nunc lobortis mattis aliquam faucibus purus in. Volutpat blandit aliquam etiam erat velit scelerisque in. Nisi quis eleifend quam adipiscing vitae proin. Egestas fringilla phasellus faucibus scelerisque. Nam aliquam sem et tortor consequat id. Euismod lacinia at quis risus sed vulputate odio ut enim. Vulputate ut pharetra sit amet aliquam id diam. Neque egestas congue quisque egestas diam.\nPellentesque eu tincidunt tortor aliquam nulla facilisi. Quis varius quam quisque id diam vel quam. Risus viverra adipiscing at in tellus integer feugiat. Purus gravida quis blandit turpis. Scelerisque mauris pellentesque pulvinar pellentesque habitant morbi tristique. Aliquam sem fringilla ut morbi tincidunt augue interdum. Orci nulla pellentesque dignissim enim sit amet venenatis urna cursus. Eu mi bibendum neque egestas congue quisque egestas diam. Risus pretium quam vulputate dignissim suspendisse. Nec feugiat in fermentum posuere urna. Id donec ultrices tincidunt arcu non. Id interdum velit laoreet id donec ultrices tincidunt. Orci a scelerisque purus semper. Pellentesque eu tincidunt tortor aliquam nulla facilisi cras fermentum odio.',
              time: DateTime.now(),
              senderName: 'Grievous',
              status: ZdsChatMessageStatus.delivered,
              senderColor: Colors.grey.shade600,
            ),
          ),
          ZdsChatMessage(
            message: ZdsMessage(
              status: ZdsChatMessageStatus.delivered,
              time: DateTime.now(),
              isForwarded: true,
              content: 'Something Something',
              tags: ['Tag 1', 'Tag 2'],
            ),
          ),
          ZdsChatMessage(
            message: ZdsMessage(
              time: DateTime.now(),
              isInfo: true,
              content: 'Info Message.',
              status: ZdsChatMessageStatus.read,
            ),
          ),
          ZdsChatMessage(
            isLocalUser: false,
            message: ZdsMessage(
              status: ZdsChatMessageStatus.delivered,
              time: DateTime.now(),
              isDeleted: true,
              senderName: 'Peter',
            ),
          ),
          ZdsChatMessage(
            isLocalUser: false,
            message: ZdsMessage(
              status: ZdsChatMessageStatus.delivered,
              time: DateTime.now(),
              content: '😂😅🦓',
            ),
          ),
          ZdsChatMessage(
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
          ZdsChatMessage(
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
        ],
      ),
    );
  }
}
