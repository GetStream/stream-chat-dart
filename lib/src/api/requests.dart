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

@JsonSerializable(createFactory: false, includeIfNull: false)
class PaginationParams {
  final int limit;
  final int offset;

  @JsonKey(name: 'id_gt')
  final String greaterThan;
  @JsonKey(name: 'id_gte')
  final String greaterThanOrEqual;
  @JsonKey(name: 'id_lt')
  final String lessThan;
  @JsonKey(name: 'id_lte')
  final String lessThanOrEqual;

  PaginationParams({
    this.limit,
    this.offset,
    this.greaterThan,
    this.greaterThanOrEqual,
    this.lessThan,
    this.lessThanOrEqual,
  });

  Map<String, dynamic> toJson() => _$PaginationParamsToJson(this);

  PaginationParams copyWith({
    int limit,
    int offset,
    String greaterThan,
    String greaterThanOrEqual,
    String lessThan,
    String lessThanOrEqual,
  }) =>
      PaginationParams(
        limit: limit ?? this.limit,
        offset: offset ?? this.offset,
        greaterThan: greaterThan ?? this.greaterThan,
        greaterThanOrEqual: greaterThanOrEqual ?? this.greaterThanOrEqual,
        lessThan: lessThan ?? this.lessThan,
        lessThanOrEqual: lessThanOrEqual ?? this.lessThanOrEqual,
      );
}
