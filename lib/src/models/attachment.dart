import 'package:json_annotation/json_annotation.dart';
import 'action.dart';
import 'serialization.dart';

part 'attachment.g.dart';

@JsonSerializable(includeIfNull: false)
class Attachment {
  String type;
  String titleLink;
  String title;
  String thumbUrl;
  String text;
  String pretext;
  String ogScrapeUrl;
  String imageUrl;
  String footerIcon;
  String footer;
  dynamic fields;
  String fallback;
  String color;
  String authorName;
  String authorLink;
  String authorIcon;
  String assetUrl;
  List<Action> actions;

  @JsonKey(includeIfNull: false)
  Map<String, dynamic> extraData;

  static const topLevelFields = [
    'type',
    'title_link',
    'title',
    'thumb_url',
    'text',
    'pretext',
    'og_scrape_url',
    'image_url',
    'footer_icon',
    'footer',
    'fields',
    'fallback',
    'color',
    'author_name',
    'author_link',
    'author_icon',
    'asset_url',
    'actions',
  ];

  Attachment({
    this.type,
    this.titleLink,
    this.title,
    this.thumbUrl,
    this.text,
    this.pretext,
    this.ogScrapeUrl,
    this.imageUrl,
    this.footerIcon,
    this.footer,
    this.fields,
    this.fallback,
    this.color,
    this.authorName,
    this.authorLink,
    this.authorIcon,
    this.assetUrl,
    this.actions,
    this.extraData,
  });

  factory Attachment.fromJson(Map<String, dynamic> json) =>
      _$AttachmentFromJson(Serialization.moveKeysToRoot(json, topLevelFields));

  Map<String, dynamic> toJson() => Serialization.moveKeysToMapInPlace(
      _$AttachmentToJson(this), topLevelFields);
}
