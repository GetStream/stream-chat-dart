import 'package:json_annotation/json_annotation.dart';
import 'action.dart';
import 'serialization.dart';

part 'attachment.g.dart';

@JsonSerializable(explicitToJson: true)
class Attachment {
  String type;

  @JsonKey(name: 'title_link')
  String titleLink;

  String title;

  @JsonKey(name: 'thumb_url')
  String thumbURL;

  String text;
  String pretext;

  @JsonKey(name: 'og_scrape_url')
  String ogScrapeURL;

  @JsonKey(name: 'image_url')
  String imageURL;

  @JsonKey(name: 'footer_icon')
  String footerIcon;

  String footer;
  dynamic fields;
  String fallback;
  String color;

  @JsonKey(name: 'author_name')
  String authorName;

  @JsonKey(name: 'author_link')
  String authorLink;

  @JsonKey(name: 'author_icon')
  String authorIcon;

  @JsonKey(name: 'asset_url')
  String assetURL;

  List<Action> actions;

  @JsonKey(includeIfNull: false)
  Map<String, dynamic> extraData;

  static const topLevelFields = const [
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

  Attachment(
      this.type,
      this.titleLink,
      this.title,
      this.thumbURL,
      this.text,
      this.pretext,
      this.ogScrapeURL,
      this.imageURL,
      this.footerIcon,
      this.footer,
      this.fields,
      this.fallback,
      this.color,
      this.authorName,
      this.authorLink,
      this.authorIcon,
      this.assetURL,
      this.actions,
      this.extraData);

  factory Attachment.fromJson(Map<String, dynamic> json) =>
      _$AttachmentFromJson(Serialization.moveKeysToRoot(json, topLevelFields));

  Map<String, dynamic> toJson() => Serialization.moveKeysToMapInPlace(
      _$AttachmentToJson(this), topLevelFields);
}
