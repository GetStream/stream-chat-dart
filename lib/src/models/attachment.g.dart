// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attachment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Attachment _$AttachmentFromJson(Map<String, dynamic> json) {
  return Attachment(
    json['type'] as String,
    json['title_link'] as String,
    json['title'] as String,
    json['thumb_url'] as String,
    json['text'] as String,
    json['pretext'] as String,
    json['og_scrape_url'] as String,
    json['image_u_r_l'] as String,
    json['footer_icon'] as String,
    json['footer'] as String,
    json['fields'],
    json['fallback'] as String,
    json['color'] as String,
    json['author_name'] as String,
    json['author_link'] as String,
    json['author_icon'] as String,
    json['asset_url'] as String,
    (json['actions'] as List)
        ?.map((e) =>
            e == null ? null : Action.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['extra_data'] as Map<String, dynamic>,
  );
}

Map<String, dynamic> _$AttachmentToJson(Attachment instance) {
  final val = <String, dynamic>{
    'type': instance.type,
    'title_link': instance.titleLink,
    'title': instance.title,
    'thumb_url': instance.thumbUrl,
    'text': instance.text,
    'pretext': instance.pretext,
    'og_scrape_url': instance.ogScrapeUrl,
    'image_u_r_l': instance.imageURL,
    'footer_icon': instance.footerIcon,
    'footer': instance.footer,
    'fields': instance.fields,
    'fallback': instance.fallback,
    'color': instance.color,
    'author_name': instance.authorName,
    'author_link': instance.authorLink,
    'author_icon': instance.authorIcon,
    'asset_url': instance.assetUrl,
    'actions': instance.actions?.map((e) => e?.toJson())?.toList(),
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('extra_data', instance.extraData);
  return val;
}
