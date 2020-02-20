import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_example/stream_chat.dart';

import '../stream_channel.dart';
import 'connection_indicator.dart';
import 'message_input.dart';
import 'message_list.dart';

class ChannelWidget extends StatefulWidget {
  final PreferredSizeWidget _channelHeader;

  const ChannelWidget({
    Key key,
    @required PreferredSizeWidget channelHeader,
  })  : _channelHeader = channelHeader,
        super(key: key);

  @override
  _ChannelWidgetState createState() => _ChannelWidgetState();
}

class _ChannelWidgetState extends State<ChannelWidget> {
  final ScrollController _scrollController = ScrollController();

  IndicatorController _indicatorController = IndicatorController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: widget._channelHeader,
      body: Column(
        children: <Widget>[
          ConnectionIndicator(
            indicatorController: _indicatorController,
          ),
          Expanded(
            child: MessageList(
              key: ValueKey<String>('CHANNEL-MESSAGE-LIST'),
              scrollController: _scrollController,
            ),
          ),
          MessageInput(),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    final chatBloc = StreamChat.of(context);
    chatBloc.client.wsConnectionStatus.addListener(() {
      if (chatBloc.client.wsConnectionStatus.value ==
          ConnectionStatus.disconnected) {
        _indicatorController.showIndicator(
          duration: Duration(minutes: 1),
          color: Colors.red,
          text: 'Disconnected',
        );
      } else if (chatBloc.client.wsConnectionStatus.value ==
          ConnectionStatus.connecting) {
        _indicatorController.showIndicator(
          duration: Duration(minutes: 1),
          color: Colors.yellow,
          text: 'Reconnecting',
        );
      } else if (chatBloc.client.wsConnectionStatus.value ==
          ConnectionStatus.connected) {
        _indicatorController.showIndicator(
          duration: Duration(seconds: 5),
          color: Colors.green,
          text: 'Connected',
        );

        final channelBloc = StreamChannel.of(context);
        channelBloc.queryMessages();
      }
    });
  }
}
