import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stream_chat/stream_chat.dart';
import 'chat.bloc.dart';
import 'components/channel_list.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final client = Client("qk4nn7rpcn75", logLevel: Level.INFO);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ChatBloc>(
      create: (_) => ChatBloc(client),
      child: MaterialApp(
        title: 'Stream Chat Example',
        home: ChatLoader(),
        theme: ThemeData(scaffoldBackgroundColor: Color(0xF1F1F3FF)),
      ),
    );
  }
}

class ChatLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ChatBloc>(
      builder: (context, chatBloc, _) => StreamBuilder<User>(
        stream: chatBloc.userStream,
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
            return ChannelList(
              filter: Map<String, dynamic>(),
              sort: [SortOption("last_message_at")],
              pagination: PaginationParams(
                limit: 20,
              ),
            );
          }
        },
      ),
    );
  }
}
