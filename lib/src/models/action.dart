import 'package:json_annotation/json_annotation.dart';

part 'action.g.dart';

@JsonSerializable()
class Action {
  final String name;
  final String style;
  final String text;
  final String type;
  final String value;

  Action({this.name, this.style, this.text, this.type, this.value});

  factory Action.fromJson(Map<String, dynamic> json) => _$ActionFromJson(json);

  Map<String, dynamic> toJson() => _$ActionToJson(this);
}
