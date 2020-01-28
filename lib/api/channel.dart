import 'dart:convert';

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

  String _channelURL() => "${client.baseURL}/channels/$type/$id";

  // TODO: sendMessage response type
  Future<EmptyResponse> sendMessage(Message message) async {
    final response = await client
        .post("${this._channelURL()}/message", {"message": message.toJson()});
    return _client.decode(response.body, EmptyResponse.fromJson);
  }

  // TODO sendFile
  Future<EmptyResponse> sendFile() async => null;

  // TODO sendImage
  Future<EmptyResponse> sendImage() async => null;

  Future<EmptyResponse> deleteFile(String url) async {
    final response =
        await client.delete("${this._channelURL()}/file", params: {"url": url});
    return _client.decode(response.body, EmptyResponse.fromJson);
  }

  Future<EmptyResponse> deleteImage(String url) async {
    final response = await client
        .delete("${this._channelURL()}/image", params: {"url": url});
    return _client.decode(response.body, EmptyResponse.fromJson);
  }

  Future<EmptyResponse> sendEvent(Event event) {
    return client
        .post("${this._channelURL()}/event", {"event": event.toJson()}).then(
            (value) => EmptyResponse.fromJson(json.decode(value.body)));
  }

  // TODO sendReaction response type
  Future<EmptyResponse> sendReaction(
      String messageID, Reaction reaction) async {
    final response = await client.post(
        "${client.baseURL}/messages/$messageID/reaction",
        {"reaction": reaction.toJson()});
    return _client.decode(response.body, EmptyResponse.fromJson);
  }

  Future<EmptyResponse> deleteReaction(String messageID, String reactionType) {
    return client
        .delete("${client.baseURL}/messages/$messageID/reaction/$reactionType")
        .then((value) => EmptyResponse.fromJson(json.decode(value.body)));
  }

  // TODO update
  Future<EmptyResponse> update(
    dynamic channelData,
    Message updateMessage,
  ) async =>
      null;

  Future<EmptyResponse> delete() async {
    final response = await _client.delete(_channelURL());
    return _client.decode(response.body, EmptyResponse.fromJson);
  }

  Future<EmptyResponse> truncate() async {
    final response = await client.post("${_channelURL()}/truncate", {});
    return _client.decode(response.body, EmptyResponse.fromJson);
  }

  // TODO acceptInvite, options??
  Future<EmptyResponse> acceptInvite() async => null;

  // TODO rejectInvite, options??
  Future<EmptyResponse> rejectInvite() async => null;

  // TODO addMembers response type
  Future<EmptyResponse> addMembers(List<Member> members, Message message) {
    return client.post(_channelURL(), {
      "add_members": members.map((m) => m.toJson()),
      "message": message.toJson(),
    }).then((value) => EmptyResponse.fromJson(json.decode(value.body)));
  }

  // TODO addModerators response type
  Future<EmptyResponse> addModerators(List<Member> members, Message message) {
    return client.post(_channelURL(), {
      "add_moderators": members.map((m) => m.toJson()),
      "message": message.toJson(),
    }).then((value) => EmptyResponse.fromJson(json.decode(value.body)));
  }

  // TODO inviteMembers response type
  Future<EmptyResponse> inviteMembers(List<Member> members, Message message) {
    return client.post(_channelURL(), {
      "invites": members.map((m) => m.toJson()),
      "message": message.toJson(),
    }).then((value) => EmptyResponse.fromJson(json.decode(value.body)));
  }

  // TODO removeMembers response type
  Future<EmptyResponse> removeMembers(List<Member> members, Message message) {
    return client.post(_channelURL(), {
      "remove_members": members.map((m) => m.toJson()),
      "message": message.toJson(),
    }).then((value) => EmptyResponse.fromJson(json.decode(value.body)));
  }

  // TODO demoteModerators response type
  Future<EmptyResponse> demoteModerators(
      List<Member> members, Message message) {
    return client.post(_channelURL(), {
      "demote_moderators": members.map((m) => m.toJson()),
      "message": message.toJson(),
    }).then((value) => EmptyResponse.fromJson(json.decode(value.body)));
  }

  // TODO sendAction (see Run Message Action)
  Future<EmptyResponse> sendAction(String messageID, dynamic formData) async =>
      null;

  Future<EmptyResponse> markRead() async {
    final response = await client.post("$_channelURL()/read", {});
    return _client.decode(response.body, EmptyResponse.fromJson);
  }

  // TODO watch
  Future<EmptyResponse> watch(dynamic options) async => null;

  Future<EmptyResponse> stopWatching() async {
    final response = await client.post("$_channelURL()/stop-watching", {});
    return _client.decode(response.body, EmptyResponse.fromJson);
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
