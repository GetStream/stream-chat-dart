import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:logging/logging.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_chat/src/api/retry_queue.dart';
import 'package:stream_chat/src/event_type.dart';
import 'package:stream_chat/src/models/channel_state.dart';
import 'package:stream_chat/src/models/user.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:uuid/uuid.dart';

import '../client.dart';
import '../models/event.dart';
import '../models/member.dart';
import '../models/message.dart';
import 'requests.dart';
import 'responses.dart';

/// This a the class that manages a specific channel.
class Channel {
  /// Create a channel client instance.
  Channel(
    this._client,
    this.type,
    this._id,
    this._extraData,
  ) : _cid = _id != null ? '$type:$_id' : null {
    _client.logger.info('New Channel instance not initialized created');
  }

  /// Create a channel client instance from a [ChannelState] object
  Channel.fromState(this._client, ChannelState channelState) {
    _cid = channelState.channel.cid;
    _id = channelState.channel.id;
    type = channelState.channel.type;

    state = ChannelClientState(this, channelState);
    _initializedCompleter.complete(true);
    _startCleaning();

    _client.logger.info('New Channel instance initialized created');
  }

  /// This client state
  ChannelClientState state;

  /// The channel type
  String type;

  String _id;
  String _cid;
  Map<String, dynamic> _extraData;

  set extraData(Map<String, dynamic> extraData) {
    if (_initializedCompleter.isCompleted) {
      throw Exception(
          'Once the channel is initialized you should use channel.update to update channel data');
    }
    _extraData = extraData;
  }

  /// Returns true if the channel is muted
  bool get isMuted =>
      _client.state.user?.channelMutes
          ?.any((element) => element.channel.cid == cid) ==
      true;

  /// Returns true if the channel is muted as a stream
  Stream<bool> get isMutedStream => _client.state.userStream?.map((event) =>
      event.channelMutes?.any((element) => element.channel.cid == cid) == true);

  /// True if the channel is a group
  bool get isGroup => memberCount != 2;

  /// True if the channel is distinct
  bool get isDistinct => id?.startsWith('!members') == true;

  /// Channel configuration
  ChannelConfig get config => state?._channelState?.channel?.config;

  /// Channel configuration as a stream
  Stream<ChannelConfig> get configStream =>
      state?.channelStateStream?.map((cs) => cs.channel?.config);

  /// Channel user creator
  User get createdBy => state?._channelState?.channel?.createdBy;

  /// Channel user creator as a stream
  Stream<User> get createdByStream =>
      state?.channelStateStream?.map((cs) => cs.channel?.createdBy);

  /// Channel frozen status
  bool get frozen => state?._channelState?.channel?.frozen;

  /// Channel frozen status as a stream
  Stream<bool> get frozenStream =>
      state?.channelStateStream?.map((cs) => cs.channel?.frozen);

  /// Channel creation date
  DateTime get createdAt => state?._channelState?.channel?.createdAt;

  /// Channel creation date as a stream
  Stream<DateTime> get createdAtStream =>
      state?.channelStateStream?.map((cs) => cs.channel?.createdAt);

  /// Channel last message date
  DateTime get lastMessageAt => state?._channelState?.channel?.lastMessageAt;

  /// Channel last message date as a stream
  Stream<DateTime> get lastMessageAtStream =>
      state?.channelStateStream?.map((cs) => cs.channel?.lastMessageAt);

  /// Channel updated date
  DateTime get updatedAt => state?._channelState?.channel?.updatedAt;

  /// Channel updated date as a stream
  Stream<DateTime> get updatedAtStream =>
      state?.channelStateStream?.map((cs) => cs.channel?.updatedAt);

  /// Channel deletion date
  DateTime get deletedAt => state?._channelState?.channel?.deletedAt;

  /// Channel deletion date as a stream
  Stream<DateTime> get deletedAtStream =>
      state?.channelStateStream?.map((cs) => cs.channel?.deletedAt);

  /// Channel member count
  int get memberCount => state?._channelState?.channel?.memberCount;

  /// Channel member count as a stream
  Stream<int> get memberCountStream =>
      state?.channelStateStream?.map((cs) => cs.channel?.memberCount);

  /// Channel id
  String get id => state?._channelState?.channel?.id ?? _id;

  /// Channel id as a stream
  Stream<String> get idStream =>
      state?.channelStateStream?.map((cs) => cs.channel?.id ?? _id);

  /// Channel cid
  String get cid => state?._channelState?.channel?.cid ?? _cid;

  /// Channel team
  String get team => state?._channelState?.channel?.team;

  /// Channel cid as a stream
  Stream<String> get cidStream =>
      state?.channelStateStream?.map((cs) => cs.channel?.cid ?? _cid);

  /// Channel extra data
  Map<String, dynamic> get extraData =>
      state?._channelState?.channel?.extraData;

  /// Channel extra data as a stream
  Stream<Map<String, dynamic>> get extraDataStream =>
      state?.channelStateStream?.map((cs) => cs.channel?.extraData);

  /// The main Stream chat client
  Client get client => _client;
  final Client _client;

  String get _channelURL => '/channels/$type/$id';

  final Completer<bool> _initializedCompleter = Completer();

  /// True if this is initialized
  /// Call [watch] to initialize the client or instantiate it using [Channel.fromState]
  Future<bool> get initialized => _initializedCompleter.future;

