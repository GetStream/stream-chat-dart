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

Map<String, dynamic> _$QueryChannelsResponseToJson(
        QueryChannelsResponse instance) =>
    <String, dynamic>{
      'duration': instance.duration,
      'channels': instance.channels?.map((e) => e?.toJson())?.toList(),
    };

QueryUsersResponse _$QueryUsersResponseFromJson(Map<String, dynamic> json) {
  return QueryUsersResponse()
    ..duration = json['duration'] as String
    ..users = (json['users'] as List)
        ?.map(
            (e) => e == null ? null : User.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$QueryUsersResponseToJson(QueryUsersResponse instance) =>
    <String, dynamic>{
      'duration': instance.duration,
      'users': instance.users?.map((e) => e?.toJson())?.toList(),
    };

QueryRepliesResponse _$QueryRepliesResponseFromJson(Map<String, dynamic> json) {
  return QueryRepliesResponse()
    ..duration = json['duration'] as String
    ..messages = (json['messages'] as List)
        ?.map((e) =>
            e == null ? null : Message.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$QueryRepliesResponseToJson(
        QueryRepliesResponse instance) =>
    <String, dynamic>{
      'duration': instance.duration,
      'messages': instance.messages?.map((e) => e?.toJson())?.toList(),
    };

ListDevicesResponse _$ListDevicesResponseFromJson(Map<String, dynamic> json) {
  return ListDevicesResponse()
    ..duration = json['duration'] as String
    ..devices = (json['devices'] as List)
        ?.map((e) =>
            e == null ? null : Device.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$ListDevicesResponseToJson(
        ListDevicesResponse instance) =>
    <String, dynamic>{
      'duration': instance.duration,
      'devices': instance.devices?.map((e) => e?.toJson())?.toList(),
    };

SendFileResponse _$SendFileResponseFromJson(Map<String, dynamic> json) {
  return SendFileResponse()
    ..duration = json['duration'] as String
    ..file = json['file'] as String;
}

Map<String, dynamic> _$SendFileResponseToJson(SendFileResponse instance) =>
    <String, dynamic>{
      'duration': instance.duration,
      'file': instance.file,
    };

SendImageResponse _$SendImageResponseFromJson(Map<String, dynamic> json) {
  return SendImageResponse()
    ..duration = json['duration'] as String
    ..file = json['file'] as String;
}

Map<String, dynamic> _$SendImageResponseToJson(SendImageResponse instance) =>
    <String, dynamic>{
      'duration': instance.duration,
      'file': instance.file,
    };

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

Map<String, dynamic> _$SendReactionResponseToJson(
        SendReactionResponse instance) =>
    <String, dynamic>{
      'duration': instance.duration,
      'message': instance.message?.toJson(),
      'reaction': instance.reaction?.toJson(),
    };

SetGuestUserResponse _$SetGuestUserResponseFromJson(Map<String, dynamic> json) {
  return SetGuestUserResponse()
    ..duration = json['duration'] as String
    ..accessToken = json['access_token'] as String
    ..user = json['user'] == null
        ? null
        : User.fromJson(json['user'] as Map<String, dynamic>);
}

Map<String, dynamic> _$SetGuestUserResponseToJson(
        SetGuestUserResponse instance) =>
    <String, dynamic>{
      'duration': instance.duration,
      'access_token': instance.accessToken,
      'user': instance.user?.toJson(),
    };

UpdateUsersResponse _$UpdateUsersResponseFromJson(Map<String, dynamic> json) {
  return UpdateUsersResponse()
    ..duration = json['duration'] as String
    ..users = (json['users'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(
          k, e == null ? null : User.fromJson(e as Map<String, dynamic>)),
    );
}

Map<String, dynamic> _$UpdateUsersResponseToJson(
        UpdateUsersResponse instance) =>
    <String, dynamic>{
      'duration': instance.duration,
      'users': instance.users?.map((k, e) => MapEntry(k, e?.toJson())),
    };

UpdateMessageResponse _$UpdateMessageResponseFromJson(
    Map<String, dynamic> json) {
  return UpdateMessageResponse()
    ..duration = json['duration'] as String
    ..message = json['message'] == null
        ? null
        : Message.fromJson(json['message'] as Map<String, dynamic>);
}

Map<String, dynamic> _$UpdateMessageResponseToJson(
        UpdateMessageResponse instance) =>
    <String, dynamic>{
      'duration': instance.duration,
      'message': instance.message?.toJson(),
    };

SendMessageResponse _$SendMessageResponseFromJson(Map<String, dynamic> json) {
  return SendMessageResponse()
    ..duration = json['duration'] as String
    ..message = json['message'] == null
        ? null
        : Message.fromJson(json['message'] as Map<String, dynamic>);
}

Map<String, dynamic> _$SendMessageResponseToJson(
        SendMessageResponse instance) =>
    <String, dynamic>{
      'duration': instance.duration,
      'message': instance.message?.toJson(),
    };

GetMessageResponse _$GetMessageResponseFromJson(Map<String, dynamic> json) {
  return GetMessageResponse()
    ..duration = json['duration'] as String
    ..message = json['message'] == null
        ? null
        : Message.fromJson(json['message'] as Map<String, dynamic>);
}

Map<String, dynamic> _$GetMessageResponseToJson(GetMessageResponse instance) =>
    <String, dynamic>{
      'duration': instance.duration,
      'message': instance.message?.toJson(),
    };

AddModeratorsResponse _$AddModeratorsResponseFromJson(
    Map<String, dynamic> json) {
  return AddModeratorsResponse()
    ..duration = json['duration'] as String
    ..channel = json['channel'] == null
        ? null
        : Channel.fromJson(json['channel'] as Map<String, dynamic>)
    ..members = (json['members'] as List)
        ?.map((e) =>
            e == null ? null : Member.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..message = json['message'] == null
        ? null
        : Message.fromJson(json['message'] as Map<String, dynamic>);
}

Map<String, dynamic> _$AddModeratorsResponseToJson(
        AddModeratorsResponse instance) =>
    <String, dynamic>{
      'duration': instance.duration,
      'channel': instance.channel?.toJson(),
      'members': instance.members?.map((e) => e?.toJson())?.toList(),
      'message': instance.message?.toJson(),
    };

UpdateChannelResponse _$UpdateChannelResponseFromJson(
    Map<String, dynamic> json) {
  return UpdateChannelResponse()
    ..duration = json['duration'] as String
    ..channel = json['channel'] == null
        ? null
        : Channel.fromJson(json['channel'] as Map<String, dynamic>)
    ..members = (json['members'] as List)
        ?.map((e) =>
            e == null ? null : Member.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..message = json['message'] == null
        ? null
        : Message.fromJson(json['message'] as Map<String, dynamic>);
}

Map<String, dynamic> _$UpdateChannelResponseToJson(
        UpdateChannelResponse instance) =>
    <String, dynamic>{
      'duration': instance.duration,
      'channel': instance.channel?.toJson(),
      'members': instance.members?.map((e) => e?.toJson())?.toList(),
      'message': instance.message?.toJson(),
    };

InviteMembersResponse _$InviteMembersResponseFromJson(
    Map<String, dynamic> json) {
  return InviteMembersResponse()
    ..duration = json['duration'] as String
    ..channel = json['channel'] == null
        ? null
        : Channel.fromJson(json['channel'] as Map<String, dynamic>)
    ..members = (json['members'] as List)
        ?.map((e) =>
            e == null ? null : Member.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..message = json['message'] == null
        ? null
        : Message.fromJson(json['message'] as Map<String, dynamic>);
}

Map<String, dynamic> _$InviteMembersResponseToJson(
        InviteMembersResponse instance) =>
    <String, dynamic>{
      'duration': instance.duration,
      'channel': instance.channel?.toJson(),
      'members': instance.members?.map((e) => e?.toJson())?.toList(),
      'message': instance.message?.toJson(),
    };

RemoveMembersResponse _$RemoveMembersResponseFromJson(
    Map<String, dynamic> json) {
  return RemoveMembersResponse()
    ..duration = json['duration'] as String
    ..channel = json['channel'] == null
        ? null
        : Channel.fromJson(json['channel'] as Map<String, dynamic>)
    ..members = (json['members'] as List)
        ?.map((e) =>
            e == null ? null : Member.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..message = json['message'] == null
        ? null
        : Message.fromJson(json['message'] as Map<String, dynamic>);
}

Map<String, dynamic> _$RemoveMembersResponseToJson(
        RemoveMembersResponse instance) =>
    <String, dynamic>{
      'duration': instance.duration,
      'channel': instance.channel?.toJson(),
      'members': instance.members?.map((e) => e?.toJson())?.toList(),
      'message': instance.message?.toJson(),
    };

AddMembersResponse _$AddMembersResponseFromJson(Map<String, dynamic> json) {
  return AddMembersResponse()
    ..duration = json['duration'] as String
    ..channel = json['channel'] == null
        ? null
        : Channel.fromJson(json['channel'] as Map<String, dynamic>)
    ..members = (json['members'] as List)
        ?.map((e) =>
            e == null ? null : Member.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..message = json['message'] == null
        ? null
        : Message.fromJson(json['message'] as Map<String, dynamic>);
}

Map<String, dynamic> _$AddMembersResponseToJson(AddMembersResponse instance) =>
    <String, dynamic>{
      'duration': instance.duration,
      'channel': instance.channel?.toJson(),
      'members': instance.members?.map((e) => e?.toJson())?.toList(),
      'message': instance.message?.toJson(),
    };

DemoteModeratorsResponse _$DemoteModeratorsResponseFromJson(
    Map<String, dynamic> json) {
  return DemoteModeratorsResponse()
    ..duration = json['duration'] as String
    ..channel = json['channel'] == null
        ? null
        : Channel.fromJson(json['channel'] as Map<String, dynamic>)
    ..members = (json['members'] as List)
        ?.map((e) =>
            e == null ? null : Member.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..message = json['message'] == null
        ? null
        : Message.fromJson(json['message'] as Map<String, dynamic>);
}

Map<String, dynamic> _$DemoteModeratorsResponseToJson(
        DemoteModeratorsResponse instance) =>
    <String, dynamic>{
      'duration': instance.duration,
      'channel': instance.channel?.toJson(),
      'members': instance.members?.map((e) => e?.toJson())?.toList(),
      'message': instance.message?.toJson(),
    };

EmptyResponse _$EmptyResponseFromJson(Map<String, dynamic> json) {
  return EmptyResponse()..duration = json['duration'] as String;
}

Map<String, dynamic> _$EmptyResponseToJson(EmptyResponse instance) =>
    <String, dynamic>{
      'duration': instance.duration,
    };
