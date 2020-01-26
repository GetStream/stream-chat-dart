// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Command _$CommandFromJson(Map<String, dynamic> json) {
  return Command(
    json['name'] as String,
    json['description'] as String,
    json['args'] as String,
  );
}

Map<String, dynamic> _$CommandToJson(Command instance) => <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'args': instance.args,
    };
