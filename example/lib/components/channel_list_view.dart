import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
//      separatorBuilder: _separatorBuilder,
      controller: _scrollController,
//      itemCount: channelsStates.length + 1,
//      itemBuilder: _itemBuilder,
      childrenDelegate: SliverChildBuilderDelegate(_itemBuilder,
          childCount: channelsStates.length + 1, findChildIndexCallback: (key) {
        final ValueKey<String> valueKey = key;
        final channelState = channelsStates
            .indexWhere((cs) => 'CHANNEL-${cs.channel.id}' == valueKey.value);
        return channelState != -1 ? channelState : null;
      }),
    );
  }

  Widget _itemBuilder(context, i) {
    if (i < channelsStates.length) {
      final channelBloc = Provider.of<ChatBloc>(context)
          .channelBlocs[channelsStates[i].channel.id];
      return ChangeNotifierProvider<ChannelBloc>.value(
        key: ValueKey('CHANNEL-${channelBloc.channelState.channel.id}'),
        value: channelBloc,
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
      stream: Provider.of<ChatBloc>(context).queryChannelsLoading,
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
    if (i >= channelsStates.length) {
      return Container();
    }
    return Container(
      height: 1,
      color: Colors.black.withOpacity(0.1),
      margin: EdgeInsets.symmetric(horizontal: 16),
    );
  }
}
