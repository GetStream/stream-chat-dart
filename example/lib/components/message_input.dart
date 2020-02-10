import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stream_chat/stream_chat.dart';

import '../channel.bloc.dart';

class MessageInput extends StatefulWidget {
  MessageInput({Key key, this.onMessageSent}) : super(key: key);

  final void Function(Message) onMessageSent;

  @override
  _MessageInputState createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  final _textController = TextEditingController();
  bool _messageIsPresent = false;
  bool _typingStarted = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          gradient: _typingStarted
              ? LinearGradient(colors: [Color(0xFF00AEFF), Color(0xFF0076FF)])
              : null,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withAlpha(5),
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(color: Colors.black.withOpacity(.2)),
            ),
            child: Flex(
              direction: Axis.horizontal,
              children: <Widget>[
                Expanded(
                  child: TextField(
                    minLines: null,
                    maxLines: null,
                    onSubmitted: (_) {
                      _sendMessage(context);
                    },
                    controller: _textController,
                    onChanged: (s) {
                      Provider.of<ChannelBloc>(context, listen: false)
                          .channelClient
                          .keyStroke();
                      setState(() {
                        _messageIsPresent = s.isNotEmpty;
                      });
                    },
                    onTap: () {
                      setState(() {
                        _typingStarted = true;
                      });
                    },
                    style: Theme.of(context).textTheme.bodyText1,
                    autofocus: false,
                    decoration: InputDecoration(
                      hintText: 'Write a message',
                      prefixText: '   ',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                AnimatedCrossFade(
                  crossFadeState: _messageIsPresent
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                  firstChild: _buildSendButton(context),
                  secondChild: Container(),
                  duration: Duration(milliseconds: 300),
                  alignment: Alignment.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconButton _buildSendButton(BuildContext context) {
    return IconButton(
      onPressed: () {
        _sendMessage(context);
      },
      icon: RawMaterialButton(
        onPressed: () {
          _sendMessage(context);
        },
        constraints: BoxConstraints.tightFor(
          height: 40,
          width: 40,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32),
        ),
        child: Icon(
          Icons.send,
        ),
      ),
    );
  }

  void _sendMessage(BuildContext context) {
    final text = _textController.text;
    if (text.trim().isEmpty) {
      return;
    }

    _textController.clear();
    setState(() {
      _messageIsPresent = false;
      _typingStarted = false;
    });
    FocusScope.of(context).unfocus();
    Provider.of<ChannelBloc>(context, listen: false)
        .channelClient
        .sendMessage(
          Message(text: text),
        )
        .then((e) {
      widget.onMessageSent(e.message);
    });
  }
}
