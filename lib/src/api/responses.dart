import 'package:json_annotation/json_annotation.dart';
import 'package:stream_chat/src/models/device.dart';

import '../models/channel.dart';
import '../models/channel_state.dart';
import '../models/member.dart';
import '../models/message.dart';
import '../models/reaction.dart';
import '../models/read.dart';
import '../models/user.dart';

part 'responses.g.dart';

class BaseResponse {
  String duration;
}

@JsonSerializable(createToJson: false)
class QueryChannelsResponse extends BaseResponse {
  List<ChannelState> channels;

  static QueryChannelsResponse fromJson(Map<String, dynamic> json) =>
      _$QueryChannelsResponseFromJson(json);
}

@JsonSerializable(createToJson: false)
class QueryUsersResponse extends BaseResponse {
  List<User> users;

  static QueryUsersResponse fromJson(Map<String, dynamic> json) =>
      _$QueryUsersResponseFromJson(json);
}

@JsonSerializable(createToJson: false)
class QueryReactionsResponse extends BaseResponse {
  List<Reaction> reactions;

  static QueryReactionsResponse fromJson(Map<String, dynamic> json) =>
      _$QueryReactionsResponseFromJson(json);
}

@JsonSerializable(createToJson: false)
class QueryRepliesResponse extends BaseResponse {
  List<Message> messages;

  static QueryRepliesResponse fromJson(Map<String, dynamic> json) =>
      _$QueryRepliesResponseFromJson(json);
}

@JsonSerializable(createToJson: false)
class ListDevicesResponse extends BaseResponse {
  List<Device> devices;

  static ListDevicesResponse fromJson(Map<String, dynamic> json) =>
      _$ListDevicesResponseFromJson(json);
}

@JsonSerializable(createToJson: false)
class SendFileResponse extends BaseResponse {
  // the url of the uploaded file
  String file;

  static SendFileResponse fromJson(Map<String, dynamic> json) =>
      _$SendFileResponseFromJson(json);
}

@JsonSerializable(createToJson: false)
class SendImageResponse extends BaseResponse {
  // the url of the uploaded file
  String file;

  static SendImageResponse fromJson(Map<String, dynamic> json) =>
      _$SendImageResponseFromJson(json);
}

@JsonSerializable(createToJson: false)
class SendReactionResponse extends BaseResponse {
  Message message;
  Reaction reaction;

  static SendReactionResponse fromJson(Map<String, dynamic> json) =>
      _$SendReactionResponseFromJson(json);
}

@JsonSerializable(createToJson: false)
class SetGuestUserResponse extends BaseResponse {
  String accessToken;
  User user;

  static SetGuestUserResponse fromJson(Map<String, dynamic> json) =>
      _$SetGuestUserResponseFromJson(json);
}

@JsonSerializable(createToJson: false)
class UpdateUsersResponse extends BaseResponse {
  Map<String, User> users;

  static UpdateUsersResponse fromJson(Map<String, dynamic> json) =>
      _$UpdateUsersResponseFromJson(json);
}

@JsonSerializable(createToJson: false)
class UpdateMessageResponse extends BaseResponse {
  Message message;

  static UpdateMessageResponse fromJson(Map<String, dynamic> json) =>
      _$UpdateMessageResponseFromJson(json);
}

@JsonSerializable(createToJson: false)
class SendMessageResponse extends BaseResponse {
  Message message;

  static SendMessageResponse fromJson(Map<String, dynamic> json) =>
      _$SendMessageResponseFromJson(json);
}

@JsonSerializable(createToJson: false)
class GetMessageResponse extends BaseResponse {
  Message message;

  static GetMessageResponse fromJson(Map<String, dynamic> json) =>
      _$GetMessageResponseFromJson(json);
}

@JsonSerializable(createToJson: false)
class SearchMessagesResponse extends BaseResponse {
  List<Message> messages;

  static SearchMessagesResponse fromJson(Map<String, dynamic> json) =>
      _$SearchMessagesResponseFromJson(json);
}

@JsonSerializable(createToJson: false)
class GetMessagesByIdResponse extends BaseResponse {
  Message message;

  static GetMessagesByIdResponse fromJson(Map<String, dynamic> json) =>
      _$GetMessagesByIdResponseFromJson(json);
}

@JsonSerializable(createToJson: false)
class AddModeratorsResponse extends BaseResponse {
  Channel channel;
  List<Member> members;
  Message message;

  static AddModeratorsResponse fromJson(Map<String, dynamic> json) =>
      _$AddModeratorsResponseFromJson(json);
}

@JsonSerializable(createToJson: false)
class UpdateChannelResponse extends BaseResponse {
  Channel channel;
  List<Member> members;
  Message message;

  static UpdateChannelResponse fromJson(Map<String, dynamic> json) =>
      _$UpdateChannelResponseFromJson(json);
}

@JsonSerializable(createToJson: false)
class InviteMembersResponse extends BaseResponse {
  Channel channel;
  List<Member> members;
  Message message;

  static InviteMembersResponse fromJson(Map<String, dynamic> json) =>
      _$InviteMembersResponseFromJson(json);
}

@JsonSerializable(createToJson: false)
class RemoveMembersResponse extends BaseResponse {
  Channel channel;
  List<Member> members;
  Message message;

  static RemoveMembersResponse fromJson(Map<String, dynamic> json) =>
      _$RemoveMembersResponseFromJson(json);
}

@JsonSerializable(createToJson: false)
class SendActionResponse extends BaseResponse {
  Message message;

  static SendActionResponse fromJson(Map<String, dynamic> json) =>
      _$SendActionResponseFromJson(json);
}

@JsonSerializable(createToJson: false)
class AddMembersResponse extends BaseResponse {
  Channel channel;
  List<Member> members;
  Message message;

  static AddMembersResponse fromJson(Map<String, dynamic> json) =>
      _$AddMembersResponseFromJson(json);
}

@JsonSerializable(createToJson: false)
class AcceptInviteResponse extends BaseResponse {
  Channel channel;
  List<Member> members;
  Message message;

  static AcceptInviteResponse fromJson(Map<String, dynamic> json) =>
      _$AcceptInviteResponseFromJson(json);
}

@JsonSerializable(createToJson: false)
class RejectInviteResponse extends BaseResponse {
  Channel channel;
  List<Member> members;
  Message message;

  static RejectInviteResponse fromJson(Map<String, dynamic> json) =>
      _$RejectInviteResponseFromJson(json);
}

@JsonSerializable(createToJson: false)
class DemoteModeratorsResponse extends BaseResponse {
  Channel channel;
  List<Member> members;
  Message message;

  static DemoteModeratorsResponse fromJson(Map<String, dynamic> json) =>
      _$DemoteModeratorsResponseFromJson(json);
}

@JsonSerializable(createToJson: false)
class EmptyResponse extends BaseResponse {
  static EmptyResponse fromJson(Map<String, dynamic> json) =>
      _$EmptyResponseFromJson(json);
}

@JsonSerializable(createToJson: false)
class ChannelStateResponse extends BaseResponse {
  final Channel channel;
  final List<Message> messages;
  final List<Member> members;
  final int watcherCount;
  final List<Read> read;

  ChannelStateResponse(
      this.channel, this.messages, this.members, this.watcherCount, this.read);

  static ChannelStateResponse fromJson(Map<String, dynamic> json) =>
      _$ChannelStateResponseFromJson(json);
}
