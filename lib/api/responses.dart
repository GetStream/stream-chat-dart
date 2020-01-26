import '../models/channel_state.dart';
import 'package:json_annotation/json_annotation.dart';

part 'responses.g.dart';

@JsonSerializable(explicitToJson: true)
class QueryChannelsResponse {
  List<ChannelState> channels;
  String duration;

  QueryChannelsResponse(this.duration, this.channels);

  factory QueryChannelsResponse.fromJson(Map<String, dynamic> json) => _$QueryChannelsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$QueryChannelsResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class EmptyResponse {
  String duration;

  EmptyResponse(this.duration);

  factory EmptyResponse.fromJson(Map<String, dynamic> json) => _$EmptyResponseFromJson(json);
  Map<String, dynamic> toJson() => _$EmptyResponseToJson(this);
}
