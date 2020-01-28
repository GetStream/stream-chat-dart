import 'package:stream_chat_dart/models/message.dart';
import 'package:stream_chat_dart/models/reaction.dart';

import '../models/channel_state.dart';
import 'package:json_annotation/json_annotation.dart';

part 'responses.g.dart';

@JsonSerializable(explicitToJson: true)
class QueryChannelsResponse {
  List<ChannelState> channels;
  String duration;

  QueryChannelsResponse(this.duration, this.channels);

  static QueryChannelsResponse fromJson(Map<String, dynamic> json) => _$QueryChannelsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$QueryChannelsResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class SendFileResponse {
  // the url of the uploaded file
  String file;
  String duration;

  SendFileResponse(this.duration, this.file);

  static SendFileResponse fromJson(Map<String, dynamic> json) => _$SendFileResponseFromJson(json);
  Map<String, dynamic> toJson() => _$SendFileResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class SendImageResponse {
  // the url of the uploaded file
  String file;
  String duration;

  SendImageResponse(this.duration, this.file);

  static SendImageResponse fromJson(Map<String, dynamic> json) => _$SendImageResponseFromJson(json);
  Map<String, dynamic> toJson() => _$SendImageResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class SendReactionResponse {
  Message message;
  Reaction reaction;
  String duration;

  SendReactionResponse(this.duration, this.message, this.reaction);

  static SendReactionResponse fromJson(Map<String, dynamic> json) => _$SendReactionResponseFromJson(json);
  Map<String, dynamic> toJson() => _$SendReactionResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class EmptyResponse {
  String duration;

  EmptyResponse(this.duration);

  static EmptyResponse fromJson(Map<String, dynamic> json) => _$EmptyResponseFromJson(json);
  Map<String, dynamic> toJson() => _$EmptyResponseToJson(this);
}
