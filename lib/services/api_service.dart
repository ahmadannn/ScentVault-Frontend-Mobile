import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'https://scentvault-api.my.id/api';
  //static const String baseUrl = 'http://localhost:8000/api';
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  static Future<void> setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  static Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  static Future<Map<String, String>> _getAuthHeaders() async {
    final token = await getToken();
    return {
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // --- Helper GET ---
  static Future<dynamic> _get(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');
    if (kDebugMode) print('API GET Request: $url');
    try {
      final response = await http
          .get(url, headers: await _getAuthHeaders())
          .timeout(const Duration(seconds: 15));
      if (kDebugMode) print('API GET Response [$endpoint] - Status: ${response.statusCode}\nBody: ${response.body}');
      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return json.decode(response.body);
      } else {
        return {'error': true, 'message': 'Terjadi kesalahan server (${response.statusCode})'};
      }
    } on TimeoutException {
      if (kDebugMode) print('API GET Timeout: $url');
      return {'error': true, 'message': 'Koneksi terputus (Timeout). Periksa internet Anda.'};
    } catch (e) {
      if (kDebugMode) print('API GET Error: $url - $e');
      return {'error': true, 'message': 'Gagal terhubung ke server. Pastikan Anda sedang online.'};
    }
  }

  // --- Helper POST ---
  static Future<dynamic> _post(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('$baseUrl$endpoint');
    if (kDebugMode) print('API POST Request: $url\nBody: $body');
    try {
      final headers = await _getAuthHeaders();
      headers['Content-Type'] = 'application/json';
      
      final response = await http
          .post(url, headers: headers, body: json.encode(body))
          .timeout(const Duration(seconds: 15));
      if (kDebugMode) print('API POST Response [$endpoint] - Status: ${response.statusCode}\nBody: ${response.body}');
      
      return json.decode(response.body); // Let caller handle status code since login/register returns 401/422 normally
    } on TimeoutException {
      if (kDebugMode) print('API POST Timeout: $url');
      return {'error': true, 'message': 'Koneksi terputus (Timeout). Periksa internet Anda.'};
    } catch (e) {
      if (kDebugMode) print('API POST Error: $url - $e');
      return {'error': true, 'message': 'Gagal terhubung ke server. Pastikan Anda sedang online.'};
    }
  }

  // --- Helper DELETE ---
  static Future<dynamic> _delete(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');
    if (kDebugMode) print('API DELETE Request: $url');
    try {
      final response = await http
          .delete(url, headers: await _getAuthHeaders())
          .timeout(const Duration(seconds: 15));
      if (kDebugMode) print('API DELETE Response [$endpoint] - Status: ${response.statusCode}\nBody: ${response.body}');
      
      return json.decode(response.body);
    } on TimeoutException {
      return {'error': true, 'message': 'Koneksi terputus (Timeout). Periksa internet Anda.'};
    } catch (e) {
      return {'error': true, 'message': 'Gagal terhubung ke server.'};
    }
  }

  static Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await _post('/login', {
      'email': email,
      'password': password,
    });
    return response is Map<String, dynamic> ? response : {'message': 'Respons tidak valid'};
  }

  static Future<Map<String, dynamic>> register(String name, String email, String password, String passwordConfirmation, String regionCode) async {
    final response = await _post('/register', {
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': passwordConfirmation,
      'region_code': regionCode,
    });
    return response is Map<String, dynamic> ? response : {'message': 'Respons tidak valid'};
  }

  static Future<Map<String, dynamic>> logout() async {
    final response = await _post('/logout', {});
    await removeToken();
    return response is Map<String, dynamic> ? response : {'message': 'Respons tidak valid'};
  }

  static Future<List<dynamic>> getProvinces() async {
    final res = await _get('/region/provinces');
    return (res is List) ? res : [];
  }

  static Future<List<dynamic>> getRegencies(String provinceCode) async {
    final res = await _get('/region/regencies?province_code=$provinceCode');
    return (res is List) ? res : [];
  }

  static Future<List<dynamic>> getDistricts(String regencyCode) async {
    final res = await _get('/region/districts?regency_code=$regencyCode');
    return (res is List) ? res : [];
  }

  static Future<List<dynamic>> getVillages(String districtCode) async {
    final res = await _get('/region/villages?district_code=$districtCode');
    return (res is List) ? res : [];
  }

  static Future<Map<String, dynamic>> getHomePageData() async {
    final res = await _get('/pages/home');
    return (res is Map<String, dynamic>) ? res : {};
  }

  static Future<Map<String, dynamic>> getCollectionPageData() async {
    final res = await _get('/pages/perfume-collection');
    return (res is Map<String, dynamic>) ? res : {};
  }

  static Future<Map<String, dynamic>> getPerfumeDetail(int id) async {
    final res = await _get('/perfumes/$id');
    return (res is Map<String, dynamic>) ? res : {};
  }

  static Future<Map<String, dynamic>> deletePerfume(int id) async {
    final res = await _delete('/perfumes/$id');
    return (res is Map<String, dynamic>) ? res : {};
  }

  // --- Helper Multipart ---
  static Future<dynamic> _multipartRequest(String method, String endpoint, Map<String, dynamic> body, {Uint8List? imageBytes, String? imageFileName}) async {
    final url = Uri.parse('$baseUrl$endpoint');
    if (kDebugMode) print('API MULTIPART $method Request: $url\nBody: $body\nHasImage: ${imageBytes != null}');
    try {
      final headers = await _getAuthHeaders();
      
      var request = http.MultipartRequest(method, url);
      request.headers.addAll(headers);
      
      // Since it's PUT for update but multipart/form-data doesn't always play nice with PUT in PHP,
      // Laravel recommends using POST with _method=PUT field. We'll do that if method is PUT.
      if (method == 'PUT') {
        request = http.MultipartRequest('POST', url);
        request.headers.addAll(headers);
        request.fields['_method'] = 'PUT';
      }

      // Recursively add fields. For nested arrays like notes[0][name]
      _addFieldsToMultipart(request.fields, '', body);

      if (imageBytes != null && imageFileName != null) {
        request.files.add(http.MultipartFile.fromBytes(
          'image',
          imageBytes,
          filename: imageFileName,
        ));
      }

      final streamedResponse = await request.send().timeout(const Duration(seconds: 30));
      final response = await http.Response.fromStream(streamedResponse);
      
      if (kDebugMode) print('API MULTIPART Response [$endpoint] - Status: ${response.statusCode}\nBody: ${response.body}');
      return json.decode(response.body);
    } on TimeoutException {
      return {'error': true, 'message': 'Koneksi terputus (Timeout). Periksa internet Anda.'};
    } catch (e) {
      if (kDebugMode) print('API MULTIPART Error: $url - $e');
      return {'error': true, 'message': 'Gagal terhubung ke server.'};
    }
  }

  static void _addFieldsToMultipart(Map<String, String> fields, String prefix, dynamic value) {
    if (value is Map) {
      value.forEach((k, v) {
        final newPrefix = prefix.isEmpty ? k : '$prefix[$k]';
        _addFieldsToMultipart(fields, newPrefix, v);
      });
    } else if (value is List) {
      for (int i = 0; i < value.length; i++) {
        final newPrefix = '$prefix[$i]';
        _addFieldsToMultipart(fields, newPrefix, value[i]);
      }
    } else {
      fields[prefix] = value.toString();
    }
  }

  static Future<Map<String, dynamic>> addPerfume(Map<String, dynamic> body, {Uint8List? imageBytes, String? imageFileName}) async {
    final res = await _multipartRequest('POST', '/perfumes', body, imageBytes: imageBytes, imageFileName: imageFileName);
    return res is Map<String, dynamic> ? res : {};
  }

  // --- Helper PUT ---
  static Future<dynamic> _put(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('$baseUrl$endpoint');
    if (kDebugMode) print('API PUT Request: $url\nBody: $body');
    try {
      final headers = await _getAuthHeaders();
      headers['Content-Type'] = 'application/json';
      
      final response = await http
          .put(url, headers: headers, body: json.encode(body))
          .timeout(const Duration(seconds: 15));
      if (kDebugMode) print('API PUT Response [$endpoint] - Status: ${response.statusCode}\nBody: ${response.body}');
      
      return json.decode(response.body);
    } on TimeoutException {
      return {'error': true, 'message': 'Koneksi terputus (Timeout). Periksa internet Anda.'};
    } catch (e) {
      if (kDebugMode) print('API PUT Error: $url - $e');
      return {'error': true, 'message': 'Gagal terhubung ke server.'};
    }
  }

  static Future<Map<String, dynamic>> updatePerfume(int id, Map<String, dynamic> body, {Uint8List? imageBytes, String? imageFileName}) async {
    final res = await _multipartRequest('PUT', '/perfumes/$id', body, imageBytes: imageBytes, imageFileName: imageFileName);
    return res is Map<String, dynamic> ? res : {};
  }

  static Future<Map<String, dynamic>> getProfile() async {
    final res = await _get('/me');
    return (res is Map<String, dynamic>) ? res : {};
  }

  static Future<List<dynamic>> getOccasions() async {
    final res = await _get('/occasions');
    if (res is Map<String, dynamic> && res['data'] != null) {
      return res['data'];
    }
    return [];
  }

  static Future<Map<String, dynamic>> getRecommendations(Map<String, dynamic> body) async {
    final res = await _post('/recommendations', body);
    return res is Map<String, dynamic> ? res : {};
  }

  static Future<List<dynamic>> getScentLogs() async {
    final res = await _get('/scentLogs');
    if (res is Map<String, dynamic> && res['data'] != null) {
      return res['data'];
    }
    return [];
  }

  static Future<Map<String, dynamic>> addScentLog(Map<String, dynamic> body) async {
    final res = await _post('/scentLog', body);
    return res is Map<String, dynamic> ? res : {};
  }

  static Future<Map<String, dynamic>> deleteScentLog(int id) async {
    final res = await _delete('/scentLogs/$id');
    return res is Map<String, dynamic> ? res : {};
  }
}
