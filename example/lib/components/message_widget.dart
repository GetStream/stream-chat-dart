import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';
import 'package:stream_chat/src/models/attachment.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_example/components/user_avatar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

import '../channel.bloc.dart';

class MessageWidget extends StatefulWidget {
  const MessageWidget({
    Key key,
    @required this.previousMessage,
    @required this.message,
    @required this.nextMessage,
  }) : super(key: key);

  final Message previousMessage;
  final Message message;
  final Message nextMessage;

  @override
  _MessageWidgetState createState() => _MessageWidgetState(
        message,
        previousMessage,
        nextMessage,
      );
}

class _MessageWidgetState extends State<MessageWidget>
    with AutomaticKeepAliveClientMixin {
  final Map<String, ChangeNotifier> _videoControllers = {};
  final Map<String, ChangeNotifier> _chuwieControllers = {};

  final Message previousMessage;
  final Message message;
  final Message nextMessage;

  _MessageWidgetState(
    this.message,
    this.previousMessage,
    this.nextMessage,
  );

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final channelBloc = Provider.of<ChannelBloc>(context);
    final currentUserId = channelBloc.chatBloc.user.id;
    final messageUserId = message.user.id;
    final previousUserId = previousMessage?.user?.id;
    final nextUserId = nextMessage?.user?.id;
    final bool isMyMessage = messageUserId == currentUserId;
    final isLastUser = previousUserId == messageUserId;
    final isNextUser = nextUserId == messageUserId;
    final alignment =
        isMyMessage ? Alignment.centerRight : Alignment.centerLeft;

    List<Widget> row = <Widget>[
      Column(
        crossAxisAlignment:
            isMyMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          _buildBubble(context, isMyMessage, isLastUser),
          isNextUser ? Container() : _buildTimestamp(isMyMessage, alignment),
        ],
      ),
      isNextUser
          ? Container(
              width: 40,
            )
          : Padding(
              padding: EdgeInsets.only(
                left: isMyMessage ? 8.0 : 0,
                right: isMyMessage ? 0 : 8.0,
              ),
              child: UserAvatar(user: message.user),
            ),
    ];

    if (!isMyMessage) {
      row = row.reversed.toList();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      margin: EdgeInsets.only(
        top: isLastUser ? 5 : 24,
        bottom: nextMessage == null ? 30 : 0,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment:
            isMyMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: row,
      ),
    );
  }

  Widget _buildBubble(
    BuildContext context,
    bool isMyMessage,
    bool isLastUser,
  ) {
    int nOfAttachmentWidgets = 0;

    final column = Column(
      crossAxisAlignment:
          isMyMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: message.attachments.map((attachment) {
        nOfAttachmentWidgets++;

        Widget attachmentWidget;
        if (attachment.type == 'video') {
          attachmentWidget = _buildVideo(attachment, isMyMessage, isLastUser);
        } else if (attachment.type == 'image' || attachment.type == 'giphy') {
          attachmentWidget = _buildImage(isMyMessage, isLastUser, attachment);
        }

        if (attachmentWidget != null) {
          return Container(
            child: attachmentWidget,
            margin: EdgeInsets.only(
              top: nOfAttachmentWidgets > 1 ? 5 : 0,
            ),
          );
        }

        nOfAttachmentWidgets--;
        return Container();
      }).toList(),
    );

    if (message.text.trim().isNotEmpty) {
      column.children.add(Container(
        margin: EdgeInsets.only(
          top: nOfAttachmentWidgets > 0 ? 5 : 0,
        ),
        decoration: _buildBoxDecoration(
            isMyMessage, isLastUser || nOfAttachmentWidgets > 0),
        padding: EdgeInsets.all(10),
        constraints: BoxConstraints.loose(Size.fromWidth(300)),
        child: MarkdownBody(
          data: '${message.text}',
          onTapLink: (link) {
            _launchURL(link);
          },
        ),
      ));
    }

    return column;
  }

  Container _buildImage(
    bool isMyMessage,
    bool isLastUser,
    Attachment attachment,
  ) {
    return Container(
      constraints: BoxConstraints.loose(Size.fromWidth(300)),
      decoration: _buildBoxDecoration(isMyMessage, isLastUser),
      child: CachedNetworkImage(
        imageUrl: attachment.imageUrl ?? attachment.thumbUrl,
        fit: BoxFit.cover,
      ),
    );
  }

  Container _buildVideo(
    Attachment attachment,
    bool isMyMessage,
    bool isLastUser,
  ) {
    VideoPlayerController videoController;
    if (_videoControllers.containsKey(attachment.assetUrl)) {
      videoController = _videoControllers[attachment.assetUrl];
    } else {
      videoController = VideoPlayerController.network(attachment.assetUrl);
      _videoControllers[attachment.assetUrl] = videoController;
    }

    ChewieController chewieController;
    if (_chuwieControllers.containsKey(attachment.assetUrl)) {
      chewieController = _chuwieControllers[attachment.assetUrl];
    } else {
      chewieController = ChewieController(
          videoPlayerController: videoController,
          autoInitialize: true,
          errorBuilder: (_, e) {
            return Container(
              constraints: BoxConstraints.loose(Size.fromWidth(300)),
              decoration: _buildBoxDecoration(isMyMessage, isLastUser),
              child: Stack(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: CachedNetworkImageProvider(
                          attachment.thumbUrl,
                        ),
                      ),
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => _launchURL(attachment.assetUrl),
                    ),
                  ),
                ],
              ),
            );
          });
      _chuwieControllers[attachment.assetUrl] = chewieController;
    }

    return Container(
      constraints: BoxConstraints.loose(Size.fromWidth(300)),
      decoration: _buildBoxDecoration(isMyMessage, isLastUser),
      child: ClipRRect(
        borderRadius: _buildBoxDecoration(isMyMessage, isLastUser).borderRadius,
        child: Chewie(
          key: ValueKey<String>('ATTACHMENT-${attachment.title}-${message.id}'),
          controller: chewieController,
        ),
      ),
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('Cannot launch the url'),
        ),
      );
    }
  }

  @override
  void dispose() {
    _videoControllers.values.forEach((element) {
      element.dispose();
    });
    super.dispose();
  }

  Widget _buildTimestamp(bool isMyMessage, Alignment alignment) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: Text(
        formatDate(message.createdAt.toLocal(), [HH, ':', nn]),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration(bool isMyMessage, bool isLastUser) {
    return BoxDecoration(
      border: isMyMessage ? null : Border.all(color: Colors.black.withAlpha(8)),
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular((isMyMessage || !isLastUser) ? 16 : 2),
        bottomLeft: Radius.circular(isMyMessage ? 16 : 2),
        topRight: Radius.circular((isMyMessage && isLastUser) ? 2 : 16),
        bottomRight: Radius.circular(isMyMessage ? 2 : 16),
      ),
      color: isMyMessage ? Color(0xffebebeb) : Colors.white,
    );
  }

  @override
  bool get wantKeepAlive {
    return message.attachments.isNotEmpty;
  }
}
