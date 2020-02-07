import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:stream_chat/stream_chat.dart';
import '../channel.bloc.dart';

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
    return Consumer<ChatBloc>(
      builder: (context, ChatBloc chatBloc, _) => Scaffold(
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Container(
                height: 50,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            child: Container(
                              color: Colors.black12,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: TextField(
                                  style: TextStyle(
                                    color: Colors.black.withOpacity(0.5),
                                    fontSize: 14,
                                  ),
                                  autofocus: false,
                                  decoration: InputDecoration(
                                    hintText: 'Search',
                                    prefixText: '   ',
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      RawMaterialButton(
                        onPressed: () {},
                        constraints:
                            BoxConstraints.tightFor(height: 40, width: 40),
                        elevation: 0,
                        hoverElevation: 0,
                        disabledElevation: 0,
                        focusElevation: 0,
                        highlightElevation: 0,
                        fillColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                        child: Icon(
                          Icons.send,
                          color: Color(0xff006bff),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: RefreshIndicator(
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
                        return _buildListView(snapshot, chatBloc);
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ListView _buildListView(
    AsyncSnapshot<List<ChannelState>> snapshot,
    ChatBloc chatBloc,
  ) {
    return ListView.separated(
      separatorBuilder: (context, i) {
        if (i >= snapshot.data.length) {
          return Container();
        }
        return Container(
          height: 1,
          color: Colors.black.withOpacity(0.1),
          margin: EdgeInsets.symmetric(horizontal: 16),
        );
      },
      controller: _scrollController,
      itemCount: snapshot.data.length + 1,
      itemBuilder: (context, i) {
        if (i < snapshot.data.length) {
          return ChangeNotifierProvider<ChannelBloc>.value(
            key: Key(snapshot.data[i].channel.id),
            value: chatBloc.channelBlocs[snapshot.data[i].channel.id],
            child: ChannelPreview(),
          );
        } else {
          return StreamBuilder<bool>(
            stream: chatBloc.queryChannelsLoading,
            builder: (context, snapshot) {
              return Container(
                height: 100,
                padding: EdgeInsets.all(32),
                child: Center(
                  child: (snapshot.hasData && snapshot.data)
                      ? CircularProgressIndicator()
                      : Container(),
                ),
              );
            },
          );
        }
      },
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
