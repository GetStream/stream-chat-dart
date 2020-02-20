import 'package:flutter/material.dart';
import 'package:stream_chat/stream_chat.dart';

import 'chat.bloc.dart';
import 'components/channel_list_page.dart';

void main() {
  final client = Client(
    "qk4nn7rpcn75",
    logLevel: Level.INFO,
  );

  runApp(InheritedChatBloc(
    child: MyApp(),
    chatBloc: ChatBloc(client),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Stream Chat Example',
      home: ChatLoader(),
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xfff1f1f3),
        primaryColor: Color(0xfff1f1f3),
        accentColor: Color(0xff006bff),
        iconTheme: IconThemeData(
          color: Color(0xff006bff),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          foregroundColor: Color(0xff006bff),
        ),
        backgroundColor: Color(0xfff1f1f3),
        canvasColor: Color(0xfff1f1f3),
      ),
    );
  }

  @override
  void dispose() {
    InheritedChatBloc.of(context).chatBloc.dispose();
    super.dispose();
  }
}

class ChatLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final chatBloc = InheritedChatBloc.of(context).chatBloc;
    return StreamBuilder<User>(
      stream: chatBloc.client.clientState.userStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('${snapshot.error}'),
            ),
          );
        } else if (!snapshot.hasData) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          return ChannelListPage(
            filter: {
              'members': {
                '\$in': [snapshot.data.id],
              }
            },
            sort: [SortOption("last_message_at")],
            pagination: PaginationParams(
              limit: 20,
            ),
          );
        }
      },
    );
  }
}
