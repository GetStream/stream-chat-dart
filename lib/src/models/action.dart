import 'package:json_annotation/json_annotation.dart';

part 'action.g.dart';

@JsonSerializable(explicitToJson: true)
class Action {
  String name;
  String style;
  String text;
  String type;
  String value;

  Action(this.name, this.style, this.text, this.type, this.value);

  factory Action.fromJson(Map<String, dynamic> json) => _$ActionFromJson(json);

  Map<String, dynamic> toJson() => _$ActionToJson(this);
}
