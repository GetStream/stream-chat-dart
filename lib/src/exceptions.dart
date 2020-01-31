import 'dart:convert';

class ApiError implements Exception {
  final String body;
  final Map<String, dynamic> data;
  final int statusCode;

  static Map<String, dynamic> _decode(String body) {
    try {
      return json.decode(body);
    } on FormatException {
      return null;
    }
  }

  ApiError(this.body, this.statusCode) : data = _decode(body);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ApiError &&
          runtimeType == other.runtimeType &&
          body == other.body &&
          data == other.data &&
          statusCode == other.statusCode;

  @override
  int get hashCode => body.hashCode ^ data.hashCode ^ statusCode.hashCode;

  @override
  String toString() {
    return 'ApiError {body: $body, statusCode: $statusCode}';
  }
}
