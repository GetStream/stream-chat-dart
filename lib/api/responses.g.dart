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

EmptyResponse _$EmptyResponseFromJson(Map<String, dynamic> json) {
  return EmptyResponse(
    json['duration'] as String,
  );
}

Map<String, dynamic> _$EmptyResponseToJson(EmptyResponse instance) =>
    <String, dynamic>{
      'duration': instance.duration,
    };
