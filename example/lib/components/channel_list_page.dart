import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_example/channel.bloc.dart';
import 'package:stream_chat_example/components/channel_widget.dart';
import 'package:stream_chat_example/components/connection_indicator.dart';

import '../chat.bloc.dart';
import 'channel_header.dart';
import 'channel_list_app_bar.dart';
import 'channel_list_view.dart';
import 'channel_preview.dart';

class ChannelListPage extends StatefulWidget {
  final Map<String, dynamic> filter;
  final Map<String, dynamic> options;
  final List<SortOption> sort;
  final PaginationParams pagination;

  ChannelListPage({
    this.filter,
    this.sort,
    this.pagination,
    this.options,
  });

  @override
  ChannelListPageState createState() => ChannelListPageState();
}

class ChannelListPageState extends State<ChannelListPage> {
  final ScrollController _scrollController = ScrollController();
  String _selectedChannelId;
  bool showSplit;
  IndicatorController _indicatorController = IndicatorController();

  @override
  Widget build(BuildContext context) {
    showSplit = MediaQuery.of(context).size.width > 1000;
    return Consumer<ChatBloc>(
      builder: (context, ChatBloc chatBloc, _) => Flex(
        direction: Axis.horizontal,
        children: <Widget>[
          Flexible(
            flex: 1,
            child: Scaffold(
              bottomNavigationBar: ConnectionIndicator(
                indicatorController: _indicatorController,
              ),
              appBar: ChannelListAppBar(),
              body: StreamBuilder<List<ChannelState>>(
                stream: chatBloc.channelsStream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(snapshot.error.toString()),
                    );
                  } else if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return RefreshIndicator(
                      onRefresh: () async {
                        chatBloc.clearChannels();
                        return chatBloc.queryChannels(
                          widget.filter,
                          widget.sort,
                          widget.pagination,
                          widget.options,
                        );
                      },
                      child: ChannelListView(
                        scrollController: _scrollController,
                        channelsStates: snapshot.data,
                        channelPreviewBuilder: (context, channelState) {
                          return ChannelPreview(
                            onTap: () {
                              _navigateToChannel(
                                context,
                                chatBloc.channelBlocs[channelState.channel.id],
                              );
                            },
                          );
                        },
                      ),
                    );
                  }
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
                      : ChangeNotifierProvider<ChannelBloc>.value(
                          value: chatBloc.channelBlocs[_selectedChannelId],
                          child: ChannelWidget(
                            key: ValueKey<String>(chatBloc
                                .channelBlocs[_selectedChannelId]
                                .channelState
                                .channel
                                .id),
                            channelHeader: ChannelHeader(
                              showBackButton: false,
                            ),
                          ),
                        ),
                )
              : Container(),
        ],
      ),
    );
  }

  void _navigateToChannel(BuildContext context, ChannelBloc channelBloc) {
    if (this.showSplit) {
      setState(() {
        _selectedChannelId = channelBloc.channelState.channel.id;
      });
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return ChangeNotifierProvider<ChannelBloc>.value(
              value: channelBloc,
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

    final chatBloc = Provider.of<ChatBloc>(context, listen: false);
    chatBloc.queryChannels(
      widget.filter,
      widget.sort,
      widget.pagination,
      widget.options,
    );

    _scrollController.addListener(() {
      _listenChannelPagination(chatBloc);
    });

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
        chatBloc.clearChannels();

        chatBloc.queryChannels(
          widget.filter,
          widget.sort,
          widget.pagination,
          widget.options,
        );
      }
    });
  }

  void _listenChannelPagination(ChatBloc chatBloc) {
    if (_scrollController.position.maxScrollExtent ==
        _scrollController.position.pixels) {
      chatBloc.queryChannels(
        widget.filter,
        widget.sort,
        widget.pagination.copyWith(
          offset: chatBloc.channels.length,
        ),
        widget.options,
      );
    }
  }
}
