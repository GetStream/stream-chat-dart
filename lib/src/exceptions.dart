import 'dart:convert';

import 'package:dio/dio.dart';

class ApiError implements Exception {
  final String body;
  final Map<String, dynamic> data;
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

  ApiError(this.body, this.status) : data = _decode(body) {
    if (data?.containsKey('code') ?? false) {
      _code = data['code'];
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ApiError &&
          runtimeType == other.runtimeType &&
          body == other.body &&
          data == other.data &&
          status == other.status &&
          _code == other._code;

  @override
  int get hashCode =>
      body.hashCode ^ data.hashCode ^ status.hashCode ^ _code.hashCode;

  @override
  String toString() {
    return 'ApiError{body: $body, data: $data, status: $status, code: $_code}';
  }
}