  /// Send a message to this channel
  Future<SendMessageResponse> sendMessage(Message message) async {
    final messageId = message.id ?? Uuid().v4();
    final quotedMessage = state?.messages?.firstWhere(
      (m) => m.id == message?.quotedMessageId,
      orElse: () => null,
    );
    final newMessage = message.copyWith(
      createdAt: message.createdAt ?? DateTime.now(),
      user: _client.state.user,
      id: messageId,
      quotedMessage: quotedMessage,
      status: MessageSendingStatus.SENDING,
    );

    if (message.parentId != null && message.id == null) {
      final parentMessage =
          state.messages.firstWhere((m) => m.id == message.parentId);

      state?.addMessage(parentMessage.copyWith(
        replyCount: parentMessage.replyCount + 1,
      ));
    }

    state?.addMessage(newMessage);

    try {
      final response = await _client.post(
        '$_channelURL/message',
        data: {
          'message': message
              .copyWith(
                id: messageId,
              )
              .toJson()
        },
      );

      final res = _client.decode(response.data, SendMessageResponse.fromJson);

      state?.addMessage(res.message);

      return res;
    } catch (error) {
      if (error is DioError && error.type != DioErrorType.RESPONSE) {
        state?.retryQueue?.add([newMessage]);
      }
      rethrow;
    }
  }

  /// Send a file to this channel
  Future<SendFileResponse> sendFile(MultipartFile file) async {
    final response = await _client.post(
      '$_channelURL/file',
      data: FormData.fromMap({'file': file}),
    );
    return _client.decode(response.data, SendFileResponse.fromJson);
  }

  /// Send an image to this channel
  Future<SendImageResponse> sendImage(MultipartFile file) async {
    final response = await _client.post(
      '$_channelURL/image',
      data: FormData.fromMap({'file': file}),
    );
    return _client.decode(response.data, SendImageResponse.fromJson);
  }

  /// Delete a file from this channel
  Future<EmptyResponse> deleteFile(String url) async {
    final response = await _client
        .delete('$_channelURL/file', queryParameters: {'url': url});
    return _client.decode(response.data, EmptyResponse.fromJson);
  }

  /// Delete an image from this channel
  Future<EmptyResponse> deleteImage(String url) async {
    final response = await _client
        .delete('$_channelURL/image', queryParameters: {'url': url});
    return _client.decode(response.data, EmptyResponse.fromJson);
  }

  /// Send an event on this channel
  Future<EmptyResponse> sendEvent(Event event) {
    _checkInitialized();
    return _client.post(
      '$_channelURL/event',
      data: {'event': event.toJson()},
    ).then((res) {
      return _client.decode(res.data, EmptyResponse.fromJson);
    });
  }

  /// Send a reaction to this channel
  /// Set [enforceUnique] to true to remove the existing user reaction
  Future<SendReactionResponse> sendReaction(
    Message message,
    String type, {
    Map<String, dynamic> extraData = const {},
    bool enforceUnique = false,
  }) async {
    final messageId = message.id;
    final data = Map<String, dynamic>.from(extraData)
      ..addAll({
        'type': type,
      });

    final res = await _client.post(
      '/messages/$messageId/reaction',
      data: {
        'reaction': data,
        'enforce_unique': enforceUnique,
      },
    );
    return _client.decode(res.data, SendReactionResponse.fromJson);
  }

  /// Delete a reaction from this channel
  Future<EmptyResponse> deleteReaction(Message message, Reaction reaction) {
    _checkInitialized();

    return client
        .delete('/messages/${message.id}/reaction/${reaction.type}')
        .then((res) => _client.decode(res.data, EmptyResponse.fromJson));
  }

  /// Edit the channel custom data
  Future<UpdateChannelResponse> update(
    Map<String, dynamic> channelData, [
    Message updateMessage,
  ]) async {
    final response = await _client.post(_channelURL, data: {
      if (updateMessage != null)
        'message': updateMessage.copyWith(updatedAt: DateTime.now()).toJson(),
      'data': channelData,
    });
    return _client.decode(response.data, UpdateChannelResponse.fromJson);
  }

  /// Delete this channel. Messages are permanently removed.
  Future<EmptyResponse> delete() async {
    final response = await _client.delete(_channelURL);
    return _client.decode(response.data, EmptyResponse.fromJson);
  }

  /// Removes all messages from the channel
  Future<EmptyResponse> truncate() async {
    final response = await _client.post('$_channelURL/truncate');
    return _client.decode(response.data, EmptyResponse.fromJson);
  }

  /// Accept invitation to the channel
  Future<AcceptInviteResponse> acceptInvite([Message message]) async {
    final res = await _client.post(_channelURL,
        data: {'accept_invite': true, 'message': message?.toJson()});
    return _client.decode(res.data, AcceptInviteResponse.fromJson);
  }

  /// Reject invitation to the channel
  Future<RejectInviteResponse> rejectInvite([Message message]) async {
    final res = await _client.post(_channelURL,
        data: {'reject_invite': true, 'message': message?.toJson()});
    return _client.decode(res.data, RejectInviteResponse.fromJson);
  }

  /// Add members to the channel
  Future<AddMembersResponse> addMembers(
    List<String> memberIds, [
    Message message,
  ]) async {
    final res = await _client.post(_channelURL, data: {
      'add_members': memberIds,
      'message': message?.toJson(),
    });
    return _client.decode(res.data, AddMembersResponse.fromJson);
  }

  /// Invite members to the channel
  Future<InviteMembersResponse> inviteMembers(
    List<String> memberIds, [
    Message message,
  ]) async {
    final res = await _client.post(_channelURL, data: {
      'invites': memberIds,
      'message': message?.toJson(),
    });
    return _client.decode(res.data, InviteMembersResponse.fromJson);
  }

