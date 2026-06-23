import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../error/exceptions.dart';

/// Resolves the current UI language code (e.g. `tr`, `en`, `ar`) so requests
/// carry the right `Accept-Language` and the backend localizes its emails.
typedef LanguageProvider = String Function();

/// Thin wrapper around [http.Client] that centralizes headers, JSON encoding
/// and error translation so data sources stay declarative.
class ApiClient {
  ApiClient({http.Client? client, LanguageProvider? languageProvider})
      : _client = client ?? http.Client(),
        _languageProvider = languageProvider;

  final http.Client _client;
  final LanguageProvider? _languageProvider;

  Map<String, String> get _headers => <String, String>{
        'Content-Type': 'application/json',
        'Accept-Language': _languageProvider?.call() ?? 'tr',
      };

  Future<Map<String, dynamic>> post(
    String url, {
    Map<String, dynamic>? body,
  }) async {
    try {
      final http.Response response = await _client.post(
        Uri.parse(url),
        headers: _headers,
        body: body == null ? null : jsonEncode(body),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (response.body.isEmpty) return <String, dynamic>{};
        return jsonDecode(response.body) as Map<String, dynamic>;
      }

      throw ServerException(response.body, response.statusCode);
    } on SocketException {
      throw const NetworkException();
    } on http.ClientException catch (e) {
      throw NetworkException(e.message);
    }
  }
}
