import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stream_chat/stream_chat.dart';
import 'chat.bloc.dart';
import 'components/channel_list_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final client = Client(
    "qk4nn7rpcn75",
    logLevel: Level.INFO,
    tokenProvider: (userId) async {
      return 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoid2lsZC1icmVlemUtNyJ9.VM2EX1EXOfgqa-bTH_3JzeY0T99ngWzWahSauP3dBMo';
    },
  );

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ChatBloc>(
      create: (_) => ChatBloc(client),
      child: MaterialApp(
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
      ),
    );
  }
}
