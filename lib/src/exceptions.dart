import 'dart:convert';

import 'package:dio/dio.dart';

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

  factory ApiError.fromDioError(DioError error) {
    switch (error.type) {
      case DioErrorType.RESPONSE:
        return ApiError(error.response.data, error.response.statusCode);
      case DioErrorType.CONNECT_TIMEOUT:
      // TODO: Handle this case.
      case DioErrorType.SEND_TIMEOUT:
      // TODO: Handle this case.
      case DioErrorType.RECEIVE_TIMEOUT:
      // TODO: Handle this case.
      case DioErrorType.CANCEL:
      // TODO: Handle this case.
      case DioErrorType.DEFAULT:
      // TODO: Handle this case.
      default:
        return ApiError(error.response.data, error.response.statusCode);
    }
  }

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
