import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';
part 'requests.g.dart';



@JsonSerializable(explicitToJson: true)
class SortOption {

  static const ASC  = 1;
  static const DESC  = -1;

  final String field;
  final int direction;

  SortOption({@required this.field, this.direction = DESC});

  factory SortOption.fromJson(Map<String, dynamic> json) => _$SortOptionFromJson(json);
  Map<String, dynamic> toJson() => _$SortOptionToJson(this);

}

@JsonSerializable(explicitToJson: true)
class QueryFilter {
  QueryFilter();

  factory QueryFilter.fromJson(Map<String, dynamic> json) => _$QueryFilterFromJson(json);
  Map<String, dynamic> toJson() => _$QueryFilterToJson(this);
}

class PaginationParams {}