  /// Remove members from the channel
  Future<RemoveMembersResponse> removeMembers(
    List<String> memberIds, [
    Message message,
  ]) async {
    final res = await _client.post(_channelURL, data: {
      'remove_members': memberIds,
      'message': message?.toJson(),
    });
    return _client.decode(res.data, RemoveMembersResponse.fromJson);
  }

  /// Send action for a specific message of this channel
  Future<SendActionResponse> sendAction(
    Message message,
    Map<String, dynamic> formData,
  ) async {
    _checkInitialized();

    final messageId = message.id;
    final response = await _client.post('/messages/$messageId/action', data: {
      'id': id,
      'type': type,
      'form_data': formData,
      'message_id': messageId,
    });

    final res = _client.decode(response.data, SendActionResponse.fromJson);

    if (res.message != null) {
      state.addMessage(res.message);
    } else {
      final oldIndex = state.messages?.indexWhere((m) => m.id == messageId);

      Message oldMessage;
      if (oldIndex != null && oldIndex != -1) {
        oldMessage = state.messages[oldIndex];
        state.updateChannelState(state._channelState.copyWith(
          messages: state.messages..remove(oldMessage),
        ));
      } else {
        oldMessage = state.threads.values
            .expand((messages) => messages)
            .firstWhere((m) => m.id == messageId, orElse: () => null);
        if (oldMessage?.parentId != null) {
          final parentMessage = state.messages.firstWhere(
            (element) => element.id == oldMessage.parentId,
            orElse: () => null,
          );
          if (parentMessage != null) {
            state.addMessage(parentMessage.copyWith(
                replyCount: parentMessage.replyCount - 1));
          }
          state.updateThreadInfo(oldMessage.parentId,
              state.threads[oldMessage.parentId]..remove(oldMessage));
        }
      }

      await _client.offlineStorage?.deleteMessages([messageId]);
    }

    return res;
  }

  /// Mark all channel messages as read
  Future<EmptyResponse> markRead() async {
    _checkInitialized();
    client.state.totalUnreadCount =
        max(0, (client.state.totalUnreadCount ?? 0) - (state.unreadCount ?? 0));
    state._unreadCountController.add(0);
    final response = await _client.post('$_channelURL/read', data: {});
    return _client.decode(response.data, EmptyResponse.fromJson);
  }

  /// Loads the initial channel state and watches for changes
  Future<ChannelState> watch([Map<String, dynamic> options = const {}]) async {
    final watchOptions = Map<String, dynamic>.from({
      'state': true,
      'watch': true,
      'presence': false,
    })
      ..addAll(options);

    var response;

    try {
      response = await query(options: watchOptions);
    } catch (error, stackTrace) {
      if (!_initializedCompleter.isCompleted) {
        _initializedCompleter.completeError(error, stackTrace);
      }
      rethrow;
    }

    if (state == null) {
      _initState(response);
    }

    return response;
  }

  void _initState(ChannelState channelState) {
    state = ChannelClientState(this, channelState);
    client.state.channels[cid] = this;
    if (!_initializedCompleter.isCompleted) {
      _initializedCompleter.complete(true);
    }
    _startCleaning();
  }

  /// Stop watching the channel
  Future<EmptyResponse> stopWatching() async {
    final response = await _client.post(
      '$_channelURL/stop-watching',
      data: {},
    );
    return _client.decode(response?.data, EmptyResponse.fromJson);
  }

  /// List the message replies for a parent message
  /// Set [preferOffline] to true to avoid the api call if the data is already in the offline storage
  Future<QueryRepliesResponse> getReplies(
    String parentId,
    PaginationParams options, {
    bool preferOffline = false,
  }) async {
    final cachedReplies = await _client.offlineStorage?.getReplies(
      parentId,
      lessThan: options?.lessThan,
    );
    if (cachedReplies != null && cachedReplies.isNotEmpty) {
      state?.updateThreadInfo(parentId, cachedReplies);
      if (preferOffline) {
        return QueryRepliesResponse()..messages = cachedReplies;
      }
    }

    final response = await _client.get('/messages/$parentId/replies',
        queryParameters: options.toJson());

    final repliesResponse = _client.decode<QueryRepliesResponse>(
      response.data,
      QueryRepliesResponse.fromJson,
    );

    state?.updateThreadInfo(parentId, repliesResponse.messages);

    return repliesResponse;
  }

  /// List the reactions for a message in the channel
  Future<QueryReactionsResponse> getReactions(
    String messageID,
    PaginationParams options,
  ) async {
    final response = await _client.get(
      '/messages/$messageID/reactions',
      queryParameters: options.toJson(),
    );
    return _client.decode<QueryReactionsResponse>(
        response.data, QueryReactionsResponse.fromJson);
  }

  /// Retrieves a list of messages by ID
  Future<GetMessagesByIdResponse> getMessagesById(
      List<String> messageIDs) async {
    final response = await _client.get(
      '$_channelURL/messages',
      queryParameters: {'ids': messageIDs.join(',')},
    );

    final res = _client.decode<GetMessagesByIdResponse>(
      response.data,
      GetMessagesByIdResponse.fromJson,
    );

    state?.updateChannelState(ChannelState(messages: res.messages));

    return res;
  }

