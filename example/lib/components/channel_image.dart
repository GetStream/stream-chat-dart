import 'package:flutter/material.dart';
import 'package:stream_chat/stream_chat.dart';

class ChannelImage extends StatelessWidget {
  const ChannelImage({
    Key key,
    @required this.channel,
  }) : super(key: key);

  final Channel channel;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircleAvatar(
        radius: 20,
        backgroundImage: channel.extraData.containsKey('image')
            ? NetworkImage(channel.extraData['image'] as String)
            : null,
        child: channel.extraData.containsKey('image')
            ? null
            : Text(channel.config.name[0]),
      ),
    );
  }
}
