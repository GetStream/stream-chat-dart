import 'package:json_annotation/json_annotation.dart';

part 'requests.g.dart';

@JsonSerializable(createFactory: false)
class SortOption {
  static const ASC = 1;
  static const DESC = -1;

  final String field;
  final int direction;

  SortOption(this.field, {this.direction = DESC});

  Map<String, dynamic> toJson() => _$SortOptionToJson(this);
}

@JsonSerializable(createFactory: false)
class QueryFilter {
  Map<String, dynamic> toJson() => _$QueryFilterToJson(this);
}

@JsonSerializable(createFactory: false)
class PaginationParams {
  Map<String, dynamic> toJson() => _$PaginationParamsToJson(this);
}
