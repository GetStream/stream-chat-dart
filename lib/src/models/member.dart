import 'package:json_annotation/json_annotation.dart';
import '../models/user.dart';

part 'member.g.dart';

@JsonSerializable()
class Member {
  final User user;
  final DateTime inviteAcceptedAt;
  final DateTime inviteRejectedAt;
  final bool invited;
  final String role;
  final String userId;
  final bool isModerator;
  final DateTime createdAt;
  final DateTime updatedAt;

  Member({
    this.user,
    this.inviteAcceptedAt,
    this.inviteRejectedAt,
    this.invited,
    this.role,
    this.userId,
    this.isModerator,
    this.createdAt,
    this.updatedAt,
  });

  factory Member.fromJson(Map<String, dynamic> json) => _$MemberFromJson(json);
  Map<String, dynamic> toJson() => _$MemberToJson(this);
}
