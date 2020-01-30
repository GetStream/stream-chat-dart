import 'package:json_annotation/json_annotation.dart';

part 'command.g.dart';

@JsonSerializable()
class Command {
  final String name;
  final String description;
  final String args;

  Command({
    this.name,
    this.description,
    this.args,
  });

  factory Command.fromJson(Map<String, dynamic> json) =>
      _$CommandFromJson(json);
  Map<String, dynamic> toJson() => _$CommandToJson(this);
}
