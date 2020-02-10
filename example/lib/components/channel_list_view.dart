import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stream_chat/stream_chat.dart';

import '../channel.bloc.dart';
import '../chat.bloc.dart';
import 'channel.dart';
import 'channel_preview.dart';

class ChannelListView extends StatelessWidget {
  const ChannelListView({
    Key key,
    @required ScrollController scrollController,
    @required this.channelsStates,
  })  : _scrollController = scrollController,
        super(key: key);

  final ScrollController _scrollController;
  final List<ChannelState> channelsStates;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: AlwaysScrollableScrollPhysics(),
      separatorBuilder: _separatorBuilder,
      controller: _scrollController,
      itemCount: channelsStates.length + 1,
      itemBuilder: _itemBuilder,
    );
  }

  Widget _itemBuilder(context, i) {
    if (i < channelsStates.length) {
      final channelBloc = Provider.of<ChatBloc>(context)
          .channelBlocs[channelsStates[i].channel.id];
      return ChangeNotifierProvider<ChannelBloc>.value(
        key: Key(channelsStates[i].channel.id),
        value: channelBloc,
        child: ChannelPreview(
          onTap: (channelState) {
            _navigateToChannel(context, channelBloc);
          },
        ),
      );
    } else {
      return _buildQueryProgressIndicator(context);
    }
  }

  void _navigateToChannel(BuildContext context, ChannelBloc channelBloc) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return ChangeNotifierProvider.value(
            value: channelBloc,
            child: ChannelWidget(),
          );
        },
      ),
    );
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
