import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_example/chat.bloc.dart';
import 'components/channel_list.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  final client = Client("qk4nn7rpcn75", logLevel: Level.INFO);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ChatBloc(widget.client),
      child: MaterialApp(
        title: 'Stream Chat Example',
        home: ChatLoader(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }
}

class ChatLoader extends StatefulWidget {
  @override
  _ChatLoaderState createState() => _ChatLoaderState();
}

class _ChatLoaderState extends State<ChatLoader> {
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
            print('snap nodata');
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
              options: {'subscribe': true},
            );
          }
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Provider.of<ChatBloc>(context, listen: false).setUser(
        User(id: "wild-breeze-7"),
        "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoid2lsZC1icmVlemUtNyJ9.VM2EX1EXOfgqa-bTH_3JzeY0T99ngWzWahSauP3dBMo");
  }
}
