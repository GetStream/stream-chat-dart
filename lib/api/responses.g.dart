// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'responses.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QueryChannelsResponse _$QueryChannelsResponseFromJson(
    Map<String, dynamic> json) {
  return QueryChannelsResponse(
    json['duration'] as String,
    (json['channels'] as List)
        ?.map((e) =>
            e == null ? null : ChannelState.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$QueryChannelsResponseToJson(
        QueryChannelsResponse instance) =>
    <String, dynamic>{
      'channels': instance.channels?.map((e) => e?.toJson())?.toList(),
      'duration': instance.duration,
    };

SendFileResponse _$SendFileResponseFromJson(Map<String, dynamic> json) {
  return SendFileResponse(
    json['duration'] as String,
    json['file'] as String,
  );
}

Map<String, dynamic> _$SendFileResponseToJson(SendFileResponse instance) =>
    <String, dynamic>{
      'file': instance.file,
      'duration': instance.duration,
    };

SendImageResponse _$SendImageResponseFromJson(Map<String, dynamic> json) {
  return SendImageResponse(
    json['duration'] as String,
    json['file'] as String,
  );
}

Map<String, dynamic> _$SendImageResponseToJson(SendImageResponse instance) =>
    <String, dynamic>{
      'file': instance.file,
      'duration': instance.duration,
    };

SendReactionResponse _$SendReactionResponseFromJson(Map<String, dynamic> json) {
  return SendReactionResponse(
    json['duration'] as String,
    json['message'] == null
        ? null
        : Message.fromJson(json['message'] as Map<String, dynamic>),
    json['reaction'] == null
        ? null
        : Reaction.fromJson(json['reaction'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$SendReactionResponseToJson(
        SendReactionResponse instance) =>
    <String, dynamic>{
      'message': instance.message?.toJson(),
      'reaction': instance.reaction?.toJson(),
      'duration': instance.duration,
    };

SetGuestUserResponse _$SetGuestUserResponseFromJson(Map<String, dynamic> json) {
  return SetGuestUserResponse(
    json['duration'] as String,
    json['access_token'] as String,
    json['user'] == null
        ? null
        : User.fromJson(json['user'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$SetGuestUserResponseToJson(
        SetGuestUserResponse instance) =>
    <String, dynamic>{
      'access_token': instance.accessToken,
      'user': instance.user?.toJson(),
      'duration': instance.duration,
    };

UpdateUsersResponse _$UpdateUsersResponseFromJson(Map<String, dynamic> json) {
  return UpdateUsersResponse(
    json['duration'] as String,
    (json['users'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(
          k, e == null ? null : User.fromJson(e as Map<String, dynamic>)),
    ),
  );
}

Map<String, dynamic> _$UpdateUsersResponseToJson(
        UpdateUsersResponse instance) =>
    <String, dynamic>{
      'users': instance.users?.map((k, e) => MapEntry(k, e?.toJson())),
      'duration': instance.duration,
    };

UpdateMessageResponse _$UpdateMessageResponseFromJson(
    Map<String, dynamic> json) {
  return UpdateMessageResponse(
    json['duration'] as String,
    json['message'] == null
        ? null
        : Message.fromJson(json['message'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$UpdateMessageResponseToJson(
        UpdateMessageResponse instance) =>
    <String, dynamic>{
      'message': instance.message?.toJson(),
      'duration': instance.duration,
    };

GetMessageResponse _$GetMessageResponseFromJson(Map<String, dynamic> json) {
  return GetMessageResponse(
    json['duration'] as String,
    json['message'] == null
        ? null
        : Message.fromJson(json['message'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$GetMessageResponseToJson(GetMessageResponse instance) =>
    <String, dynamic>{
      'message': instance.message?.toJson(),
      'duration': instance.duration,
    };

AddModeratorsResponse _$AddModeratorsResponseFromJson(
    Map<String, dynamic> json) {
  return AddModeratorsResponse(
    json['duration'] as String,
    json['message'] == null
        ? null
        : Message.fromJson(json['message'] as Map<String, dynamic>),
    (json['members'] as List)
        ?.map((e) =>
            e == null ? null : Member.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  )..channel = json['channel'] == null
      ? null
      : Channel.fromJson(json['channel'] as Map<String, dynamic>);
}

Map<String, dynamic> _$AddModeratorsResponseToJson(
        AddModeratorsResponse instance) =>
    <String, dynamic>{
      'channel': instance.channel?.toJson(),
      'members': instance.members?.map((e) => e?.toJson())?.toList(),
      'message': instance.message?.toJson(),
      'duration': instance.duration,
    };

EmptyResponse _$EmptyResponseFromJson(Map<String, dynamic> json) {
  return EmptyResponse(
    json['duration'] as String,
  );
}

Map<String, dynamic> _$EmptyResponseToJson(EmptyResponse instance) =>
    <String, dynamic>{
      'duration': instance.duration,
    };
