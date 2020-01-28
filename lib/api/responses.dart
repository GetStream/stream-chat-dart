import 'package:stream_chat_dart/models/channel.dart';
import 'package:stream_chat_dart/models/member.dart';
import 'package:stream_chat_dart/models/message.dart';
import 'package:stream_chat_dart/models/reaction.dart';
import 'package:stream_chat_dart/models/user.dart';

import '../models/channel_state.dart';
import 'package:json_annotation/json_annotation.dart';

part 'responses.g.dart';

@JsonSerializable(explicitToJson: true)
class QueryChannelsResponse {
  List<ChannelState> channels;
  String duration;

  QueryChannelsResponse(this.duration, this.channels);

  static QueryChannelsResponse fromJson(Map<String, dynamic> json) =>
      _$QueryChannelsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$QueryChannelsResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class SendFileResponse {
  // the url of the uploaded file
  String file;
  String duration;

  SendFileResponse(this.duration, this.file);

  static SendFileResponse fromJson(Map<String, dynamic> json) =>
      _$SendFileResponseFromJson(json);
  Map<String, dynamic> toJson() => _$SendFileResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class SendImageResponse {
  // the url of the uploaded file
  String file;
  String duration;

  SendImageResponse(this.duration, this.file);

  static SendImageResponse fromJson(Map<String, dynamic> json) =>
      _$SendImageResponseFromJson(json);
  Map<String, dynamic> toJson() => _$SendImageResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class SendReactionResponse {
  Message message;
  Reaction reaction;
  String duration;

  SendReactionResponse(this.duration, this.message, this.reaction);

  static SendReactionResponse fromJson(Map<String, dynamic> json) =>
      _$SendReactionResponseFromJson(json);
  Map<String, dynamic> toJson() => _$SendReactionResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class SetGuestUserResponse {
  @JsonKey(name: 'access_token')
  String accessToken;
  User user;
  String duration;

  SetGuestUserResponse(this.duration, this.accessToken, this.user);

  static SetGuestUserResponse fromJson(Map<String, dynamic> json) =>
      _$SetGuestUserResponseFromJson(json);
  Map<String, dynamic> toJson() => _$SetGuestUserResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class UpdateUsersResponse {
  Map<String, User> users;
  String duration;

  UpdateUsersResponse(this.duration, this.users);

  static UpdateUsersResponse fromJson(Map<String, dynamic> json) =>
      _$UpdateUsersResponseFromJson(json);
  Map<String, dynamic> toJson() => _$UpdateUsersResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class UpdateMessageResponse {
  Message message;
  String duration;

  UpdateMessageResponse(this.duration, this.message);

  static UpdateMessageResponse fromJson(Map<String, dynamic> json) =>
      _$UpdateMessageResponseFromJson(json);
  Map<String, dynamic> toJson() => _$UpdateMessageResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class SendMessageResponse {
  Message message;
  String duration;

  SendMessageResponse(this.duration, this.message);

  static SendMessageResponse fromJson(Map<String, dynamic> json) =>
      _$SendMessageResponseFromJson(json);
  Map<String, dynamic> toJson() => _$SendMessageResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GetMessageResponse {
  Message message;
  String duration;

  GetMessageResponse(this.duration, this.message);

  static GetMessageResponse fromJson(Map<String, dynamic> json) =>
      _$GetMessageResponseFromJson(json);
  Map<String, dynamic> toJson() => _$GetMessageResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class AddModeratorsResponse {
  Channel channel;
  String duration;

  AddModeratorsResponse(this.duration, this.channel);

  static AddModeratorsResponse fromJson(Map<String, dynamic> json) =>
      _$AddModeratorsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$AddModeratorsResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class InviteMembersResponse {
  Channel channel;
  String duration;

  InviteMembersResponse(this.duration, this.channel);

  static InviteMembersResponse fromJson(Map<String, dynamic> json) =>
      _$InviteMembersResponseFromJson(json);
  Map<String, dynamic> toJson() => _$InviteMembersResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class RemoveMembersResponse {
  Channel channel;
  String duration;

  RemoveMembersResponse(this.duration, this.channel);

  static RemoveMembersResponse fromJson(Map<String, dynamic> json) =>
      _$RemoveMembersResponseFromJson(json);
  Map<String, dynamic> toJson() => _$RemoveMembersResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class AddMembersResponse {
  Channel channel;
  String duration;

  AddMembersResponse(this.duration, this.channel);

  static AddMembersResponse fromJson(Map<String, dynamic> json) =>
      _$AddMembersResponseFromJson(json);
  Map<String, dynamic> toJson() => _$AddMembersResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class EmptyResponse {
  String duration;

  EmptyResponse(this.duration);

  static EmptyResponse fromJson(Map<String, dynamic> json) =>
      _$EmptyResponseFromJson(json);
  Map<String, dynamic> toJson() => _$EmptyResponseToJson(this);
}
