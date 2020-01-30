import 'package:json_annotation/json_annotation.dart';

part 'requests.g.dart';

@JsonSerializable(explicitToJson: true)
class SortOption {
  static const ASC = 1;
  static const DESC = -1;

  final String field;
  final int direction;

  SortOption(this.field, {this.direction = DESC});

  static SortOption fromJson(Map<String, dynamic> json) =>
      _$SortOptionFromJson(json);

  Map<String, dynamic> toJson() => _$SortOptionToJson(this);
}

@JsonSerializable(explicitToJson: true)
class QueryFilter {
  static QueryFilter fromJson(Map<String, dynamic> json) =>
      _$QueryFilterFromJson(json);

  Map<String, dynamic> toJson() => _$QueryFilterToJson(this);
}

@JsonSerializable(explicitToJson: true)
class PaginationParams {
  static PaginationParams fromJson(Map<String, dynamic> json) =>
      _$PaginationParamsFromJson(json);

  Map<String, dynamic> toJson() => _$PaginationParamsToJson(this);
}
