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
            avatar: ZetaAvatar.initials(
              initials: 'JP',
              size: ZetaAvatarSize.xxxs,
            ),
            author: 'John Doe',
            downloadCallback: () {},
            comment: 'This is a comment',
            onReply: () {},
            replySemanticLabel: 'Reply to comment',
            onDelete: () {},
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
