import 'package:json_annotation/json_annotation.dart';
import 'action.dart';
import 'serialization.dart';

part 'attachment.g.dart';

/// The class that contains the information about an attachment
@JsonSerializable(includeIfNull: false)
class Attachment {
  /// The type of this attachment
  final String type;

  /// The link of this attachment title
  final String titleLink;

  /// The attachment title
  final String title;

  /// The url of the thumbnail of this attachment
  final String thumbUrl;

  /// The text of this attachment
  final String text;
  final String pretext;

  /// Open graph scrape url
  final String ogScrapeUrl;

  /// Image url of the attachment
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

  /// Actions related to the attachment
  final List<Action> actions;

  /// Map of custom channel extraData
  @JsonKey(includeIfNull: false)
  final Map<String, dynamic> extraData;

  /// Known top level fields.
  /// Useful for [Serialization] methods.
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

  /// Constructor used for json serialization
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

  /// Create a new instance from a json
  factory Attachment.fromJson(Map<String, dynamic> json) =>
      _$AttachmentFromJson(Serialization.moveKeysToRoot(json, topLevelFields));

  /// Serialize to json
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
