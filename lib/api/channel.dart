import 'package:stream_chat_dart/api/requests.dart';
import 'package:stream_chat_dart/models/channel_config.dart';
import 'package:stream_chat_dart/models/event.dart';
import 'package:stream_chat_dart/models/member.dart';
import 'package:stream_chat_dart/models/message.dart';
import 'package:stream_chat_dart/models/reaction.dart';

import '../client.dart';

class Channel {

  Client _client;
  String type;
  String id;
  Map<String, dynamic> data;

  Channel(this._client, this.type, this.id, this.data);

  // TODO getConfig
  ChannelConfig getConfig() => null;

  // TODO sendMessage
  sendMessage(Message message) async => null;

  // TODO sendFile
  sendFile() async => null;

  // TODO sendImage
  sendImage() async => null;

  // TODO deleteFile
  deleteFile(String url) async => null;

  // TODO deleteImage
  deleteImage(String url) async => null;

  // TODO sendEvent
  sendEvent(Event event) async => null;

  // TODO sendReaction
  sendReaction(String messageID, Reaction reaction) async => null;

  // TODO deleteReaction
  deleteReaction(String messageID, String reactionType) async => null;

  // TODO update
  update(dynamic channelData, Message updateMessage) async => null;

  // TODO delete
  delete()  async => null;

  // TODO truncate
  truncate() async => null;

  // TODO acceptInvite
  acceptInvite() async => null;

  // TODO rejectInvite
  rejectInvite() async => null;

  // TODO addMembers
  addMembers(List<Member> members, Message message) async => null;

  // TODO addModerators
  addModerators(List<Member> members, Message message) async => null;

  // TODO inviteMembers
  inviteMembers(List<Member> members, Message message) async => null;

  // TODO removeMembers
  removeMembers(List<Member> members, Message message) async => null;

  // TODO demoteModerators
  demoteModerators(List<Member> members, Message message) async => null;

  // TODO sendAction
  sendAction(String messageID, dynamic formData) async => null;

  // TODO markRead
  markRead() async => null;

  // TODO markRead
  watch(dynamic options) async => null;

  // TODO stopWatching
  stopWatching() async => null;

  // TODO getReplies
  getReplies(String parentID, PaginationParams options) => null;

  // TODO getReactions
  getReactions(String messageID, dynamic options) async => null;

  // TODO getMessagesById
  getMessagesById(List<String> messageIDs) async => null;

  // TODO create
  create() async => null;

  // TODO query
  query(dynamic options) async => null;

  // TODO banUser
  banUser(String userID, dynamic options) async => null;

  // TODO hide
  hide(bool clearHistory) async => null;

  // TODO show
  show() async => null;

  // TODO unbanUser
  unbanUser(String userID) async => null;

  Stream<Event> on(String eventType) => null;

}