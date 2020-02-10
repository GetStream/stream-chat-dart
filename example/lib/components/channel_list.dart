import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:stream_chat/stream_chat.dart';

import '../chat.bloc.dart';
import 'channel_list_app_bar.dart';
import 'channel_list_view.dart';

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
    return Consumer<ChatBloc>(
      builder: (context, ChatBloc chatBloc, _) => Scaffold(
        appBar: ChannelListAppBar(),
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
          child: StreamBuilder<List<ChannelState>>(
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
                return ChannelListView(
                  scrollController: _scrollController,
                  channelsStates: snapshot.data,
                );
              }
            },
          ),
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
      _listenChannelPagination(chatBloc);
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
