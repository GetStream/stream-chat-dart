import 'package:dio/dio.dart';

import '../client.dart';
import '../models/event.dart';
import '../models/member.dart';
import '../models/message.dart';
import '../models/reaction.dart';
import 'requests.dart';
import 'responses.dart';

class ChannelClient {
  Client _client;
  String type;
  String id;
  String cid;
  Map<String, dynamic> data;

  ChannelClient(this._client, this.type, this.id, this.data)
      : cid = id != null ? "$type:$id" : null;

  Client get client => _client;

  String get _channelURL => "/channels/$type/$id";

  Future<SendMessageResponse> sendMessage(Message message) async {
    final response = await _client.post(
      "$_channelURL/message",
      data: {"message": message.toJson()},
    );
    return _client.decode(response.data, SendMessageResponse.fromJson);
  }

  Future<SendFileResponse> sendFile(MultipartFile file) async {
    final response = await _client.post(
      "$_channelURL/file",
      data: FormData.fromMap({'file': file}),
    );
    return _client.decode(response.data, SendFileResponse.fromJson);
  }

  Future<SendImageResponse> sendImage(MultipartFile file) async {
    final response = await _client.post(
      "$_channelURL/image",
      data: FormData.fromMap({'file': file}),
    );
    return _client.decode(response.data, SendImageResponse.fromJson);
  }

  Future<EmptyResponse> deleteFile(String url) async {
    final response = await _client
        .delete("$_channelURL/file", queryParameters: {"url": url});
    return _client.decode(response.data, EmptyResponse.fromJson);
  }

  Future<EmptyResponse> deleteImage(String url) async {
    final response = await _client
        .delete("$_channelURL/image", queryParameters: {"url": url});
    return _client.decode(response.data, EmptyResponse.fromJson);
  }

  Future<EmptyResponse> sendEvent(Event event) {
    return _client.post(
      "$_channelURL/event",
      data: {"event": event.toJson()},
    ).then((res) {
      return _client.decode(res.data, EmptyResponse.fromJson);
    });
  }

  Future<SendReactionResponse> sendReaction(
    String messageID,
    Reaction reaction,
  ) async {
    final res = await _client.post(
      "/messages/$messageID/reaction",
      data: {"reaction": reaction.toJson()},
    );
    return _client.decode(res.data, SendReactionResponse.fromJson);
  }

  Future<EmptyResponse> deleteReaction(String messageID, String reactionType) {
    return client
        .delete("/messages/$messageID/reaction/$reactionType")
        .then((res) => _client.decode(res.data, EmptyResponse.fromJson));
  }

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

  Future<EmptyResponse> delete() async {
    final response = await _client.delete(_channelURL);
    return _client.decode(response.data, EmptyResponse.fromJson);
  }

  Future<EmptyResponse> truncate() async {
    final response = await _client.post("$_channelURL/truncate");
    return _client.decode(response.data, EmptyResponse.fromJson);
  }

  Future<AcceptInviteResponse> acceptInvite([Message message]) async {
    final res = await _client.post(_channelURL,
        data: {"accept_invite": true, "message": message?.toJson()});
    return _client.decode(res.data, AcceptInviteResponse.fromJson);
  }

  Future<RejectInviteResponse> rejectInvite([Message message]) async {
    final res = await _client.post(_channelURL,
        data: {"accept_invite": false, "message": message?.toJson()});
    return _client.decode(res.data, RejectInviteResponse.fromJson);
  }

  Future<AddMembersResponse> addMembers(
      List<Member> members, Message message) async {
    final res = await _client.post(_channelURL, data: {
      "add_members": members.map((m) => m.toJson()),
      "message": message.toJson(),
    });
    return _client.decode(res.data, AddMembersResponse.fromJson);
  }

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

  Future<RemoveMembersResponse> removeMembers(
      List<Member> members, Message message) async {
    final res = await _client.post(_channelURL, data: {
      "remove_members": members.map((m) => m.toJson()),
      "message": message.toJson(),
    });
    return _client.decode(res.data, RemoveMembersResponse.fromJson);
  }

  Future<SendActionResponse> sendAction(
      String messageID, Map<String, dynamic> formData) async {
    final response = await _client.post("/messages/$messageID/action",
        data: {'id': id, 'type': type, 'form_data': formData});
    return _client.decode(response.data, SendActionResponse.fromJson);
  }

  Future<EmptyResponse> markRead() async {
    final response = await _client.post("$_channelURL/read", data: {});
    return _client.decode(response.data, EmptyResponse.fromJson);
  }

  Future<ChannelStateResponse> watch(Map<String, dynamic> options) async {
    final watchOptions = Map<String, dynamic>.from({
      "state": true,
      "watch": true,
      "presence": false,
    })
      ..addAll(options);
    return query(watchOptions);
  }

  Future<EmptyResponse> stopWatching() async {
    final response = await _client.post("$_channelURL/stop-watching");
    return _client.decode(response.data, EmptyResponse.fromJson);
  }

  Future<QueryRepliesResponse> getReplies(
      String parentID, PaginationParams options) async {
    final response = await _client.get("/messages/$parentID/replies",
        queryParameters: options.toJson());
    return _client.decode<QueryRepliesResponse>(
        response.data, QueryRepliesResponse.fromJson);
  }

  Future<QueryReactionsResponse> getReactions(
      String messageID, PaginationParams options) async {
    final response = await _client.get(
      "/messages/$messageID/reactions",
      queryParameters: options.toJson(),
    );
    return _client.decode<QueryReactionsResponse>(
        response.data, QueryReactionsResponse.fromJson);
  }

  Future<GetMessagesByIdResponse> getMessagesById(
      List<String> messageIDs) async {
    final response = await _client.get(
      "$_channelURL/messages",
      queryParameters: {'ids': messageIDs.join(',')},
    );
    return _client.decode<GetMessagesByIdResponse>(
        response.data, GetMessagesByIdResponse.fromJson);
  }

  Future<ChannelStateResponse> create() async {
    return query({
      "watch": false,
      "state": false,
      "presence": false,
    });
  }

  Future<ChannelStateResponse> query(
    Map<String, dynamic> options, {
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

  Future<EmptyResponse> unbanUser(String userID) async {
    return _client.unbanUser(userID, {
      'type': type,
      'id': id,
    });
  }

  Future<EmptyResponse> hide([bool clearHistory = false]) async {
    final response = await _client
        .post("$_channelURL/hide", data: {'clear_history': clearHistory});
    return _client.decode(response.data, EmptyResponse.fromJson);
  }

  Future<EmptyResponse> show() async {
    final response = await _client.post("$_channelURL/show");
    return _client.decode(response.data, EmptyResponse.fromJson);
  }

  Stream<Event> on(String eventType) =>
      _client.on(eventType).where((e) => e.cid == cid);
}
