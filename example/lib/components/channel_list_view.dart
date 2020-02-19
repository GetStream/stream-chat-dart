import 'package:flutter/material.dart';
import 'package:stream_chat/stream_chat.dart';

import '../channel.bloc.dart';
import '../chat.bloc.dart';

typedef ChannelPreviewBuilder = Widget Function(BuildContext, ChannelState);

class ChannelListView extends StatelessWidget {
  const ChannelListView({
    Key key,
    @required ScrollController scrollController,
    @required this.channelsStates,
    @required ChannelPreviewBuilder channelPreviewBuilder,
  })  : _scrollController = scrollController,
        _channelPreviewBuilder = channelPreviewBuilder,
        super(key: key);

  final ScrollController _scrollController;
  final List<ChannelState> channelsStates;
  final ChannelPreviewBuilder _channelPreviewBuilder;

  @override
  Widget build(BuildContext context) {
    return ListView.custom(
      physics: AlwaysScrollableScrollPhysics(),
      controller: _scrollController,
      childrenDelegate: SliverChildBuilderDelegate(
        _itemBuilder,
        childCount: (channelsStates.length * 2) + 1,
        findChildIndexCallback: (key) {
          final ValueKey<String> valueKey = key;
          final index = channelsStates
              .indexWhere((cs) => 'CHANNEL-${cs.channel.id}' == valueKey.value);
          return index != -1 ? (index * 2) : null;
        },
      ),
    );
  }

  Widget _itemBuilder(context, int i) {
    if (i % 2 != 0) {
      return _separatorBuilder(context, i);
    }
    i = i ~/ 2;
    if (i < channelsStates.length) {
      final channelBloc = InheritedChatBloc.of(context)
          .chatBloc
          .channelBlocs[channelsStates[i].channel.id];
      return InheritedChannelBloc(
        key: ValueKey('CHANNEL-${channelBloc.channelState.channel.id}'),
        channelBloc: channelBloc,
        child: _channelPreviewBuilder(
          context,
          channelsStates[i],
        ),
      );
    } else {
      return _buildQueryProgressIndicator(context);
    }
  }

  StreamBuilder<bool> _buildQueryProgressIndicator(context) {
    return StreamBuilder<bool>(
      stream: InheritedChatBloc.of(context).chatBloc.queryChannelsLoading,
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

  Widget _separatorBuilder(context, i) {
    return Container(
      height: 1,
      color: Colors.black.withOpacity(0.1),
      margin: EdgeInsets.symmetric(horizontal: 16),
    );
  }
}
