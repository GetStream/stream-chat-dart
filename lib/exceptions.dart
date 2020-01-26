import 'dart:convert';

class ApiError implements Exception {

  final String body;
  final Map<String, dynamic> parsedError;
  final int statusCode;

  static Map<String, dynamic> decode(String body) {
    try {
      return json.decode(body);
    } on FormatException {
      return null;
    }
  }

  ApiError(this.body, this.statusCode) : parsedError = decode(body);

  @override
  String toString() {
    return 'ApiError {body: $body, statusCode: $statusCode}';
  }

}