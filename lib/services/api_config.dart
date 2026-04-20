import 'package:flutter/foundation.dart';

/// عنوان الـ API.
///
/// للإنتاج (ويب على Render أو أي استضافة): ابنِ بهذا الشكل:
/// `flutter build web --release --dart-define=API_BASE_URL=https://your-api.example.com`
///
/// نفس النطاق (واجهة + API على رابط واحد): ابنِ الويب بـ
/// `--dart-define=FIXMATE_SAME_ORIGIN=true` ثم ضع المخرجات في `backend/web/`.
///
/// بدون تعريفات: الويب محلياً `http://localhost:5000`، والموبايل `10.0.2.2`.
class ApiConfig {
  static const bool _sameOrigin =
      bool.fromEnvironment('FIXMATE_SAME_ORIGIN', defaultValue: false);

  static String get baseUrl {
    const fromEnv = String.fromEnvironment('API_BASE_URL');
    if (fromEnv.isNotEmpty) return fromEnv;
    if (kIsWeb && _sameOrigin) return '';
    if (kIsWeb) return 'http://localhost:5000';
    return 'http://10.0.2.2:5000';
  }

  static String get devicesUrl => '$baseUrl/devices';
  static String get addDeviceUrl => '$baseUrl/add_device';
  static String deviceIssuesUrl(String deviceType) =>
      '$baseUrl/device_issues?device_type=$deviceType';
  static String issueDetailsUrl(int issueId) =>
      '$baseUrl/issue_details?id=$issueId';
}
