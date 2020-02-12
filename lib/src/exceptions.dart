import 'dart:convert';

class ApiError implements Exception {
  final String body;
  final Map<String, dynamic> jsonData;
  final int status;

  int _code;
  int get code => _code;

  static Map<String, dynamic> _decode(String body) {
    try {
      if (body == null) {
        return null;
      }
      return json.decode(body);
    } on FormatException {
      return null;
    }
  }

  ApiError(this.body, this.status) : jsonData = _decode(body) {
    if (jsonData != null && jsonData.containsKey('code')) {
      _code = jsonData['code'];
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ApiError &&
          runtimeType == other.runtimeType &&
          body == other.body &&
          jsonData == other.jsonData &&
          status == other.status &&
          _code == other._code;

  @override
  int get hashCode =>
      body.hashCode ^ jsonData.hashCode ^ status.hashCode ^ _code.hashCode;

  @override
  String toString() {
    return 'ApiError{body: $body, jsonData: $jsonData, status: $status, code: $_code}';
  }
}
