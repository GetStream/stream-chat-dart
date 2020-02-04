import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stream_chat/stream_chat.dart';

class ChannelPreview extends StatelessWidget {
  final ChannelState channelState;

  ChannelPreview({Key key, @required this.channelState}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(channelState.channel.extraData['name'] as String ??
          channelState.channel.config.name),
      isThreeLine: true,
      subtitle: Text(
        channelState.messages?.last?.text ?? '',
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      onTap: () {},
      leading: CircleAvatar(
        backgroundImage: channelState.channel.extraData.containsKey('image')
            ? NetworkImage(channelState.channel.extraData['image'] as String)
            : null,
        child: channelState.channel.extraData.containsKey('image')
            ? null
            : Text(channelState.channel.config.name[0]),
      ),
    );
  }
}