  /// Retrieves a list of messages by ID
  Future<TranslateMessageResponse> translateMessage(
    String messageId,
    String language,
  ) async {
    final response = await _client.post(
      '/messages/$messageId/translate',
      data: {
        'language': language,
      },
    );
    return _client.decode<TranslateMessageResponse>(
      response.data,
      TranslateMessageResponse.fromJson,
    );
  }

  /// Creates a new channel
  Future<ChannelState> create() async {
    return query(options: {
      'watch': false,
      'state': false,
      'presence': false,
    });
  }

  /// Query the API, get messages, members or other channel fields
  /// Set [preferOffline] to true to avoid the api call if the data is already in the offline storage
  Future<ChannelState> query({
    Map<String, dynamic> options = const {},
    PaginationParams messagesPagination,
    PaginationParams membersPagination,
    PaginationParams watchersPagination,
    bool preferOffline = false,
  }) async {
    var path = '/channels/$type';
    if (id != null) {
      path = '$path/$id';
    }
    path = '$path/query';

    final payload = Map<String, dynamic>.from({
      'state': true,
    })
      ..addAll(options);

    if (_extraData != null) {
      payload['data'] = _extraData;
    }

    if (messagesPagination != null) {
      payload['messages'] = messagesPagination.toJson();
    }
    if (membersPagination != null) {
      payload['members'] = membersPagination.toJson();
    }
    if (watchersPagination != null) {
      payload['watchers'] = watchersPagination.toJson();
    }

    if (preferOffline && cid != null) {
      final updatedState = await _client.offlineStorage?.getChannel(
        cid,
        limit: messagesPagination?.limit,
        messageLessThan: messagesPagination?.lessThan,
        messageGreaterThan: messagesPagination?.greaterThan,
      );
      if (updatedState != null && updatedState.messages.isNotEmpty) {
        if (state == null) {
          _initState(updatedState);
        } else {
          state?.updateChannelState(updatedState);
        }
        return updatedState;
      }
    }

    final response = await _client.post(path, data: payload);
    final updatedState = _client.decode(response.data, ChannelState.fromJson);

    if (_id == null) {
      _id = updatedState.channel.id;
      _cid = updatedState.channel.cid;
    }

    state?.updateChannelState(updatedState);
    return updatedState;
  }

  /// Query channel members
  Future<QueryMembersResponse> queryMembers({
    Map<String, dynamic> filter,
    List<SortOption> sort,
    PaginationParams pagination,
  }) async {
    final payload = <String, dynamic>{
      'sort': sort,
      'filter_conditions': filter,
      'type': type,
    };

    if (pagination != null) {
      payload.addAll(pagination.toJson());
    }

    if (id != null) {
      payload['id'] = id;
    } else if (state?.members?.isNotEmpty == true) {
      payload['members'] = state.members;
    }

    final rawRes = await _client.get('/members', queryParameters: {
      'payload': jsonEncode(payload),
    });
    final response = _client.decode(rawRes.data, QueryMembersResponse.fromJson);
    return response;
  }

  /// Mutes the channel
  Future<EmptyResponse> mute({Duration expiration}) async {
    final response = await _client.post('/moderation/mute/channel', data: {
      'channel_cid': cid,
      if (expiration != null) 'expiration': expiration.inMilliseconds,
    });
    return _client.decode(response.data, EmptyResponse.fromJson);
  }

  /// Unmutes the channel
  Future<EmptyResponse> unmute() async {
    final response = await _client.post('/moderation/unmute/channel', data: {
      'channel_cid': cid,
    });
    return _client.decode(response.data, EmptyResponse.fromJson);
  }

  /// Bans a user from the channel
  Future<EmptyResponse> banUser(
    String userID,
    Map<String, dynamic> options,
  ) async {
    _checkInitialized();
    final opts = Map<String, dynamic>.from(options)
      ..addAll({
        'type': type,
        'id': id,
      });
    return _client.banUser(userID, opts);
  }

  /// Remove the ban for a user in the channel
  Future<EmptyResponse> unbanUser(String userID) async {
    _checkInitialized();
    return _client.unbanUser(userID, {
      'type': type,
      'id': id,
    });
  }

  /// Shadow bans a user from the channel
  Future<EmptyResponse> shadowBan(
    String userID,
    Map<String, dynamic> options,
  ) async {
    _checkInitialized();
    final opts = Map<String, dynamic>.from(options)
      ..addAll({
        'type': type,
        'id': id,
      });
    return _client.shadowBan(userID, opts);
  }

  /// Remove the shadow ban for a user in the channel
  Future<EmptyResponse> removeShadowBan(String userID) async {
    _checkInitialized();
    return _client.removeShadowBan(userID, {
      'type': type,
      'id': id,
    });
  }

  /// Hides the channel from [Client.queryChannels] for the user until a message is added
  ///	If [clearHistory] is set to true - all messages will be removed for the user
  Future<EmptyResponse> hide({bool clearHistory = false}) async {
    _checkInitialized();
    final response = await _client
        .post('$_channelURL/hide', data: {'clear_history': clearHistory});

    if (clearHistory == true) {
      state.truncate();
      await _client.offlineStorage?.deleteChannelsMessages([_cid]);
    }

    return _client.decode(response.data, EmptyResponse.fromJson);
  }

  /// Removes the hidden status for the channel
  Future<EmptyResponse> show() async {
    _checkInitialized();
    final response = await _client.post('$_channelURL/show');
    return _client.decode(response.data, EmptyResponse.fromJson);
  }

