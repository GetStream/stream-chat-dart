import 'package:json_annotation/json_annotation.dart';
import 'package:stream_chat_dart/models/user.dart';

part 'member.g.dart';

@JsonSerializable(explicitToJson: true)
class Member {
  User user;

  @JsonKey(name: 'invite_accepted_at')
  DateTime inviteAcceptedAt;

  @JsonKey(name: 'invite_rejected_at')
  DateTime inviteRejectedAt;

  bool invited;
  String role;

  @JsonKey(name: 'user_id')
  String userID;

  @JsonKey(name: 'is_moderator')
  bool isModerator;

  @JsonKey(name: 'created_at')
  DateTime createdAt;

  @JsonKey(name: 'updated_at')
  DateTime updatedAt;

  Member(this.user, this.inviteAcceptedAt, this.inviteRejectedAt, this.invited,
      this.role, this.userID, this.isModerator, this.createdAt, this.updatedAt);

  factory Member.fromJson(Map<String, dynamic> json) => _$MemberFromJson(json);
  Map<String, dynamic> toJson() => _$MemberToJson(this);
}
