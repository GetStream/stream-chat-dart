import 'package:flutter/widgets.dart';
import '../models/channel.dart';

class ChannelPreview extends StatelessWidget {
  final Channel channel;

  ChannelPreview({Key key, @required this.channel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(channel.cid).build(context);
  }
}