  /// Stream of [Event] coming from websocket connection specific for the channel
  /// Pass an eventType as parameter in order to filter just a type of event
  Stream<Event> on([
    String eventType,
    String eventType2,
    String eventType3,
    String eventType4,
  ]) {
    return _client
        .on(
          eventType,
          eventType2,
          eventType3,
          eventType4,
        )
        .where((e) => e.cid == cid);
  }

  DateTime _lastTypingEvent;

  /// First of the [EventType.typingStart] and [EventType.typingStop] events based on the users keystrokes.
  /// Call this on every keystroke.
  Future<void> keyStroke([String parentId]) async {
    if (config?.typingEvents == false) {
      return;
    }

    client.logger.info('start typing');
    final now = DateTime.now();

    if (_lastTypingEvent == null ||
        now.difference(_lastTypingEvent).inSeconds >= 2) {
      _lastTypingEvent = now;
      await sendEvent(Event(
        type: EventType.typingStart,
        parentId: parentId,
      ));
    }
  }

  /// Sets last typing to null and sends the typing.stop event
  Future<void> stopTyping([String parentId]) async {
    if (config?.typingEvents == false) {
      return;
    }

    client.logger.info('stop typing');
    _lastTypingEvent = null;
    await sendEvent(Event(
      type: EventType.typingStop,
      parentId: parentId,
    ));
  }

  Timer _cleaningTimer;

  void _startCleaning() {
    if (config?.typingEvents == false) {
      return;
    }

    _cleaningTimer = Timer.periodic(Duration(milliseconds: 500), (_) {
      final now = DateTime.now();

      if (_lastTypingEvent != null &&
          now.difference(_lastTypingEvent).inSeconds > 1) {
        stopTyping();
      }

      state._clean();
    });
  }

  /// Call this method to dispose the channel client
  void dispose() {
    _cleaningTimer.cancel();
    state.dispose();
  }

  void _checkInitialized() {
    if (!_initializedCompleter.isCompleted) {
      throw Exception(
          "Channel $cid hasn't been initialized yet. Make sure to call .watch() or to instantiate the client using [Channel.fromState]");
    }
  }
}

/// The class that handles the state of the channel listening to the events
class ChannelClientState {
  final _subscriptions = <StreamSubscription>[];

  /// Creates a new instance listening to events and updating the state
  ChannelClientState(this._channel, ChannelState channelState) {
    retryQueue = RetryQueue(
      channel: _channel,
      logger: Logger('RETRY QUEUE ${_channel.cid}'),
    );

    _checkExpiredAttachmentMessages(channelState);

    _channelStateController = BehaviorSubject.seeded(channelState);

    _listenTypingEvents();

    _listenMessageNew();

    _listenMessageDeleted();

    _listenMessageUpdated();

    _listenReactions();

    _listenReactionDeleted();

    _listenReadEvents();

    _listenChannelTruncated();

    _listenChannelUpdated();

    _listenMemberAdded();

    _listenMemberRemoved();

    _computeInitialUnread();

    _channel._client.offlineStorage
        ?.getChannelThreads(_channel.cid)
        ?.then((threads) {
      _threads = threads;
      retryFailedMessages();
    });
  }

  void _computeInitialUnread() {
    final userRead = channelState?.read?.firstWhere(
      (r) => r.user.id == _channel._client.state?.user?.id,
      orElse: () => null,
    );
    if (userRead != null) {
      _unreadCountController.add(userRead.unreadMessages ?? 0);
    }
  }

  void _checkExpiredAttachmentMessages(ChannelState channelState) {
    final expiredAttachmentMessagesId = channelState.messages
        ?.where((m) =>
            !_updatedMessagesIds.contains(m.id) &&
            m.attachments?.isNotEmpty == true &&
            m.attachments?.any((e) {
                  final url = e.imageUrl ?? e.assetUrl;
                  if (url == null || !url.contains('stream-io-cdn.com')) {
                    return false;
                  }
                  final expiration =
                      DateTime.parse(Uri.parse(url).queryParameters['Expires']);
                  return expiration.isBefore(DateTime.now());
                }) ==
                true)
        ?.map((e) => e.id)
        ?.toList();
    if (expiredAttachmentMessagesId?.isNotEmpty == true) {
      _channel.getMessagesById(expiredAttachmentMessagesId);
      _updatedMessagesIds.addAll(expiredAttachmentMessagesId);
    }
  }

  void _listenMemberAdded() {
    _subscriptions.add(_channel.on(EventType.memberAdded).listen((Event e) {
      final member = e.member;
      updateChannelState(channelState.copyWith(
        members: [
          ...channelState.members,
          member,
        ],
      ));
    }));
  }

  void _listenMemberRemoved() {
    _subscriptions.add(_channel.on(EventType.memberRemoved).listen((Event e) {
      final user = e.user;
      updateChannelState(channelState.copyWith(
        members: List.from(
            channelState.members..removeWhere((m) => m.userId == user.id)),
      ));
    }));
  }

  void _listenChannelUpdated() {
    _subscriptions.add(_channel.on(EventType.channelUpdated).listen((Event e) {
      final channel = e.channel;
      updateChannelState(channelState.copyWith(
        channel: channel,
        members: channel.members,
      ));
    }));
  }

  void _listenChannelTruncated() {
    _subscriptions.add(_channel
        .on(EventType.channelTruncated, EventType.notificationChannelTruncated)
        .listen((event) async {
      final channel = event.channel;
      await _channel._client.offlineStorage
          ?.deleteChannelsMessages([channel.cid]);
      truncate();
    }));
  }

