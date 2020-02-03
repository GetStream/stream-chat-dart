import 'dart:async';

import 'package:flutter/material.dart';
import 'package:stream_chat/stream_chat.dart';

import 'components/channel_list.dart';
import 'components/stream_chat_container.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final client = Client("6xjf3dex3n7d");

  @override
  Widget build(BuildContext context) {
    return StreamChat(
      client: client,
      child: MaterialApp(
        title: 'Stream Chat Example',
        home: ChatLoader(
          child: ChannelList(
            filter: Map<String, dynamic>(),
            sort: [SortOption("last_message_at")],
            options: {},
          ),
          user: User(id: "wild-breeze-7"),
          token:
              "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoid2lsZC1icmVlemUtNyJ9.VM2EX1EXOfgqa-bTH_3JzeY0T99ngWzWahSauP3dBMo",
        ),
      ),
    );
  }
}

class ChatLoader extends StatefulWidget {
  final Widget child;
  final String token;
  final User user;

  ChatLoader({@required this.child, @required this.user, @required this.token});

  @override
  State createState() => ChatLoaderState();
}

class ChatLoaderState extends State<ChatLoader> {
  Future<dynamic> setUser;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setUser = StreamChat.of(context).client.setUser(widget.user, widget.token);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
        future: setUser,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return widget.child;
          }
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return Center(child: CircularProgressIndicator());
        });
  }
}
