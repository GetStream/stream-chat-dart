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