  /// Flag which indicates if [ChannelClientState] contain latest/recent messages or not.
  /// This flag should be managed by UI sdks.
  /// When false, any new message (received by WebSocket event - [EventType.messageNew]) will not
  /// be pushed on to message list.
  bool get isUpToDate => _isUpToDateController.value;

  set isUpToDate(bool isUpToDate) => _isUpToDateController.add(isUpToDate);

  /// [isUpToDate] flag count as a stream
  Stream<bool> get isUpToDateStream => _isUpToDateController.stream;

  final BehaviorSubject<bool> _isUpToDateController =
      BehaviorSubject.seeded(true);

  /// The retry queue associated to this channel
  RetryQueue retryQueue;

  /// Retry failed message
  Future<void> retryFailedMessages() async {
    final failedMessages =
        <Message>[...messages, ...threads.values.expand((v) => v)]
            .where((message) =>
                message.status != null &&
                message.status != MessageSendingStatus.SENT &&
                message.createdAt.isBefore(DateTime.now().subtract(Duration(
                  seconds: 1,
                ))))
            .toList();

    retryQueue.add(failedMessages);
  }

  void _listenReactionDeleted() {
    _subscriptions.add(_channel.on(EventType.reactionDeleted).listen((event) {
      final reaction = event.reaction;
      final message = event.message;
      _removeMessageReaction(message, reaction);
    }));
  }

  void _removeMessageReaction(Message message, Reaction reaction) {
    if (message.parentId == null || message.showInChannel == true) {
      _channelState = _channelState.copyWith(
        messages: _channelState?.messages?.map((m) {
          if (m.id == message.id) {
            return _removeReactionFromMessage(m, reaction);
          }
          return m;
        })?.toList(),
      );
    }

    if (message.parentId != null) {
      final newThreads = threads;
      if (newThreads.containsKey(message.parentId)) {
        newThreads[message.parentId] = newThreads[message.parentId].map((m) {
          if (m.id == message.id) {
            return _removeReactionFromMessage(m, reaction);
          }
          return m;
        }).toList();
        _threads = newThreads;
      }
    }
  }

  void _listenReactions() {
    _subscriptions.add(_channel
        .on(
      EventType.reactionNew,
    )
        .listen((event) {
      final message = event.message;
      _addMessageReaction(message, event.reaction);
    }));
  }

  void _addMessageReaction(Message message, Reaction reaction) {
    if (message.parentId == null || message.showInChannel == true) {
      _channelState = _channelState.copyWith(
        messages: _channelState.messages.map((m) {
          if (message.id == m.id) {
            return _addReactionToMessage(m, reaction);
          }
          return m;
        }).toList(),
      );
    }

    if (message.parentId != null) {
      final newThreads = threads;
      if (newThreads.containsKey(message.parentId)) {
        newThreads[message.parentId] = newThreads[message.parentId].map((m) {
          if (message.id == m.id) {
            return _addReactionToMessage(m, reaction);
          }
          return m;
        }).toList();
        _threads = newThreads;
      }
    }
  }

  void _listenMessageUpdated() {
    _subscriptions.add(_channel
        .on(
      EventType.messageUpdated,
      EventType.reactionUpdated,
    )
        .listen((event) {
      final message = event.message;
      addMessage(message.copyWith(
        ownReactions: message.latestReactions
            .where(
                (element) => element.user?.id == _channel._client.state.user.id)
            .toList(),
      ));
    }));
  }

  void _listenMessageDeleted() {
    _subscriptions.add(_channel.on(EventType.messageDeleted).listen((event) {
      final message = event.message;
      addMessage(message);
    }));
  }

  void _listenMessageNew() {
    _subscriptions.add(_channel
        .on(
      EventType.messageNew,
      EventType.notificationMessageNew,
    )
        .listen((event) {
      final message = event.message;
      if (isUpToDate ||
          (message.parentId != null && message.showInChannel != true)) {
        addMessage(message);
      }

      if (_countMessageAsUnread(message)) {
        _unreadCountController.add(_unreadCountController.value + 1);
      }
    }));
  }

  /// Add a message to this channel
  void addMessage(Message message) {
    if (message.parentId == null || message.showInChannel == true) {
      final newMessages = List<Message>.from(_channelState.messages);

      final oldIndex = newMessages.indexWhere((m) => m.id == message.id);
      if (oldIndex != -1) {
        newMessages[oldIndex] = newMessages[oldIndex].copyWith(
          text: message.text,
          type: message.type,
          attachments: message.attachments,
          mentionedUsers: message.mentionedUsers,
          reactionCounts: message.reactionCounts,
          reactionScores: message.reactionScores,
          latestReactions: message.latestReactions,
          ownReactions: message.ownReactions,
          parentId: message.parentId,
          quotedMessageId: message.quotedMessageId,
          quotedMessage: message.quotedMessage,
          replyCount: message.replyCount,
          showInChannel: message.showInChannel,
          command: message.command,
          silent: message.silent,
          createdAt: message.createdAt,
          updatedAt: message.updatedAt,
          deletedAt: message.deletedAt,
          user: message.user,
          status: message.status,
          threadParticipants: message.threadParticipants,
          extraData: message.extraData,
        );
      } else {
        newMessages.add(message);
      }

      _channelState = _channelState.copyWith(
        messages: newMessages,
        channel: _channelState.channel.copyWith(
          lastMessageAt: message.createdAt,
        ),
      );
    }

    if (message.parentId != null) {
      updateThreadInfo(message.parentId, [message]);
    }
  }

