import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stream_chat/stream_chat.dart';
import 'channel_preview.dart';
import 'stream_chat_container.dart';

class ChannelList extends StatefulWidget {
  final QueryFilter filter;
  final List<SortOption> sort;
  final Map<String, dynamic> options;

  ChannelList({this.filter, this.sort, this.options});

  @override
  ChannelListState createState() => ChannelListState();
}

class ChannelListState extends State<ChannelList> {
  final _channels = <ChannelState>[];

  Future<QueryChannelsResponse> channels;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    channels = StreamChatContainer.of(context)
        .client
        .queryChannels(widget.filter, widget.sort, widget.options);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Channels List'),
      ),
      body: FutureBuilder<QueryChannelsResponse>(
          future: channels,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              _channels.addAll(snapshot.data.channels);
              return ListView.builder(
                  itemCount: _channels.length,
                  padding: const EdgeInsets.all(16.0),
                  itemBuilder: (context, i) {
                    return ChannelPreview(channel: _channels[i].channel);
                  });
            }
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            return CircularProgressIndicator();
          }),
    );
  }
}
