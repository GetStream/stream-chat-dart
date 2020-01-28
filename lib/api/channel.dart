import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:stream_chat_dart/api/requests.dart';
import 'package:stream_chat_dart/models/event.dart';
import 'package:stream_chat_dart/models/member.dart';
import 'package:stream_chat_dart/models/message.dart';
import 'package:stream_chat_dart/models/reaction.dart';

import '../client.dart';
import 'responses.dart';

class Channel {
  Client _client;
  String type;
  String id;
  Map<String, dynamic> data;

  Channel(this._client, this.type, this.id, this.data);

  Client get client => _client;

  String get channelURL => "/channels/$type/$id";

  Future<SendMessageResponse> sendMessage(Message message) async {
    final response = await _client.dioClient.post<String>(
      "$channelURL/message",
      data: {"message": message.toJson()},
    );
    return _client.decode(response.data, SendMessageResponse.fromJson);
  }

  Future<SendFileResponse> sendFile(MultipartFile file) async {
    final response = await _client.dioClient.post<String>(
      "$channelURL/file",
      data: FormData.fromMap({'file': file}),
    );
    return _client.decode(response.data, SendFileResponse.fromJson);
  }

  Future<SendImageResponse> sendImage(MultipartFile file) async {
    final response = await _client.dioClient.post<String>(
      "$channelURL/image",
      data: FormData.fromMap({'file': file}),
    );
    return _client.decode(response.data, SendImageResponse.fromJson);
  }

  Future<EmptyResponse> deleteFile(String url) async {
    final response = await _client.dioClient
        .delete("$channelURL/file", queryParameters: {"url": url});
    return _client.decode(response.data, EmptyResponse.fromJson);
  }

  Future<EmptyResponse> deleteImage(String url) async {
    final response = await _client.dioClient
        .delete("$channelURL/image", queryParameters: {"url": url});
    return _client.decode(response.data, EmptyResponse.fromJson);
  }

  Future<EmptyResponse> sendEvent(Event event) {
    return _client.dioClient.post<String>(
      "$channelURL/event",
      data: {"event": event.toJson()},
    ).then((res) {
      return EmptyResponse.fromJson(json.decode(res.data.toString()));
    });
  }

  Future<SendReactionResponse> sendReaction(
    String messageID,
    Reaction reaction,
  ) async {
    final res = await _client.dioClient.post<String>(
      "/messages/$messageID/reaction",
      data: {"reaction": reaction.toJson()},
    );
    return _client.decode(res.data, SendReactionResponse.fromJson);
  }

  Future<EmptyResponse> deleteReaction(String messageID, String reactionType) {
    return client.dioClient
        .delete("${client.baseURL}/messages/$messageID/reaction/$reactionType")
        .then((value) =>
            EmptyResponse.fromJson(json.decode(value.data.toString())));
  }

  // TODO update
  Future<EmptyResponse> update(
    dynamic channelData,
    Message updateMessage,
  ) async =>
      null;

  Future<EmptyResponse> delete() async {
    final response = await _client.dioClient.delete<String>(channelURL);
    return _client.decode(response.data, EmptyResponse.fromJson);
  }

  Future<EmptyResponse> truncate() async {
    final response =
        await _client.dioClient.post<String>("$channelURL/truncate");
    return _client.decode(response.data, EmptyResponse.fromJson);
  }

  // TODO acceptInvite, options??
  Future<EmptyResponse> acceptInvite() async => null;

  // TODO rejectInvite, options??
  Future<EmptyResponse> rejectInvite() async => null;

  Future<AddMembersResponse> addMembers(
      List<Member> members, Message message) async {
    final res = await _client.dioClient.post<String>(channelURL, data: {
      "add_members": members.map((m) => m.toJson()),
      "message": message.toJson(),
    });
    return _client.decode(res.data, AddMembersResponse.fromJson);
  }

  Future<AddModeratorsResponse> addModerators(
      List<Member> moderators, Message message) {
    return _client.dioClient.post<String>(channelURL, data: {
      "add_moderators": moderators.map((m) => m.toJson()),
      "message": message.toJson(),
    }).then((res) => AddModeratorsResponse.fromJson(json.decode(res.data)));
  }

  // TODO inviteMembers response type
  Future<EmptyResponse> inviteMembers(List<Member> members, Message message) {
    return _client.dioClient.post<String>(channelURL, data: {
      "invites": members.map((m) => m.toJson()),
      "message": message.toJson(),
    }).then((res) => EmptyResponse.fromJson(json.decode(res.data)));
  }

  // TODO removeMembers response type
  Future<EmptyResponse> removeMembers(List<Member> members, Message message) {
    return _client.dioClient.post<String>(channelURL, data: {
      "remove_members": members.map((m) => m.toJson()),
      "message": message.toJson(),
    }).then((res) => EmptyResponse.fromJson(json.decode(res.data)));
  }

  // TODO demoteModerators response type
  Future<EmptyResponse> demoteModerators(
      List<Member> members, Message message) {
    return _client.dioClient.post<String>(channelURL, data: {
      "demote_moderators": members.map((m) => m.toJson()),
      "message": message.toJson(),
    }).then((res) => EmptyResponse.fromJson(json.decode(res.data)));
  }

  // TODO sendAction (see Run Message Action)
  Future<EmptyResponse> sendAction(String messageID, dynamic formData) async =>
      null;

  Future<EmptyResponse> markRead() async {
    final response = await _client.dioClient.post<String>("$channelURL/read");
    return _client.decode(response.data, EmptyResponse.fromJson);
  }

  // TODO watch
  Future<EmptyResponse> watch(dynamic options) async => null;

  Future<EmptyResponse> stopWatching() async {
    final response =
        await _client.dioClient.post<String>("$channelURL/stop-watching");
    return _client.decode(response.data, EmptyResponse.fromJson);
  }

  // TODO getReplies
  Future<EmptyResponse> getReplies(String parentID, PaginationParams options) =>
      null;

  // TODO getReactions
  Future<EmptyResponse> getReactions(String messageID, dynamic options) async =>
      null;

  // TODO getMessagesById
  Future<EmptyResponse> getMessagesById(List<String> messageIDs) async => null;

  // TODO create
  Future<EmptyResponse> create() async => null;

  // TODO query
  Future<EmptyResponse> query(dynamic options) async => null;

  // TODO banUser
  Future<EmptyResponse> banUser(String userID, dynamic options) async => null;

  // TODO hide
  Future<EmptyResponse> hide(bool clearHistory) async => null;

  // TODO show
  Future<EmptyResponse> show() async => null;

  // TODO unbanUser
  Future<EmptyResponse> unbanUser(String userID) async => null;

  Stream<Event> on(String eventType) => null;
}