  void _listenReadEvents() {
    if (_channel.config?.readEvents == false) {
      return;
    }

    _subscriptions.add(_channel
        .on(
      EventType.messageRead,
      EventType.notificationMarkRead,
    )
        .listen((event) {
      final readList = List<Read>.from(_channelState?.read ?? []);
      final userReadIndex = read?.indexWhere((r) => r.user.id == event.user.id);

      if (userReadIndex != null && userReadIndex != -1) {
        final userRead = readList.removeAt(userReadIndex);
        if (userRead.user?.id == _channel._client.state.user.id) {
          _unreadCountController.add(0);
        }
        readList.add(Read(
          user: event.user,
          lastRead: event.createdAt,
        ));
        _channelState = _channelState.copyWith(read: readList);
      }
    }));
  }

  Message _addReactionToMessage(Message message, Reaction reaction) {
    final newMessage = message.copyWith(
      latestReactions: message.latestReactions..add(reaction),
      reactionCounts: {
        ...message.reactionCounts ?? {},
        reaction.type: (message.reactionCounts == null
                ? 0
                : message.reactionCounts[reaction.type] ?? 0) +
            1,
      },
      reactionScores: {
        ...message.reactionScores ?? {},
        reaction.type: (message.reactionScores == null
                ? 0
                : message.reactionScores[reaction.type] ?? 0) +
            reaction.score,
      },
    );

    if (reaction.user.id == _channel.client.state.user.id) {
      return newMessage.copyWith(
        ownReactions: message.ownReactions..add(reaction),
      );
    }

    return newMessage;
  }

  Message _removeReactionFromMessage(Message message, Reaction reaction) {
    final newMessage = message.copyWith(
      latestReactions: message.latestReactions
        ..removeWhere(
            (r) => r.type == reaction.type && r.userId == reaction.userId),
      reactionCounts: {
        ...message.reactionCounts,
        reaction.type: (message.reactionCounts[reaction.type] ?? 0) - 1,
      },
      reactionScores: {
        ...message.reactionScores ?? {},
        reaction.type: max(
            (message.reactionScores == null
                    ? 0
                    : message.reactionScores[reaction.type] ?? 0) -
                reaction.score,
            0),
      },
    );

    newMessage.reactionCounts.removeWhere((_, v) => v <= 0);

    if (reaction.user.id == _channel.client.state.user.id) {
      return newMessage.copyWith(
        ownReactions: message.ownReactions
          ..removeWhere((r) => r.type == reaction.type),
      );
    }

    return newMessage;
  }

  /// Channel message list
  List<Message> get messages => _channelState.messages;

  /// Channel message list as a stream
  Stream<List<Message>> get messagesStream =>
      channelStateStream.map((cs) => cs.messages);

  /// Get channel last message
  Message get lastMessage => _channelState.messages?.isNotEmpty == true
      ? _channelState.messages.last
      : null;

  /// Get channel last message
  Stream<Message> get lastMessageStream => messagesStream
      .map((event) => event?.isNotEmpty == true ? event.last : null);

  /// Channel members list
  List<Member> get members => _channelState.members
      .map((e) => e.copyWith(user: _channel.client.state.users[e.user.id]))
      .toList();

  /// Channel members list as a stream
  Stream<List<Member>> get membersStream => CombineLatestStream.combine2<
          List<Member>, Map<String, User>, List<Member>>(
        channelStateStream.map((cs) => cs.members),
        _channel.client.state.usersStream,
        (members, users) {
          return members
              .map((e) => e.copyWith(user: users[e.user.id]))
              .toList();
        },
      );

  /// Channel watcher count
  int get watcherCount => _channelState.watcherCount;

  /// Channel watcher count as a stream
  Stream<int> get watcherCountStream =>
      channelStateStream.map((cs) => cs.watcherCount);

  /// Channel watchers list
  List<User> get watchers => _channelState.watchers
      .map((e) => _channel.client.state.users[e.id] ?? e)
      .toList();

  /// Channel watchers list as a stream
  Stream<List<User>> get watchersStream =>
      CombineLatestStream.combine2<List<User>, Map<String, User>, List<User>>(
        channelStateStream.map((cs) => cs.watchers),
        _channel.client.state.usersStream,
        (watchers, users) {
          return watchers.map((e) => users[e.id] ?? e).toList();
        },
      );

  /// Channel read list
  List<Read> get read => _channelState.read;

  /// Channel read list as a stream
  Stream<List<Read>> get readStream => channelStateStream.map((cs) => cs.read);

  final BehaviorSubject<int> _unreadCountController = BehaviorSubject.seeded(0);

  /// Unread count getter as a stream
  Stream<int> get unreadCountStream => _unreadCountController.stream;

  /// Unread count getter
  int get unreadCount => _unreadCountController.value;

  bool _countMessageAsUnread(Message message) {
    final userId = _channel.client.state?.user?.id;
    final userIsMuted = _channel.client.state.user.mutes.firstWhere(
          (m) => m.user?.id == message.user.id,
          orElse: () => null,
        ) !=
        null;
    return message.silent != true &&
        message.shadowed != true &&
        message.user.id != userId &&
        !userIsMuted;
  }

