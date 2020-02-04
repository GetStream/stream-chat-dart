import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:stream_chat/stream_chat.dart';

import '../chat.bloc.dart';
import 'channel_preview.dart';

class ChannelList extends StatefulWidget {
  final Map<String, dynamic> filter;
  final Map<String, dynamic> options;
  final List<SortOption> sort;
  final PaginationParams pagination;

  ChannelList({
    this.filter,
    this.sort,
    this.pagination,
    this.options,
  });

  @override
  ChannelListState createState() => ChannelListState();
}

class ChannelListState extends State<ChannelList> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final chatBloc = Provider.of<ChatBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Channels List'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          chatBloc.clearChannels();
          return chatBloc.queryChannels(
            widget.filter,
            widget.sort,
            widget.pagination,
            widget.options,
          );
        },
        child: StreamBuilder<bool>(
          stream: chatBloc.queryChannelsLoading,
          builder: (context, snapshot) {
            final queryLoading = snapshot.data;
            return StreamBuilder<List<ChannelState>>(
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
                    return ListView.builder(
                      controller: _scrollController,
                      itemCount: snapshot.data.length + (queryLoading ? 1 : 0),
                      itemBuilder: (context, i) {
                        if (i != snapshot.data.length) {
                          return ChannelPreview(
                            channelState: snapshot.data[i],
                          );
                        } else {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    );
                  }
                });
          },
        ),
      ),
    );
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
    });
  }
}
