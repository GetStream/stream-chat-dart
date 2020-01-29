// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'requests.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SortOption _$SortOptionFromJson(Map<String, dynamic> json) {
  return SortOption(
    field: json['field'] as String,
    direction: json['direction'] as int,
  );
}

Map<String, dynamic> _$SortOptionToJson(SortOption instance) =>
    <String, dynamic>{
      'field': instance.field,
      'direction': instance.direction,
    };

QueryFilter _$QueryFilterFromJson(Map<String, dynamic> json) {
  return QueryFilter();
}

Map<String, dynamic> _$QueryFilterToJson(QueryFilter instance) =>
    <String, dynamic>{};
