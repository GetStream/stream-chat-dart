import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:stream_chat/stream_chat.dart';

import '../channel.bloc.dart';
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
    return Consumer<ChannelBloc>(
      builder: (context, channelBloc, _) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: widget._channelHeader,
          body: Column(
            children: <Widget>[
              ConnectionIndicator(
                indicatorController: _indicatorController,
              ),
              Expanded(
                child: StreamBuilder<List<Message>>(
                  stream: channelBloc.messages,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Container();
                    }
                    final messages = snapshot.data.reversed.toList();
                    return MessageList(
                      messages,
                      key: ValueKey<String>('CHANNEL-MESSAGE-LIST'),
                      scrollController: _scrollController,
                    );
                  },
                ),
              ),
              MessageInput(
                onMessageSent: (_) {
                  _scrollController.jumpTo(0);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();

    final channelBloc = Provider.of<ChannelBloc>(context, listen: false);
    channelBloc.chatBloc.client.wsConnectionStatus.addListener(() {
      if (channelBloc.chatBloc.client.wsConnectionStatus.value ==
          ConnectionStatus.disconnected) {
        _indicatorController.showIndicator(
          duration: Duration(minutes: 1),
          color: Colors.red,
          text: 'Disconnected',
        );
      } else if (channelBloc.chatBloc.client.wsConnectionStatus.value ==
          ConnectionStatus.connecting) {
        _indicatorController.showIndicator(
          duration: Duration(minutes: 1),
          color: Colors.yellow,
          text: 'Reconnecting',
        );
      } else if (channelBloc.chatBloc.client.wsConnectionStatus.value ==
          ConnectionStatus.connected) {
        _indicatorController.showIndicator(
          duration: Duration(seconds: 5),
          color: Colors.green,
          text: 'Connected',
        );

        channelBloc.queryMessages();
      }
    });
  }
}
