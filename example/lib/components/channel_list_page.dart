import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_example/components/connection_indicator.dart';
import 'package:stream_chat_example/components/message_page.dart';
import 'package:stream_chat_example/stream_channel.dart';

import '../stream_chat.dart';
import 'channel_list_view.dart';
import 'channel_page_app_bar.dart';

class ChannelListPage extends StatefulWidget {
  ChannelListPage({
    this.filter,
    this.options,
    this.sort,
    this.pagination,
  });

  final Map<String, dynamic> filter;
  final Map<String, dynamic> options;
  final List<SortOption> sort;
  final PaginationParams pagination;

  @override
  ChannelListPageState createState() => ChannelListPageState();
}

class ChannelListPageState extends State<ChannelListPage> {
  String _selectedChannelId;
  bool showSplit;
  IndicatorController _indicatorController = IndicatorController();

  @override
  Widget build(BuildContext context) {
    showSplit = MediaQuery.of(context).size.width > 1000;
    return Flex(
      direction: Axis.horizontal,
      children: <Widget>[
        Flexible(
          flex: 1,
          child: Scaffold(
            bottomNavigationBar: ConnectionIndicator(
              indicatorController: _indicatorController,
            ),
            appBar: ChannelPageAppBar(),
            body: ChannelListView(
              options: widget.options,
              filter: widget.filter,
              pagination: widget.pagination,
              sort: widget.sort,
              onChannelTap: showSplit
                  ? (channelState) {
                      _navigateToChannel(context, channelState);
                    }
                  : null,
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {},
              backgroundColor: Colors.white,
              child: Icon(
                Icons.send,
              ),
            ),
          ),
        ),
        showSplit ? _buildMessageView(context) : Container(),
      ],
    );
  }

  Flexible _buildMessageView(BuildContext context) {
    return Flexible(
      flex: 2,
      child: _selectedChannelId == null
          ? Scaffold(
              body: Center(
                child: Text(
                  'Pick a channel to show the messages 💬',
                  style: Theme.of(context).textTheme.headline,
                ),
              ),
            )
          : StreamChannel(
              channelClient: StreamChat.of(context)
                  .client
                  .channelClients[_selectedChannelId],
              child: MessagePage(),
            ),
    );
  }

  void _navigateToChannel(
    BuildContext context,
    ChannelState channelState,
  ) {
    setState(() {
      _selectedChannelId = channelState.channel.id;
    });
  }

  @override
  void initState() {
    super.initState();

    final streamChat = StreamChat.of(context);
    streamChat.client.wsConnectionStatus.addListener(() {
      if (streamChat.client.wsConnectionStatus.value ==
          ConnectionStatus.disconnected) {
        _indicatorController.showIndicator(
          duration: Duration(minutes: 1),
          color: Colors.red,
          text: 'Disconnected',
        );
      } else if (streamChat.client.wsConnectionStatus.value ==
          ConnectionStatus.connecting) {
        _indicatorController.showIndicator(
          duration: Duration(minutes: 1),
          color: Colors.yellow,
          text: 'Reconnecting',
        );
      } else if (streamChat.client.wsConnectionStatus.value ==
          ConnectionStatus.connected) {
        _indicatorController.showIndicator(
          duration: Duration(seconds: 5),
          color: Colors.green,
          text: 'Connected',
        );
        streamChat.clearChannels();

        streamChat.queryChannels();
      }
    });
  }
}
