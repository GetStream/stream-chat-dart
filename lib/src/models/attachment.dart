import 'package:json_annotation/json_annotation.dart';
import 'action.dart';
import 'serialization.dart';

part 'attachment.g.dart';

@JsonSerializable(includeIfNull: false)
class Attachment {
  final String type;
  final String titleLink;
  final String title;
  final String thumbUrl;
  final String text;
  final String pretext;
  final String ogScrapeUrl;
  final String imageUrl;
  final String footerIcon;
  final String footer;
  final dynamic fields;
  final String fallback;
  final String color;
  final String authorName;
  final String authorLink;
  final String authorIcon;
  final String assetUrl;
  final List<Action> actions;

  @JsonKey(includeIfNull: false)
  final Map<String, dynamic> extraData;

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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Attachment &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          titleLink == other.titleLink &&
          title == other.title &&
          thumbUrl == other.thumbUrl &&
          text == other.text &&
          pretext == other.pretext &&
          ogScrapeUrl == other.ogScrapeUrl &&
          imageUrl == other.imageUrl &&
          footerIcon == other.footerIcon &&
          footer == other.footer &&
          fields == other.fields &&
          fallback == other.fallback &&
          color == other.color &&
          authorName == other.authorName &&
          authorLink == other.authorLink &&
          authorIcon == other.authorIcon &&
          assetUrl == other.assetUrl &&
          actions == other.actions &&
          extraData == other.extraData;

  @override
  int get hashCode =>
      type.hashCode ^
      titleLink.hashCode ^
      title.hashCode ^
      thumbUrl.hashCode ^
      text.hashCode ^
      pretext.hashCode ^
      ogScrapeUrl.hashCode ^
      imageUrl.hashCode ^
      footerIcon.hashCode ^
      footer.hashCode ^
      fields.hashCode ^
      fallback.hashCode ^
      color.hashCode ^
      authorName.hashCode ^
      authorLink.hashCode ^
      authorIcon.hashCode ^
      assetUrl.hashCode ^
      actions.hashCode ^
      extraData.hashCode;
}
