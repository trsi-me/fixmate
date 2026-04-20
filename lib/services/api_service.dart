import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/device.dart';
import '../models/issue.dart';
import '../models/user.dart';
import 'api_config.dart';
import 'auth_service.dart';

class ApiService {
  static Future<Map<String, String>> _headers() async {
    final headers = {'Content-Type': 'application/json'};
    final token = await AuthService.getToken();
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  static Future<User?> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final user = User.fromJson(data);
        await AuthService.saveUser(user);
        return user;
      }
    } catch (_) {}
    return null;
  }

  static Future<String?> register(String email, String password, String name, {String? phone}) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
          'name': name,
          if (phone != null && phone.isNotEmpty) 'phone': phone,
        }),
      );
      final data = json.decode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200) {
        final user = User.fromJson(data);
        await AuthService.saveUser(user);
        return null;
      }
      return data['error'] as String? ?? 'فشل التسجيل';
    } catch (_) {
      return 'فشل الاتصال بالسيرفر';
    }
  }

  static Future<User?> getProfile() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/user/profile'),
        headers: await _headers(),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return User.fromJson(data);
      }
    } catch (_) {}
    return null;
  }

  static Future<String?> updateProfile({String? name, String? phone, String? newPassword}) async {
    try {
      final body = <String, dynamic>{};
      if (name != null && name.isNotEmpty) body['name'] = name;
      if (phone != null) body['phone'] = phone;
      if (newPassword != null && newPassword.isNotEmpty) body['new_password'] = newPassword;

      final response = await http.put(
        Uri.parse('${ApiConfig.baseUrl}/user/update'),
        headers: await _headers(),
        body: json.encode(body),
      );
      final data = json.decode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200) {
        final user = User.fromJson(data);
        final current = await AuthService.getCurrentUser();
        if (current != null) {
          await AuthService.saveUser(user.copyWith(token: current.token));
        }
        return null;
      }
      return data['error'] as String? ?? 'فشل التحديث';
    } catch (_) {
      return 'فشل الاتصال بالسيرفر';
    }
  }

  static Future<List<Device>> getDevices() async {
    try {
      final response = await http.get(
        Uri.parse(ApiConfig.devicesUrl),
        headers: await _headers(),
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((e) => Device.fromJson(e as Map<String, dynamic>)).toList();
      }
    } catch (_) {}
    return [];
  }

  static Future<bool> addDevice(Device device) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.addDeviceUrl),
        headers: await _headers(),
        body: json.encode(device.toJson()),
      );
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  static Future<List<Issue>> getDeviceIssues(String deviceType) async {
    try {
      final uri = Uri.parse('${ApiConfig.baseUrl}/device_issues')
          .replace(queryParameters: {'device_type': deviceType});
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((e) => Issue.fromJson(e as Map<String, dynamic>)).toList();
      }
    } catch (_) {}
    return [];
  }

  static Future<Map<String, dynamic>?> predictFault({
    required String deviceType,
    required String symptom1,
    String symptom2 = '',
    String symptom3 = '',
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/predict_fault'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'device_type': deviceType,
          'symptom_1': symptom1,
          'symptom_2': symptom2,
          'symptom_3': symptom3,
        }),
      );
      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      }
    } catch (_) {}
    return null;
  }

  static Future<Issue?> getIssueDetails(int issueId) async {
    try {
      final response = await http.get(
        Uri.parse(ApiConfig.issueDetailsUrl(issueId)),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return Issue.fromJson(data);
      }
    } catch (_) {}
    return null;
  }
}