  /// Update threads with updated information about messages
  void updateThreadInfo(String parentId, List<Message> messages) {
    final newThreads = Map<String, List<Message>>.from(threads);

    if (newThreads.containsKey(parentId)) {
      newThreads[parentId] = [
        ...newThreads[parentId]
                ?.where(
                    (newMessage) => !messages.any((m) => m.id == newMessage.id))
                ?.toList() ??
            [],
        ...messages,
      ];

      newThreads[parentId].sort(_sortByCreatedAt);
    } else {
      newThreads[parentId] = messages;
    }

    _threads = newThreads;
  }

  /// Delete all channel messages
  void truncate() {
    _channelState = _channelState.copyWith(
      messages: [],
    );
  }

  final List<String> _updatedMessagesIds = [];

  /// Update channelState with updated information
  void updateChannelState(ChannelState updatedState) {
    final newMessages = <Message>[
      ...updatedState?.messages ?? [],
      ..._channelState?.messages
              ?.where((m) =>
                  updatedState.messages
                      ?.any((newMessage) => newMessage.id == m.id) !=
                  true)
              ?.toList() ??
          [],
    ];

    newMessages.sort(_sortByCreatedAt);

    final newWatchers = <User>[
      ...updatedState?.watchers ?? [],
      ..._channelState?.watchers
              ?.where((w) =>
                  updatedState.watchers
                      ?.any((newWatcher) => newWatcher.id == w.id) !=
                  true)
              ?.toList() ??
          [],
    ];

    final newMembers = <Member>[
      ...updatedState?.members ?? [],
    ];

    final newReads = <Read>[
      ...updatedState?.read ?? [],
      ..._channelState?.read
              ?.where((r) =>
                  updatedState.read
                      ?.any((newRead) => newRead.user.id == r.user.id) !=
                  true)
              ?.toList() ??
          [],
    ];

    _checkExpiredAttachmentMessages(updatedState);

    _channelState = _channelState.copyWith(
      messages: newMessages,
      channel: _channelState.channel?.copyWith(
        lastMessageAt: updatedState.channel?.lastMessageAt,
        createdAt: updatedState.channel?.createdAt,
        type: updatedState.channel?.type,
        extraData: updatedState.channel?.extraData,
        updatedAt: updatedState.channel?.updatedAt,
        id: updatedState.channel?.id,
        createdBy: updatedState.channel?.createdBy,
        config: updatedState.channel?.config,
        deletedAt: updatedState.channel?.deletedAt,
        cid: updatedState.channel?.cid,
        frozen: updatedState.channel?.frozen,
        memberCount: updatedState.channel?.memberCount,
      ),
      watchers: newWatchers,
      watcherCount: updatedState.watcherCount,
      members: newMembers,
      read: newReads,
    );
  }

  int _sortByCreatedAt(a, b) {
    if (a.createdAt == null) {
      return 1;
    }

    if (b.createdAt == null) {
      return -1;
    }

    return a.createdAt.compareTo(b.createdAt);
  }

  /// The channel state related to this client
  ChannelState get _channelState => _channelStateController.value;

  /// The channel state related to this client as a stream
  Stream<ChannelState> get channelStateStream => _channelStateController.stream;

  /// The channel state related to this client
  ChannelState get channelState => _channelStateController.value;
  BehaviorSubject<ChannelState> _channelStateController;

  set _channelState(ChannelState v) {
    _channelStateController.add(v);
    _channel._client.offlineStorage?.updateChannelState(v);
  }

  /// The channel threads related to this channel
  Map<String, List<Message>> get threads => _threadsController.value;

  /// The channel threads related to this channel as a stream
  Stream<Map<String, List<Message>>> get threadsStream =>
      _threadsController.stream;
  final BehaviorSubject<Map<String, List<Message>>> _threadsController =
      BehaviorSubject.seeded({});

  set _threads(Map<String, List<Message>> v) {
    _channel._client.offlineStorage?.updateMessages(
      v.values.expand((v) => v).toList(),
      _channel.cid,
    );
    _threadsController.add(v);
  }

  /// Channel related typing users last value
  List<User> get typingEvents => _typingEventsController.value;

  /// Channel related typing users stream
  Stream<List<User>> get typingEventsStream => _typingEventsController.stream;
  final BehaviorSubject<List<User>> _typingEventsController =
      BehaviorSubject.seeded([]);

  final Channel _channel;
  final Map<User, DateTime> _typings = {};

  void _listenTypingEvents() {
    if (_channel.config?.typingEvents == false) {
      return;
    }

    _subscriptions.add(_channel.on(EventType.typingStart).listen((event) {
      if (event.user.id != _channel.client.state.user.id) {
        _typings[event.user] = DateTime.now();
        _typingEventsController.add(_typings.keys.toList());
      }
    }));

    _subscriptions.add(_channel.on(EventType.typingStop).listen((event) {
      if (event.user.id != _channel.client.state.user.id) {
        _typings.remove(event.user);
        _typingEventsController.add(_typings.keys.toList());
      }
    }));
  }

  void _clean() {
    final now = DateTime.now();
    _typings.forEach((user, lastTypingEvent) {
      if (now.difference(lastTypingEvent).inSeconds > 7) {
        _channel.client.handleEvent(
          Event(
            type: EventType.typingStop,
            user: user,
            cid: _channel.cid,
          ),
        );
      }
    });
    _typingEventsController.add(_typings.keys.toList());
  }

  /// Call this method to dispose this object
  void dispose() {
    _unreadCountController.close();
    retryQueue.dispose();
    _subscriptions.forEach((s) => s.cancel());
    _channelStateController.close();
    _isUpToDateController.close();
    _threadsController.close();
    _typingEventsController.close();
  }
}
