import 'package:json_annotation/json_annotation.dart';
import '../models/user.dart';

part 'member.g.dart';

@JsonSerializable()
class Member {
  User user;
  DateTime inviteAcceptedAt;
  DateTime inviteRejectedAt;
  bool invited;
  String role;
  String userId;
  bool isModerator;
  DateTime createdAt;
  DateTime updatedAt;

  Member(this.user, this.inviteAcceptedAt, this.inviteRejectedAt, this.invited,
      this.role, this.userId, this.isModerator, this.createdAt, this.updatedAt);

  factory Member.fromJson(Map<String, dynamic> json) => _$MemberFromJson(json);
  Map<String, dynamic> toJson() => _$MemberToJson(this);
}
