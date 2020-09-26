import 'user.dart';

/// Used to avoid to serialize properties to json
Null readonly(_) => null;

/// Helper class for serialization to and from json
class Serialization {
  /// Used to avoid to serialize properties to json
  static const Function readOnly = readonly;

  /// List of users to list of userIds
  static List<String> userIds(List<User> users) {
    return users?.map((u) => u.id)?.toList();
  }

  /// Takes unknown json keys and puts them in the `extra_data` key
  static Map<String, dynamic> moveToExtraDataFromRoot(
    Map<String, dynamic> json,
    List<String> topLevelFields,
  ) {
    final extraDataFields = Map<String, dynamic>.from(json)
      ..removeWhere(
        (key, value) => topLevelFields.contains(key),
      );
    final rootFields = json..remove(extraDataFields.keys);
    return {
      ...rootFields,
      ...{
        'extra_data': extraDataFields,
      },
    };
  }

  /// Takes values in `extra_data` key and puts them on the root level of the json map
  static Map<String, dynamic> moveFromExtraDataToRoot(
    Map<String, dynamic> json,
    List<String> topLevelFields,
  ) {
    return {
      ...json,
      if (json['extra_data'] != null) ...json['extra_data'],
    };
  }
}
