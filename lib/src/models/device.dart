import 'package:json_annotation/json_annotation.dart';

part 'device.g.dart';

@JsonSerializable()
class Device {
  final String id;
  final String pushProvider;

  Device({
    this.id,
    this.pushProvider,
  });

  factory Device.fromJson(Map<String, dynamic> json) => _$DeviceFromJson(json);
  Map<String, dynamic> toJson() => _$DeviceToJson(this);
}
