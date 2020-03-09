// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel_state.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChannelStateAdapter extends TypeAdapter<ChannelState> {
  @override
  final typeId = 0;

  @override
  ChannelState read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChannelState(
      channel: fields[0] as ChannelModel,
      messages: (fields[1] as List)?.cast<Message>(),
      members: (fields[2] as List)?.cast<Member>(),
      watcherCount: fields[3] as int,
      watchers: (fields[4] as List)?.cast<User>(),
      read: (fields[5] as List)?.cast<Read>(),
    );
  }

  @override
  void write(BinaryWriter writer, ChannelState obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.channel)
      ..writeByte(1)
      ..write(obj.messages)
      ..writeByte(2)
      ..write(obj.members)
      ..writeByte(3)
      ..write(obj.watcherCount)
      ..writeByte(4)
      ..write(obj.watchers)
      ..writeByte(5)
      ..write(obj.read);
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChannelState _$ChannelStateFromJson(Map<String, dynamic> json) {
  return ChannelState(
    channel: json['channel'] == null
        ? null
        : ChannelModel.fromJson(json['channel'] as Map<String, dynamic>),
    messages: (json['messages'] as List)
        ?.map((e) =>
            e == null ? null : Message.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    members: (json['members'] as List)
        ?.map((e) =>
            e == null ? null : Member.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    watcherCount: json['watcher_count'] as int,
    watchers: (json['watchers'] as List)
        ?.map(
            (e) => e == null ? null : User.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    read: (json['read'] as List)
        ?.map(
            (e) => e == null ? null : Read.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$ChannelStateToJson(ChannelState instance) =>
    <String, dynamic>{
      'channel': instance.channel?.toJson(),
      'messages': instance.messages?.map((e) => e?.toJson())?.toList(),
      'members': instance.members?.map((e) => e?.toJson())?.toList(),
      'watcher_count': instance.watcherCount,
      'watchers': instance.watchers?.map((e) => e?.toJson())?.toList(),
      'read': instance.read?.map((e) => e?.toJson())?.toList(),
    };
