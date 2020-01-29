import 'package:stream_chat/src/models/device.dart';

import '../models/channel_state.dart';
import '../models/message.dart';
import '../models/user.dart';
import '../models/channel.dart';
import '../models/member.dart';
import '../models/reaction.dart';

import 'package:json_annotation/json_annotation.dart';

part 'responses.g.dart';

abstract class BaseResponse {
  String duration;
}

@JsonSerializable(explicitToJson: true)
class QueryChannelsResponse extends BaseResponse {
  List<ChannelState> channels;

  static QueryChannelsResponse fromJson(Map<String, dynamic> json) =>
      _$QueryChannelsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$QueryChannelsResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class QueryUsersResponse extends BaseResponse {
  List<User> users;

  static QueryUsersResponse fromJson(Map<String, dynamic> json) =>
      _$QueryUsersResponseFromJson(json);

  Map<String, dynamic> toJson() => _$QueryUsersResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class QueryReactionsResponse extends BaseResponse {
  List<Reaction> reactions;

  static QueryReactionsResponse fromJson(Map<String, dynamic> json) =>
      _$QueryReactionsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$QueryReactionsResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class QueryRepliesResponse extends BaseResponse {
  List<Message> messages;

  static QueryRepliesResponse fromJson(Map<String, dynamic> json) =>
      _$QueryRepliesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$QueryRepliesResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ListDevicesResponse extends BaseResponse {
  List<Device> devices;

  static ListDevicesResponse fromJson(Map<String, dynamic> json) =>
      _$ListDevicesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ListDevicesResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class SendFileResponse extends BaseResponse {
  // the url of the uploaded file
  String file;

  static SendFileResponse fromJson(Map<String, dynamic> json) =>
      _$SendFileResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SendFileResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class SendImageResponse extends BaseResponse {
  // the url of the uploaded file
  String file;

  static SendImageResponse fromJson(Map<String, dynamic> json) =>
      _$SendImageResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SendImageResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class SendReactionResponse extends BaseResponse {
  Message message;
  Reaction reaction;

  static SendReactionResponse fromJson(Map<String, dynamic> json) =>
      _$SendReactionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SendReactionResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class SetGuestUserResponse extends BaseResponse {
  @JsonKey(name: 'access_token')
  String accessToken;
  User user;

  static SetGuestUserResponse fromJson(Map<String, dynamic> json) =>
      _$SetGuestUserResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SetGuestUserResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class UpdateUsersResponse extends BaseResponse {
  Map<String, User> users;

  static UpdateUsersResponse fromJson(Map<String, dynamic> json) =>
      _$UpdateUsersResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateUsersResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class UpdateMessageResponse extends BaseResponse {
  Message message;

  static UpdateMessageResponse fromJson(Map<String, dynamic> json) =>
      _$UpdateMessageResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateMessageResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class SendMessageResponse extends BaseResponse {
  Message message;

  static SendMessageResponse fromJson(Map<String, dynamic> json) =>
      _$SendMessageResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SendMessageResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GetMessageResponse extends BaseResponse {
  Message message;

  static GetMessageResponse fromJson(Map<String, dynamic> json) =>
      _$GetMessageResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetMessageResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class SearchMessagesResponse extends BaseResponse {
  List<Message> messages;

  static SearchMessagesResponse fromJson(Map<String, dynamic> json) =>
      _$SearchMessagesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SearchMessagesResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GetMessagesByIdResponse extends BaseResponse {
  Message message;

  static GetMessagesByIdResponse fromJson(Map<String, dynamic> json) =>
      _$GetMessagesByIdResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetMessagesByIdResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class AddModeratorsResponse extends BaseResponse {
  Channel channel;
  List<Member> members;
  Message message;

  static AddModeratorsResponse fromJson(Map<String, dynamic> json) =>
      _$AddModeratorsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AddModeratorsResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class UpdateChannelResponse extends BaseResponse {
  Channel channel;
  List<Member> members;
  Message message;

  static UpdateChannelResponse fromJson(Map<String, dynamic> json) =>
      _$UpdateChannelResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateChannelResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class InviteMembersResponse extends BaseResponse {
  Channel channel;
  List<Member> members;
  Message message;

  static InviteMembersResponse fromJson(Map<String, dynamic> json) =>
      _$InviteMembersResponseFromJson(json);

  Map<String, dynamic> toJson() => _$InviteMembersResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class RemoveMembersResponse extends BaseResponse {
  Channel channel;
  List<Member> members;
  Message message;

  static RemoveMembersResponse fromJson(Map<String, dynamic> json) =>
      _$RemoveMembersResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RemoveMembersResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class AddMembersResponse extends BaseResponse {
  Channel channel;
  List<Member> members;
  Message message;

  static AddMembersResponse fromJson(Map<String, dynamic> json) =>
      _$AddMembersResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AddMembersResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class DemoteModeratorsResponse extends BaseResponse {
  Channel channel;
  List<Member> members;
  Message message;

  static DemoteModeratorsResponse fromJson(Map<String, dynamic> json) =>
      _$DemoteModeratorsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DemoteModeratorsResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class EmptyResponse extends BaseResponse {
  static EmptyResponse fromJson(Map<String, dynamic> json) =>
      _$EmptyResponseFromJson(json);

  Map<String, dynamic> toJson() => _$EmptyResponseToJson(this);
}
