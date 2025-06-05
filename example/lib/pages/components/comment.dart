import 'package:flutter/material.dart';
import 'package:zds_flutter/zds_flutter.dart';

class CommentDemo extends StatefulWidget {
  const CommentDemo({super.key});

  @override
  State<CommentDemo> createState() => _CommentDemoState();
}

class _CommentDemoState extends State<CommentDemo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Zeta.of(context).colors.surfaceDefault,
      child: Column(
        children: [
          ZdsComment(
            backgroundColor: Colors.amber,
            popupMenuBackgroundColor: Colors.greenAccent[100],
            avatar: ZetaAvatar.initials(
              initials: 'JP',
              size: ZetaAvatarSize.xxxs,
            ),
            author: 'John Doe with a really really long name',
            downloadCallback: () {},
            onMenuItemSelected: (val) {
              print(val);
            },
            menuItems: [
              ZdsPopupMenuItem(
                value: 1,
                child: Row(
                  children: [
                    Icon(ZdsIcons.delete),
                    Text('Delete'),
                  ],
                ),
              ),
              ZdsPopupMenuItem(
                value: 2,
                child: Row(
                  children: [
                    Icon(ZetaIcons.reply),
                    Text('Reply'),
                  ],
                ),
              ),
            ],
            comment: 'This is a comment',
            onReply: () {
              print('reply');
            },
            replySemanticLabel: 'Reply to comment',
            onDelete: () {
              print('delete');
            },
            deleteSemanticLabel: 'Delete',
            timeStamp: '09:30 AM',
            attachment: ZdsChatAttachment(
              type: ZdsChatAttachmentType.docNetwork,
              name: 'Blueprints.xls',
              size: '1234kb',
              extension: 'xls',
            ),
          ),
          ZdsComment(
            avatar: ZetaAvatar.initials(
              initials: 'JP',
              size: ZetaAvatarSize.xxxs,
              backgroundColor: Zeta.of(context).colors.surfaceAvatarPurple,
            ),
            onDelete: () {},
            deleteSemanticLabel: 'Delete',
            isReply: true,
            author: 'John Doe',
            comment: 'This is a comment',
            timeStamp: '09:30 AM',
            attachment: ZdsChatAttachment(
              name: 'Blueprints',
              size: '1234kb',
              extension: 'ici',
            ),
          ),
          ZdsComment(
            avatar: ZetaAvatar.initials(
              initials: 'JP',
              size: ZetaAvatarSize.xxxs,
            ),
            author: 'John Doe',
            comment: 'This is a comment',
            onReply: () {},
            replySemanticLabel: 'Reply to comment',
            onDelete: () {},
            deleteSemanticLabel: 'Delete',
            timeStamp: '09:30 AM',
          ),
        ],
      ),
    );
  }
}
