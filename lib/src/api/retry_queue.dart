import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:stream_chat/src/api/channel.dart';
import 'package:stream_chat/src/api/retry_policy.dart';
import 'package:stream_chat/src/event_type.dart';
import 'package:stream_chat/src/exceptions.dart';
import 'package:stream_chat/src/models/message.dart';
import 'package:stream_chat/stream_chat.dart';

class RetryQueue {
  final Channel channel;
  final Logger logger;

  RetryQueue({
    @required this.channel,
    this.logger,
  }) {
    _retryPolicy = channel.client.retryPolicy;

    _listenConnectionRecovered();

    _listenFailedEvents();
  }

  void _listenConnectionRecovered() {
    channel.client.on(EventType.connectionRecovered).listen((event) {
      if (!_isRetrying && event.online) {
        _startRetrying();
      }
    });
  }

  final HeapPriorityQueue<Message> _messageQueue = HeapPriorityQueue(_byDate);
  bool _isRetrying = false;
  RetryPolicy _retryPolicy;

  void add(List<Message> messages) {
    logger.info('add ${messages.length} messages');
    _messageQueue
        .addAll(messages.where((element) => !_messageQueue.contains(element)));

    if (_messageQueue.isNotEmpty && !_isRetrying) {
      _startRetrying();
    }
  }

  void clear() {
    _messageQueue.clear();
  }

  Future<void> _startRetrying() async {
    logger.info('start retrying');
    _isRetrying = true;
    final retryPolicy = _retryPolicy.copyWith(attempt: 0);

    while (_messageQueue.isNotEmpty) {
      final message = _messageQueue.first;
      try {
        logger.info('retry attempt ${retryPolicy.attempt}');
        await _sendMessage(message);
        _messageQueue.removeFirst();
        retryPolicy.attempt = 0;
      } catch (error) {
        ApiError apiError;
        if (error is DioError) {
          apiError = ApiError(
            error.response?.data,
            error.response?.statusCode,
          );
        } else if (error is ApiError) {
          apiError = error;
        }

        if (!retryPolicy.shouldRetry(
          channel.client,
          retryPolicy.attempt,
          apiError,
        )) {
          _sendFailedEvent(message);
          _isRetrying = false;
          return;
        }

        retryPolicy.attempt++;
        final timeout = retryPolicy.retryTimeout(
          channel.client,
          retryPolicy.attempt,
          apiError,
        );
        await Future.delayed(timeout);
      }
    }
    _isRetrying = false;
  }

  void _sendFailedEvent(Message message) {
    final newStatus = message.status == MessageSendingStatus.SENDING
        ? MessageSendingStatus.FAILED
        : (message.status == MessageSendingStatus.UPDATING
            ? MessageSendingStatus.FAILED_UPDATE
            : MessageSendingStatus.FAILED_DELETE);
    channel.client.handleEvent(Event(
      type: EventType.messageUpdated,
      message: message.copyWith(
        status: newStatus,
      ),
      cid: channel.cid,
    ));
  }

  Future<void> _sendMessage(Message message) async {
    if (message.status == MessageSendingStatus.FAILED_UPDATE ||
        message.status == MessageSendingStatus.UPDATING) {
      await channel.client.updateMessage(
        message,
        channel.cid,
      );
    } else if (message.status == MessageSendingStatus.FAILED ||
        message.status == MessageSendingStatus.SENDING) {
      await channel.sendMessage(
        message,
      );
    } else if (message.status == MessageSendingStatus.FAILED_DELETE ||
        message.status == MessageSendingStatus.DELETING) {
      await channel.client.deleteMessage(
        message,
        channel.cid,
      );
    }
  }

  void _listenFailedEvents() {
    channel.on().listen((event) {
      final messageList = _messageQueue.toList();
      if (event.message != null) {
        final messageIndex =
            messageList.indexWhere((m) => m.id == event.message.id);
        if (messageIndex == -1 &&
            [
              MessageSendingStatus.FAILED_UPDATE,
              MessageSendingStatus.FAILED,
              MessageSendingStatus.FAILED_DELETE,
            ].contains(event.message.status)) {
          logger.info('add message from events');
          add([event.message]);
        } else if (messageIndex != -1 &&
            [
              MessageSendingStatus.SENT,
              null,
            ].contains(event.message.status)) {
          _messageQueue.remove(messageList[messageIndex]);
        }
      }
    });
  }

  static int _byDate(Message m1, Message m2) {
    final date1 = _getMessageDate(m1);
    final date2 = _getMessageDate(m2);

    return date1.compareTo(date2);
  }

  static DateTime _getMessageDate(Message m1) {
    switch (m1.status) {
      case MessageSendingStatus.FAILED_DELETE:
      case MessageSendingStatus.DELETING:
        return m1.deletedAt;

      case MessageSendingStatus.FAILED:
      case MessageSendingStatus.SENDING:
        return m1.createdAt;

      case MessageSendingStatus.FAILED_UPDATE:
      case MessageSendingStatus.UPDATING:
        return m1.updatedAt;
      default:
        return null;
    }
  }
}
