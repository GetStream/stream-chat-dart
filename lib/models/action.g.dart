// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'action.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Action _$ActionFromJson(Map<String, dynamic> json) {
  return Action(
    json['name'] as String,
    json['style'] as String,
    json['text'] as String,
    json['type'] as String,
    json['value'] as String,
  );
}

Map<String, dynamic> _$ActionToJson(Action instance) => <String, dynamic>{
      'name': instance.name,
      'style': instance.style,
      'text': instance.text,
      'type': instance.type,
      'value': instance.value,
    };
