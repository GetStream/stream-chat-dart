import 'dart:async';

import 'package:dio/dio.dart';
import 'package:stream_chat/src/event_type.dart';
import 'package:stream_chat/src/models/user.dart';

import '../client.dart';
import '../models/event.dart';
import '../models/member.dart';
import '../models/message.dart';
import 'requests.dart';
import 'responses.dart';

/// This a the class that manages a specific channel.
class ChannelClient {
  /// Create a channel client instance.
  ChannelClient(
    this._client,
    this.type,
    this.id,
    this.extraData,
  ) : cid = id != null ? "$type:$id" : null {
    _startCleaning();
    _listenTypingEvents();
  }

  /// The channel type
  String type;

  /// The channel id
  String id;

  /// The channel cid
  String cid;

  /// Custom channel extraData
  Map<String, dynamic> extraData;

  /// The main Stream chat client
  Client get client => _client;
  Client _client;

  final List<StreamSubscription> _subscriptions = [];

  String get _channelURL => "/channels/$type/$id";

  /// Send a message to this channel
  Future<SendMessageResponse> sendMessage(Message message) async {
    final response = await _client.post(
      "$_channelURL/message",
      data: {"message": message.toJson()},
    );
    return _client.decode(response.data, SendMessageResponse.fromJson);
  }

  /// Send a file to this channel
  Future<SendFileResponse> sendFile(MultipartFile file) async {
    final response = await _client.post(
      "$_channelURL/file",
      data: FormData.fromMap({'file': file}),
    );
    return _client.decode(response.data, SendFileResponse.fromJson);
  }

  /// Send an image to this channel
  Future<SendImageResponse> sendImage(MultipartFile file) async {
    final response = await _client.post(
      "$_channelURL/image",
      data: FormData.fromMap({'file': file}),
    );
    return _client.decode(response.data, SendImageResponse.fromJson);
  }

  /// Delete a file from this channel
  Future<EmptyResponse> deleteFile(String url) async {
    final response = await _client
        .delete("$_channelURL/file", queryParameters: {"url": url});
    return _client.decode(response.data, EmptyResponse.fromJson);
  }

  /// Delete an image from this channel
  Future<EmptyResponse> deleteImage(String url) async {
    final response = await _client
        .delete("$_channelURL/image", queryParameters: {"url": url});
    return _client.decode(response.data, EmptyResponse.fromJson);
  }

  /// Send an event on this channel
  Future<EmptyResponse> sendEvent(Event event) {
    return _client.post(
      "$_channelURL/event",
      data: {"event": event.toJson()},
    ).then((res) {
      return _client.decode(res.data, EmptyResponse.fromJson);
    });
  }

  /// Send a reaction to this channel
  Future<SendReactionResponse> sendReaction(
    String messageID,
    String type, {
    Map<String, dynamic> extraData = const {},
  }) async {
    final data = Map<String, dynamic>.from(extraData)
      ..addAll({
        "type": type,
      });

    final res = await _client.post(
      "/messages/$messageID/reaction",
      data: {"reaction": data},
    );
    return _client.decode(res.data, SendReactionResponse.fromJson);
  }

  /// Delete a reaction from this channel
  Future<EmptyResponse> deleteReaction(String messageID, String reactionType) {
    return client
        .delete("/messages/$messageID/reaction/$reactionType")
        .then((res) => _client.decode(res.data, EmptyResponse.fromJson));
  }

