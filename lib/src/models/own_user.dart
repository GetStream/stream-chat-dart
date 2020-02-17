import 'package:json_annotation/json_annotation.dart';

import 'device.dart';
import 'mute.dart';
import 'serialization.dart';
import 'user.dart';

part 'own_user.g.dart';

@JsonSerializable()
class OwnUser extends User {
  @JsonKey(includeIfNull: false, toJson: Serialization.readOnly)
  final List<Device> devices;

  @JsonKey(includeIfNull: false, toJson: Serialization.readOnly)
  final List<Mute> mutes;

  @JsonKey(includeIfNull: false, toJson: Serialization.readOnly)
  final int totalUnreadCount;

  @JsonKey(includeIfNull: false, toJson: Serialization.readOnly)
  final int unreadChannels;

  static final topLevelFields = [
    'devices',
    'mutes',
    'total_unread_count',
    'unread_channels',
  ]..addAll(User.topLevelFields);

  OwnUser({
    this.devices,
    this.mutes,
    this.totalUnreadCount,
    this.unreadChannels,
    String id,
    String role,
    DateTime createdAt,
    DateTime updatedAt,
    DateTime lastActive,
    bool online,
    Map<String, dynamic> extraData,
    bool banned,
  }) : super(
          id: id,
          role: role,
          createdAt: createdAt,
          updatedAt: updatedAt,
          lastActive: lastActive,
          online: online,
          extraData: extraData,
          banned: banned,
        );

  factory OwnUser.fromJson(Map<String, dynamic> json) {
    return _$OwnUserFromJson(
        Serialization.moveKeysToRoot(json, topLevelFields));
  }

  Map<String, dynamic> toJson() {
    return Serialization.moveKeysToMapInPlace(
        _$OwnUserToJson(this), topLevelFields);
  }
}
