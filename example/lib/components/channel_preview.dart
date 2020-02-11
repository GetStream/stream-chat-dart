import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_example/components/channel_image.dart';

import '../channel.bloc.dart';
import 'channel_name_text.dart';

class ChannelPreview extends StatefulWidget {
  final VoidCallback onTap;

  const ChannelPreview({
    Key key,
    @required this.onTap,
  }) : super(key: key);

  @override
  _ChannelPreviewState createState() => _ChannelPreviewState();
}

class _ChannelPreviewState extends State<ChannelPreview>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<ChannelBloc>(
      builder: (context, channelBloc, _) {
        final channelState = channelBloc.channelState;
        return ListTile(
          onTap: () {
            widget.onTap();
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
              StreamBuilder<DateTime>(
                  stream: channelBloc.messages
                      .map((message) => message.last.createdAt),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return SizedBox.fromSize(
                        size: Size.zero,
                      );
                    }
                    return _buildDate(snapshot.data.toLocal());
                  }),
            ],
          ),
        );
      },
    );
  }

  Text _buildDate(DateTime lastMessageAt) {
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
    return StreamBuilder<bool>(
      stream: channelBloc.read,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }
        final read = snapshot.data;
        return StreamBuilder<List<User>>(
            stream: channelBloc.channelClient.typingEvents,
            initialData: [],
            builder: (context, snapshot) {
              final typings = snapshot.data;
              return typings.isNotEmpty
                  ? Text(
                      '${typings.map((u) => u.extraData.containsKey('name') ? u.extraData['name'] : u.id).join(',')} ${typings.length == 1 ? 'is' : 'are'} typing...',
                      maxLines: 1,
                      style: Theme.of(context).textTheme.caption.copyWith(
                            color: Colors.black.withOpacity(!read ? 1 : 0.5),
                          ),
                    )
                  : StreamBuilder<Message>(
                      stream: channelBloc.messages.map((event) => event.last),
                      builder: (context, snapshot) {
                        return Text(
                          snapshot.data?.text ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.caption.copyWith(
                                color:
                                    Colors.black.withOpacity(!read ? 1 : 0.5),
                              ),
                        );
                      },
                    );
            });
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
