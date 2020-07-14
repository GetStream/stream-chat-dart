// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'responses.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QueryChannelsResponse _$QueryChannelsResponseFromJson(
    Map<String, dynamic> json) {
  return QueryChannelsResponse()
    ..duration = json['duration'] as String
    ..channels = (json['channels'] as List)
        ?.map((e) =>
            e == null ? null : ChannelState.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

QueryUsersResponse _$QueryUsersResponseFromJson(Map<String, dynamic> json) {
  return QueryUsersResponse()
    ..duration = json['duration'] as String
    ..users = (json['users'] as List)
        ?.map(
            (e) => e == null ? null : User.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

QueryReactionsResponse _$QueryReactionsResponseFromJson(
    Map<String, dynamic> json) {
  return QueryReactionsResponse()
    ..duration = json['duration'] as String
    ..reactions = (json['reactions'] as List)
        ?.map((e) =>
            e == null ? null : Reaction.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

QueryRepliesResponse _$QueryRepliesResponseFromJson(Map<String, dynamic> json) {
  return QueryRepliesResponse()
    ..duration = json['duration'] as String
    ..messages = (json['messages'] as List)
        ?.map((e) =>
            e == null ? null : Message.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

ListDevicesResponse _$ListDevicesResponseFromJson(Map<String, dynamic> json) {
  return ListDevicesResponse()
    ..duration = json['duration'] as String
    ..devices = (json['devices'] as List)
        ?.map((e) =>
            e == null ? null : Device.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

SendFileResponse _$SendFileResponseFromJson(Map<String, dynamic> json) {
  return SendFileResponse()
    ..duration = json['duration'] as String
    ..file = json['file'] as String;
}

SendImageResponse _$SendImageResponseFromJson(Map<String, dynamic> json) {
  return SendImageResponse()
    ..duration = json['duration'] as String
    ..file = json['file'] as String;
}

SendReactionResponse _$SendReactionResponseFromJson(Map<String, dynamic> json) {
  return SendReactionResponse()
    ..duration = json['duration'] as String
    ..message = json['message'] == null
        ? null
        : Message.fromJson(json['message'] as Map<String, dynamic>)
    ..reaction = json['reaction'] == null
        ? null
        : Reaction.fromJson(json['reaction'] as Map<String, dynamic>);
}

SetGuestUserResponse _$SetGuestUserResponseFromJson(Map<String, dynamic> json) {
  return SetGuestUserResponse()
    ..duration = json['duration'] as String
    ..accessToken = json['access_token'] as String
    ..user = json['user'] == null
        ? null
        : User.fromJson(json['user'] as Map<String, dynamic>);
}

UpdateUsersResponse _$UpdateUsersResponseFromJson(Map<String, dynamic> json) {
  return UpdateUsersResponse()
    ..duration = json['duration'] as String
    ..users = (json['users'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(
          k, e == null ? null : User.fromJson(e as Map<String, dynamic>)),
    );
}

UpdateMessageResponse _$UpdateMessageResponseFromJson(
    Map<String, dynamic> json) {
  return UpdateMessageResponse()
    ..duration = json['duration'] as String
    ..message = json['message'] == null
        ? null
        : Message.fromJson(json['message'] as Map<String, dynamic>);
}

SendMessageResponse _$SendMessageResponseFromJson(Map<String, dynamic> json) {
  return SendMessageResponse()
    ..duration = json['duration'] as String
    ..message = json['message'] == null
        ? null
        : Message.fromJson(json['message'] as Map<String, dynamic>);
}

GetMessageResponse _$GetMessageResponseFromJson(Map<String, dynamic> json) {
  return GetMessageResponse()
    ..duration = json['duration'] as String
    ..message = json['message'] == null
        ? null
        : Message.fromJson(json['message'] as Map<String, dynamic>);
}

SearchMessagesResponse _$SearchMessagesResponseFromJson(
    Map<String, dynamic> json) {
  return SearchMessagesResponse()
    ..duration = json['duration'] as String
    ..results = (json['results'] as List)
        ?.map((e) => e == null
            ? null
            : MessageResult.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

MessageResult _$MessageResultFromJson(Map<String, dynamic> json) {
  return MessageResult()
    ..duration = json['duration'] as String
    ..message = json['message'] == null
        ? null
        : Message.fromJson(json['message'] as Map<String, dynamic>);
}

GetMessagesByIdResponse _$GetMessagesByIdResponseFromJson(
    Map<String, dynamic> json) {
  return GetMessagesByIdResponse()
    ..duration = json['duration'] as String
    ..message = json['message'] == null
        ? null
        : Message.fromJson(json['message'] as Map<String, dynamic>);
}

UpdateChannelResponse _$UpdateChannelResponseFromJson(
    Map<String, dynamic> json) {
  return UpdateChannelResponse()
    ..duration = json['duration'] as String
    ..channel = json['channel'] == null
        ? null
        : ChannelModel.fromJson(json['channel'] as Map<String, dynamic>)
    ..members = (json['members'] as List)
        ?.map((e) =>
            e == null ? null : Member.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..message = json['message'] == null
        ? null
        : Message.fromJson(json['message'] as Map<String, dynamic>);
}

InviteMembersResponse _$InviteMembersResponseFromJson(
    Map<String, dynamic> json) {
  return InviteMembersResponse()
    ..duration = json['duration'] as String
    ..channel = json['channel'] == null
        ? null
        : ChannelModel.fromJson(json['channel'] as Map<String, dynamic>)
    ..members = (json['members'] as List)
        ?.map((e) =>
            e == null ? null : Member.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..message = json['message'] == null
        ? null
        : Message.fromJson(json['message'] as Map<String, dynamic>);
}

RemoveMembersResponse _$RemoveMembersResponseFromJson(
    Map<String, dynamic> json) {
  return RemoveMembersResponse()
    ..duration = json['duration'] as String
    ..channel = json['channel'] == null
        ? null
        : ChannelModel.fromJson(json['channel'] as Map<String, dynamic>)
    ..members = (json['members'] as List)
        ?.map((e) =>
            e == null ? null : Member.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..message = json['message'] == null
        ? null
        : Message.fromJson(json['message'] as Map<String, dynamic>);
}

SendActionResponse _$SendActionResponseFromJson(Map<String, dynamic> json) {
  return SendActionResponse()
    ..duration = json['duration'] as String
    ..message = json['message'] == null
        ? null
        : Message.fromJson(json['message'] as Map<String, dynamic>);
}

AddMembersResponse _$AddMembersResponseFromJson(Map<String, dynamic> json) {
  return AddMembersResponse()
    ..duration = json['duration'] as String
    ..channel = json['channel'] == null
        ? null
        : ChannelModel.fromJson(json['channel'] as Map<String, dynamic>)
    ..members = (json['members'] as List)
        ?.map((e) =>
            e == null ? null : Member.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..message = json['message'] == null
        ? null
        : Message.fromJson(json['message'] as Map<String, dynamic>);
}

AcceptInviteResponse _$AcceptInviteResponseFromJson(Map<String, dynamic> json) {
  return AcceptInviteResponse()
    ..duration = json['duration'] as String
    ..channel = json['channel'] == null
        ? null
        : ChannelModel.fromJson(json['channel'] as Map<String, dynamic>)
    ..members = (json['members'] as List)
        ?.map((e) =>
            e == null ? null : Member.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..message = json['message'] == null
        ? null
        : Message.fromJson(json['message'] as Map<String, dynamic>);
}

RejectInviteResponse _$RejectInviteResponseFromJson(Map<String, dynamic> json) {
  return RejectInviteResponse()
    ..duration = json['duration'] as String
    ..channel = json['channel'] == null
        ? null
        : ChannelModel.fromJson(json['channel'] as Map<String, dynamic>)
    ..members = (json['members'] as List)
        ?.map((e) =>
            e == null ? null : Member.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..message = json['message'] == null
        ? null
        : Message.fromJson(json['message'] as Map<String, dynamic>);
}

EmptyResponse _$EmptyResponseFromJson(Map<String, dynamic> json) {
  return EmptyResponse()..duration = json['duration'] as String;
}

ChannelStateResponse _$ChannelStateResponseFromJson(Map<String, dynamic> json) {
  return ChannelStateResponse()
    ..duration = json['duration'] as String
    ..channel = json['channel'] == null
        ? null
        : ChannelModel.fromJson(json['channel'] as Map<String, dynamic>)
    ..messages = (json['messages'] as List)
        ?.map((e) =>
            e == null ? null : Message.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..members = (json['members'] as List)
        ?.map((e) =>
            e == null ? null : Member.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..watcherCount = json['watcher_count'] as int
    ..read = (json['read'] as List)
        ?.map(
            (e) => e == null ? null : Read.fromJson(e as Map<String, dynamic>))
        ?.toList();
}
