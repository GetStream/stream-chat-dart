import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_example/components/channel_widget.dart';
import 'package:stream_chat_example/components/connection_indicator.dart';
import 'package:stream_chat_example/stream_channel.dart';

import '../stream_chat.dart';
import 'channel_header.dart';
import 'channel_list_app_bar.dart';
import 'channel_list_view.dart';

class ChannelListPage extends StatefulWidget {
  ChannelListPage();

  @override
  ChannelListPageState createState() => ChannelListPageState();
}

class ChannelListPageState extends State<ChannelListPage> {
  String _selectedChannelId;
  bool showSplit;
  IndicatorController _indicatorController = IndicatorController();

  @override
  Widget build(BuildContext context) {
    final streamChat = StreamChat.of(context);
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
            appBar: ChannelListAppBar(),
            body: ChannelListView(
              filter: {
                'members': {
                  '\$in': [streamChat.user.id],
                }
              },
              sort: [SortOption("last_message_at")],
              pagination: PaginationParams(
                limit: 20,
              ),
              onChannelTap: (channelState) {
                _navigateToChannel(context, channelState);
              },
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
        showSplit
            ? Flexible(
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
                        child: ChannelWidget(
                          channelHeader: ChannelHeader(),
                        ),
                      ),
              )
            : Container(),
      ],
    );
  }

  void _navigateToChannel(BuildContext context, ChannelState channelState) {
    if (this.showSplit) {
      setState(() {
        _selectedChannelId = channelState.channel.id;
      });
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return StreamChannel(
              channelClient: StreamChat.of(context)
                  .client
                  .channelClients[channelState.channel.id],
              child: ChannelWidget(
                channelHeader: ChannelHeader(),
              ),
            );
          },
        ),
      );
    }
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