  /// Edit the channel custom data
  Future<UpdateChannelResponse> update(
    Map<String, dynamic> channelData,
    Message updateMessage,
  ) async {
    final response = await _client.post(_channelURL, data: {
      'message': updateMessage.toJson(),
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
    final response = await _client.post("$_channelURL/truncate");
    return _client.decode(response.data, EmptyResponse.fromJson);
  }

  /// Accept invitation to the channel
  Future<AcceptInviteResponse> acceptInvite([Message message]) async {
    final res = await _client.post(_channelURL,
        data: {"accept_invite": true, "message": message?.toJson()});
    return _client.decode(res.data, AcceptInviteResponse.fromJson);
  }

  /// Reject invitation to the channel
  Future<RejectInviteResponse> rejectInvite([Message message]) async {
    final res = await _client.post(_channelURL,
        data: {"accept_invite": false, "message": message?.toJson()});
    return _client.decode(res.data, RejectInviteResponse.fromJson);
  }

  /// Add members to the channel
  Future<AddMembersResponse> addMembers(
      List<Member> members, Message message) async {
    final res = await _client.post(_channelURL, data: {
      "add_members": members.map((m) => m.toJson()),
      "message": message.toJson(),
    });
    return _client.decode(res.data, AddMembersResponse.fromJson);
  }

  /// Invite members to the channel
  Future<InviteMembersResponse> inviteMembers(
    List<Member> members,
    Message message,
  ) async {
    final res = await _client.post(_channelURL, data: {
      "invites": members.map((m) => m.toJson()),
      "message": message.toJson(),
    });
    return _client.decode(res.data, InviteMembersResponse.fromJson);
  }

  /// Remove members from the channel
  Future<RemoveMembersResponse> removeMembers(
      List<Member> members, Message message) async {
    final res = await _client.post(_channelURL, data: {
      "remove_members": members.map((m) => m.toJson()),
      "message": message.toJson(),
    });
    return _client.decode(res.data, RemoveMembersResponse.fromJson);
  }

  /// Send action for a specific message of this channel
  Future<SendActionResponse> sendAction(
    String messageID,
    Map<String, dynamic> formData,
  ) async {
    final response = await _client.post("/messages/$messageID/action",
        data: {'id': id, 'type': type, 'form_data': formData});
    return _client.decode(response.data, SendActionResponse.fromJson);
  }

  /// Mark all channel messages as read
  Future<EmptyResponse> markRead() async {
    final response = await _client.post("$_channelURL/read", data: {});
    return _client.decode(response.data, EmptyResponse.fromJson);
  }

  /// Loads the initial channel state and watches for changes
  Future<ChannelStateResponse> watch(
      [Map<String, dynamic> options = const {}]) async {
    final watchOptions = Map<String, dynamic>.from({
      "state": true,
      "watch": true,
      "presence": false,
    })
      ..addAll(options);
    return query(options: watchOptions);
  }

  /// Stop watching the channel
  Future<EmptyResponse> stopWatching() async {
    final response = await _client.post("$_channelURL/stop-watching");
    return _client.decode(response.data, EmptyResponse.fromJson);
  }

  /// List the message replies for a parent message
  Future<QueryRepliesResponse> getReplies(
    String parentID,
    PaginationParams options,
  ) async {
    final response = await _client.get("/messages/$parentID/replies",
        queryParameters: options.toJson());
    return _client.decode<QueryRepliesResponse>(
        response.data, QueryRepliesResponse.fromJson);
  }

  /// List the reactions for a message in the channel
  Future<QueryReactionsResponse> getReactions(
    String messageID,
    PaginationParams options,
  ) async {
    final response = await _client.get(
      "/messages/$messageID/reactions",
      queryParameters: options.toJson(),
    );
    return _client.decode<QueryReactionsResponse>(
        response.data, QueryReactionsResponse.fromJson);
  }

  /// Retrieves a list of messages by ID
  Future<GetMessagesByIdResponse> getMessagesById(
      List<String> messageIDs) async {
    final response = await _client.get(
      "$_channelURL/messages",
      queryParameters: {'ids': messageIDs.join(',')},
    );
    return _client.decode<GetMessagesByIdResponse>(
        response.data, GetMessagesByIdResponse.fromJson);
  }

  /// Creates a new channel
  Future<ChannelStateResponse> create() async {
    return query(options: {
      "watch": false,
      "state": false,
      "presence": false,
    });
  }

  /// Query the API, get messages, members or other channel fields
  Future<ChannelStateResponse> query({
    Map<String, dynamic> options = const {},
    PaginationParams messagesPagination,
    PaginationParams membersPagination,
    PaginationParams watchersPagination,
  }) async {
    var path = "/channels/$type";
    if (id != null) {
      path = "$path/$id/query";
    }

    final data = Map<String, dynamic>.from({
      "state": true,
    })
      ..addAll(options);

    if (messagesPagination != null) {
      data['messages'] = messagesPagination.toJson();
    }
    if (membersPagination != null) {
      data['members'] = membersPagination.toJson();
    }
    if (watchersPagination != null) {
      data['watchers'] = watchersPagination.toJson();
    }

    final response = await _client.post(path, data: data);
    final state = _client.decode(response.data, ChannelStateResponse.fromJson);
    if (id == null) {
      id = state.channel.id;
      cid = state.channel.id;
    }
    return state;
  }

  /// Bans a user from the channel
  Future<EmptyResponse> banUser(
    String userID,
    Map<String, dynamic> options,
  ) async {
    final opts = Map<String, dynamic>.from(options)
      ..addAll({
        'type': type,
        'id': id,
      });
    return _client.banUser(userID, opts);
  }

  /// Remove the ban for a user in the channel
  Future<EmptyResponse> unbanUser(String userID) async {
    return _client.unbanUser(userID, {
      'type': type,
      'id': id,
    });
  }

  /// Hides the channel from [Client.queryChannels] for the user until a message is added
  ///	If [clearHistory] is set to true - all messages will be removed for the user
  Future<EmptyResponse> hide({bool clearHistory = false}) async {
    final response = await _client
        .post("$_channelURL/hide", data: {'clear_history': clearHistory});
    return _client.decode(response.data, EmptyResponse.fromJson);
  }

  /// Removes the hidden status for the channel
  Future<EmptyResponse> show() async {
    final response = await _client.post("$_channelURL/show");
    return _client.decode(response.data, EmptyResponse.fromJson);
  }

  /// Stream of [Event] coming from websocket connection specific for the channel
  /// Pass an eventType as parameter in order to filter just a type of event
  Stream<Event> on([String eventType]) =>
      _client.on(eventType).where((e) => e.cid == cid);

  DateTime _lastTypingEvent;

  /// First of the [EventType.typingStart] and [EventType.typingStop] events based on the users keystrokes.
  /// Call this on every keystroke.
  Future<void> keyStroke() async {
    client.logger.info('start typing');
    final now = DateTime.now();

    if (_lastTypingEvent == null ||
        now.difference(_lastTypingEvent).inSeconds >= 2) {
      _lastTypingEvent = now;
      await sendEvent(Event(type: EventType.typingStart));
    }
  }

  /// Sets last typing to null and sends the typing.stop event
  Future<void> stopTyping() async {
    client.logger.info('stop typing');
    _lastTypingEvent = null;
    await sendEvent(Event(type: EventType.typingStop));
  }

  /// Channel related typing users stream
  Stream<List<User>> get typingEvents => _typingEventsController.stream;
  StreamController<List<User>> _typingEventsController =
      StreamController.broadcast();

  final Map<User, DateTime> _typings = {};

  void _listenTypingEvents() {
    _subscriptions.add(this.on(EventType.typingStart).listen((event) {
      if (event.user != client.user) {
        _typings[event.user] = DateTime.now();
        _typingEventsController.add(_typings.keys.toList());
      }
    }));

    _subscriptions.add(this.on(EventType.typingStop).listen((event) {
      if (event.user != client.user) {
        _typings.remove(event.user);
        _typingEventsController.add(_typings.keys.toList());
      }
    }));
  }

  Timer _cleaningTimer;

  void _startCleaning() {
    _cleaningTimer = Timer.periodic(Duration(milliseconds: 500), (_) {
      final now = DateTime.now();

      if (_lastTypingEvent != null &&
          now.difference(_lastTypingEvent).inSeconds > 1) {
        stopTyping();
      }

      _typings.forEach((user, lastTypingEvent) {
        if (now.difference(lastTypingEvent).inSeconds > 7) {
          this.client.handleEvent(
                Event(
                  type: EventType.typingStop,
                  user: user,
                  cid: cid,
                ),
              );
        }
      });
      _typingEventsController.add(_typings.keys.toList());
    });
  }

  /// Call this function to dispose the channel client
  void dispose() {
    _subscriptions.forEach((s) => s.cancel());
    _typingEventsController.close();
    _cleaningTimer.cancel();
  }
}
