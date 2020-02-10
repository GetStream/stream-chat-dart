import 'package:flutter/material.dart';
import 'package:stream_chat/stream_chat.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({
    Key key,
    @required this.user,
  }) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 16,
      backgroundImage: user.extraData.containsKey('image')
          ? NetworkImage(user.extraData['image'] as String)
          : null,
      child: user.extraData.containsKey('image')
          ? null
          : Text(user?.extraData?.containsKey('name') ?? false
              ? user.extraData['name'][0]
              : ''),
    );
  }
}
