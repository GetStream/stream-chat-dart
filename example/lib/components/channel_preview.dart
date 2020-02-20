import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_example/components/channel_image.dart';

import '../channel.bloc.dart';
import 'channel_name_text.dart';

class ChannelPreview extends StatelessWidget {
  final VoidCallback onTap;
  final ChannelState channelState;
  final int unreadCount;

  const ChannelPreview({
    Key key,
    @required this.onTap,
    @required this.channelState,
    @required this.unreadCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final channelBloc = InheritedChannelBloc.of(context).channelBloc;
    final channelState = channelBloc.channelState;
    return ListTile(
      onTap: () {
        onTap();
      },
      leading: ChannelImage(
        channel: channelState.channel,
      ),
      title: ChannelNameText(
        channel: channelState.channel,
      ),
      subtitle: _buildSubtitle(
        channelBloc,
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          _buildDate(context, channelState.channel.lastMessageAt),
        ],
      ),
    );
  }

  Text _buildDate(BuildContext context, DateTime lastMessageAt) {
    String stringDate;
    final now = DateTime.now();

    if (now.year != lastMessageAt.year ||
        now.month != lastMessageAt.month ||
        now.day != lastMessageAt.day) {
      stringDate =
          '${lastMessageAt.day}/${lastMessageAt.month}/${lastMessageAt.year}';
      stringDate = formatDate(lastMessageAt, [dd, '/', mm, '/', yyyy]);
    } else {
      stringDate = '${lastMessageAt.hour}:${lastMessageAt.minute}';
      stringDate = formatDate(lastMessageAt, [HH, ':', nn]);
    }

    return Text(
      stringDate,
      style: Theme.of(context).textTheme.caption,
    );
  }

  Widget _buildSubtitle(
    ChannelBloc channelBloc,
  ) {
    return StreamBuilder<List<User>>(
        stream: channelBloc.channelClient.channelClientState.typingEventsStream,
        initialData: [],
        builder: (context, snapshot) {
          final typings = snapshot.data;
          return typings.isNotEmpty
              ? Text(
                  '${typings.map((u) => u.extraData.containsKey('name') ? u.extraData['name'] : u.id).join(',')} ${typings.length == 1 ? 'is' : 'are'} typing...',
                  maxLines: 1,
                  style: Theme.of(context).textTheme.caption.copyWith(
                        color:
                            Colors.black.withOpacity(unreadCount > 0 ? 1 : 0.5),
                      ),
                )
              : Builder(builder: (context) {
                  final lastMessage = channelState.messages.isNotEmpty
                      ? channelState.messages.last
                      : null;
                  if (lastMessage == null) {
                    return SizedBox.fromSize(
                      size: Size.zero,
                    );
                  }

                  final prefix = lastMessage.attachments
                      .map((e) {
                        if (e.type == 'image') {
                          return '📷';
                        } else if (e.type == 'video') {
                          return '🎬';
                        }
                        return null;
                      })
                      .where((e) => e != null)
                      .join(' ');

                  return Text(
                    '$prefix ${lastMessage.text ?? ''}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.caption.copyWith(
                          color: Colors.black
                              .withOpacity(unreadCount > 0 ? 1 : 0.5),
                        ),
                  );
                });
        });
  }
}
