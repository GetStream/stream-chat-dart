import 'dart:async';

import 'package:flutter/material.dart';
import 'client.dart';
import 'components/channel_list.dart';
import 'components/stream_chat_container.dart';
import 'api/requests.dart';
import 'models/user.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var client = new Client(apiKey: "6xjf3dex3n7d");

    return
      StreamChatContainer(
        child: MaterialApp(
          title: 'Stream Chat Example',
          home: ChatLoader(
              child: ChannelList(
                filter: QueryFilter(),
                sort: [SortOption(field: "last_message_at")],
                options: {},
              ),
              user: User("wild-breeze-7", {}),
              token: "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoid2lsZC1icmVlemUtNyJ9.VM2EX1EXOfgqa-bTH_3JzeY0T99ngWzWahSauP3dBMo",
          ),
        ),
      client: client,
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
    setUser = StreamChatContainer.of(context).client.setUser(widget.user, widget.token);
    super.didChangeDependencies();
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
          return CircularProgressIndicator();
        }
    );
  }

}
