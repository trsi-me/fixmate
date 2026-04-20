# FixMate — تقرير مفصل للمشروع

## 📋 الفهرس
1. [نظرة عامة](#نظرة-عامة)
2. [المصطلحات التقنية](#المصطلحات-التقنية)
3. [هيكل المشروع والملفات](#هيكل-المشروع-والملفات)
4. [شرح الأكواد الرئيسية](#شرح-الأكواد-الرئيسية)
5. [قواعد وقواعد البيانات](#قواعد-وقواعد-البيانات)
6. [طريقة التشغيل للمبتدئين](#طريقة-التشغيل-للمبتدئين)

---

## نظرة عامة

**FixMate** تطبيق جوال يساعد المستخدم على تشخيص أعطال الأجهزة المنزلية بطريقة منظمة وآمنة. يوفر:
- تشخيص الأعطال الشائعة مع خطوات إصلاح بسيطة
- نظام ذكاء اصطناعي لتوقع العطل بناءً على الأعراض
- نظام تسجيل دخول وإنشاء حساب وإعدادات مستخدم
- إدارة أجهزة المستخدم (إضافة، عرض، تتبع)

---

## المصطلحات التقنية

| المصطلح | الشرح |
|---------|-------|
| **Flutter** | إطار عمل من Google لبناء تطبيقات جوال تعمل على أندرويد و iOS من كود واحد |
| **Dart** | لغة برمجة تُستخدم مع Flutter |
| **Flask** | إطار عمل Python لبناء واجهات برمجة التطبيقات (API) |
| **API** | واجهة برمجة التطبيقات — طريقة يتواصل بها التطبيق مع السيرفر |
| **SQLite** | قاعدة بيانات خفيفة تُخزَّن في ملف واحد |
| **REST** | أسلوب تصميم APIs يعتمد على HTTP (GET, POST, PUT, DELETE) |
| **JSON** | تنسيق لتبادل البيانات بين التطبيق والسيرفر |
| **Token** | رمز يُستخدم للتحقق من هوية المستخدم بعد تسجيل الدخول |
| **LabelEncoder** | أداة تحويل النصوص إلى أرقام لتدريب نموذج التعلم الآلي |
| **Decision Tree** | خوارزمية تعلم آلي لتصنيف البيانات بناءً على شروط متسلسلة |
| **Confusion Matrix** | مصفوفة تُظهر أداء نموذج التصنيف (صحيح/خاطئ) |
| **Accuracy** | نسبة التوقعات الصحيحة من إجمالي التوقعات |
| **SharedPreferences** | تخزين محلي بسيط على الجهاز (مثل حفظ بيانات المستخدم) |
| **Widget** | مكوّن واجهة المستخدم في Flutter |
| **StatefulWidget** | Widget يحتفظ بحالة تتغير أثناء التشغيل |
| **StatelessWidget** | Widget ثابت لا يتغير |
| **pubspec.yaml** | ملف تعريف مشروع Flutter (المكتبات والإعدادات) |
| **requirements.txt** | قائمة مكتبات Python المطلوبة للمشروع |

---

## هيكل المشروع والملفات

```
fixmate/
├── lib/                          # كود التطبيق (Flutter)
│   ├── main.dart                 # نقطة البداية للتطبيق
│   ├── models/                   # نماذج البيانات
│   │   ├── user.dart            # نموذج المستخدم
│   │   ├── device.dart          # نموذج الجهاز
│   │   └── issue.dart           # نموذج العطل
│   ├── screens/                  # شاشات التطبيق
│   │   ├── welcome_screen.dart  # شاشة الترحيب
│   │   ├── login_screen.dart    # تسجيل الدخول
│   │   ├── register_screen.dart # إنشاء حساب
│   │   ├── main_screen.dart     # الشاشة الرئيسية (القائمة السفلية)
│   │   ├── device_selection_screen.dart  # اختيار نوع الجهاز
│   │   ├── issue_selection_screen.dart  # اختيار العطل
│   │   ├── ai_diagnosis_screen.dart     # تشخيص ذكي بالذكاء الاصطناعي
│   │   ├── add_device_screen.dart       # إضافة جهاز
│   │   ├── my_devices_screen.dart       # أجهزتي
│   │   ├── settings_screen.dart         # الإعدادات
│   │   ├── about_screen.dart            # نبذة عن التطبيق
│   │   └── tips_screen.dart             # نصائح الصيانة
│   ├── services/                 # خدمات الاتصال
│   │   ├── api_service.dart     # استدعاءات API
│   │   ├── api_config.dart      # إعدادات عنوان السيرفر
│   │   └── auth_service.dart   # إدارة الجلسة والتخزين المحلي
│   └── widgets/                 # مكوّنات مشتركة
│       ├── app_theme.dart       # الثيم والألوان
│       └── device_data.dart    # قائمة أنواع الأجهزة
├── backend/                      # السيرفر (Python/Flask)
│   ├── app.py                   # التطبيق الرئيسي وكل الـ API
│   ├── requirements.txt         # مكتبات Python
│   ├── database.db             # قاعدة البيانات (تُنشأ تلقائياً)
│   └── ai/                      # الذكاء الاصطناعي
│       ├── train_model.py      # تدريب النموذج
│       ├── fault_model.pkl      # النموذج المدرب (يُنشأ بعد التدريب)
│       ├── fault_dataset.csv   # بيانات التدريب
│       └── fault_details.py    # تفاصيل الأعطال (أسباب، حلول، تحذيرات)
├── assets/
│   ├── images/                  # الصور (مثل Logo.png)
│   └── fonts/                   # خط IBM Plex Sans Arabic
├── pubspec.yaml                 # إعدادات مشروع Flutter
└── README.md                    # هذا الملف
```

---

## شرح الأكواد الرئيسية (تفصيلي)

---

### 1. نقطة البداية — `main.dart`

```dart
void main() {
  runApp(const FixMateApp());
}

class FixMateApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FixMate',
      theme: AppTheme.theme,
      debugShowCheckedModeBanner: false,
      builder: (context, child) => Directionality(
        textDirection: TextDirection.rtl,
        child: child!,
      ),
      home: const WelcomeScreen(),
    );
  }
}
```

**شرح مفصل:**
- **`main()`**: نقطة الدخول في Dart؛ تُنفَّذ عند تشغيل التطبيق.
- **`runApp()`**: تربط التطبيق بعناصر الواجهة وتُظهر أول Widget.
- **`FixMateApp`**: Widget جذر من نوع `StatelessWidget` (لا يحتفظ بحالة متغيرة).
- **`MaterialApp`**: يوفر إعدادات التطبيق (الثيم، التنقل، الشاشة الافتراضية).
- **`builder: Directionality(textDirection: RTL)`**: يجعل كل النصوص من اليمين لليسار لدعم العربية.
- **`home: WelcomeScreen()`**: الشاشة الأولى التي تظهر عند فتح التطبيق.

---

### 2. شاشة الترحيب — `welcome_screen.dart`

**البنية:**
- `StatefulWidget` لأنها تستخدم **AnimationController** للحركات.
- `TickerProviderStateMixin`: مطلوب لاستخدام `AnimationController`.

**الحركات (Animations):**
- **`_logoController`**: يتحكم في ظهور الشعار (Fade + Scale).
- **`_contentController`**: يتحكم في ظهور النص والأزرار (Fade + Slide).
- `Interval` و `Curves.easeOut`: لتحديد توقيت وتيرة الحركة.

**المنطق عند الضغط على "ابدأ":**
```dart
onPressed: () async {
  final loggedIn = await AuthService.isLoggedIn();
  if (!mounted) return;  // تحقق أن الـ Widget ما زال في الشجرة
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (_) => loggedIn ? const MainScreen() : const LoginScreen(),
    ),
  );
}
```
- `pushReplacement`: يستبدل الشاشة الحالية بدل إضافة شاشة جديدة فوقها (لا يمكن الرجوع).
- `mounted`: يتحقق أن الـ Widget لم يُدمَّر أثناء انتظار `async` (تجنب أخطاء الذاكرة).

---

### 3. شاشة تسجيل الدخول — `login_screen.dart`

**العناصر الرئيسية:**
- **`GlobalKey<FormState>`**: للوصول لحالة النموذج والتحقق من صحة الحقول.
- **`TextEditingController`**: للتحكم في محتوى حقول النص وقراءته.

**التحقق (Validation):**
```dart
validator: (v) {
  if (v == null || v.trim().isEmpty) return 'أدخل البريد الإلكتروني';
  if (!v.contains('@')) return 'بريد إلكتروني غير صحيح';
  return null;  // null = صحيح
}
```

**تسجيل الدخول:**
```dart
Future<void> _login() async {
  if (!_formKey.currentState!.validate()) return;  // يوقف إذا كان هناك خطأ
  setState(() { _loading = true; _error = null; });
  final user = await ApiService.login(
    _emailController.text.trim().toLowerCase(),
    _passwordController.text,
  );
  if (mounted) {
    setState(() => _loading = false);
    if (user != null) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainScreen()));
    } else {
      setState(() => _error = 'البريد الإلكتروني أو كلمة المرور غير صحيحة');
    }
  }
}
```

**الخيارات الإضافية:**
- "ليس لديك حساب؟ سجّل الآن" → `Navigator.push` إلى `RegisterScreen` (يمكن الرجوع).
- "استخدام بدون حساب" → `pushReplacement` إلى `MainScreen` مباشرة (بدون Token).

---

### 4. شاشة التسجيل — `register_screen.dart`

**الحقول:** الاسم، البريد، الهاتف (اختياري)، كلمة المرور، تأكيد كلمة المرور.

**التحقق:**
```dart
validator: (v) {
  if (v != _passwordController.text) return 'كلمة المرور غير متطابقة';
  return null;
}
```

**بعد النجاح:**
```dart
Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(builder: (_) => const MainScreen()),
  (_) => false,  // يزيل كل الشاشات من المكدس
);
```

---

### 5. الشاشة الرئيسية — `main_screen.dart`

**`IndexedStack`:**
- يعرض شاشة واحدة فقط حسب `_currentIndex`.
- يحتفظ بحالة كل الشاشات (لا يُعاد بناءها عند التبديل).
- يختلف عن `PageView` بأنه لا يُنشئ الشاشات بشكل كسول.

**التبويبات الأربع:**
```dart
final List<Widget> _screens = [
  const DeviceSelectionScreen(),   // 0: الرئيسية
  const MyDevicesScreen(),          // 1: أجهزتي
  const AiDiagnosisScreen(),        // 2: تشخيص ذكي
  const _MoreScreen(),               // 3: المزيد
];
```

**`_MoreScreen`:** قائمة بـ `_MenuItem` لكل خيار (الإعدادات، نبذة، نصائح) مع `Navigator.push` للانتقال.

---

### 6. اختيار الجهاز — `device_selection_screen.dart`

**المصدر:** قائمة `devices` من `device_data.dart` (مكيف، ثلاجة، تلفزيون، غسالة، جوال، رسيفر، حاسب).

**عند الضغط على جهاز:**
```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => IssueSelectionScreen(
      deviceType: device['id']!,
      deviceName: device['name']!,
    ),
  ),
);
```

---

### 7. اختيار العطل — `issue_selection_screen.dart`

**دورة الحياة:**
- `initState()` → استدعاء `_loadIssues()` لجلب الأعطال من API.
- `ApiService.getDeviceIssues(widget.deviceType)` → GET `/device_issues?device_type=ثلاجة`.

**إذا كانت القائمة فارغة (السيرفر غير متصل):**
- `_buildFallbackIssues()`: يعرض قائمة ثابتة حسب نوع الجهاز من `_getFallbackIssues()`.
- مثال: ثلاجة → ['لا تبرد', 'تسريب ماء', 'صوت مرتفع', 'تجمد زائد', 'توقف عن العمل'].

**عند الضغط على عطل:**
- الانتقال إلى `ProblemDetailsScreen` مع `issue` (من API) أو `null` (من القائمة الاحتياطية).

---

### 8. تفاصيل العطل — `problem_details_screen.dart`

**المصدر:**
- إذا `issue != null`: استخدام `issue.causesList`, `solutionsList`, `warningsList` (من `Issue`).
- إذا `issue == null`: استخدام دوال احتياطية `_getFallbackCauses`, `_getFallbackSolutions`, `_getFallbackWarnings`.

**نموذج `Issue`:**
```dart
List<String> get causesList {
  return possibleCauses.split('\n').where((s) => s.trim().isNotEmpty).toList();
}
```
- البيانات من API تأتي كسطر واحد مفصول بـ `\n`، وتُحوَّل إلى قائمة.

**زر "تقييم النتيجة":** ينتقل إلى `ResultEvaluationScreen`.

---

### 9. تقييم النتيجة — `result_evaluation_screen.dart`

- **"نعم تم الحل"**: حوار نجاح ثم "العودة للبداية" باستخدام `pushAndRemoveUntil` إلى `DeviceSelectionScreen`.
- **"لا لم ينجح"**: حوار ينصح بالاتصال بفني، ثم نفس العودة.

---

### 10. تشخيص العطل الذكي — `ai_diagnosis_screen.dart`

**الحقول:**
- `DropdownButtonFormField` لاختيار نوع الجهاز.
- ثلاثة `TextFormField` للأعراض (الأول مطلوب، الثاني والثالث اختياريان).

**التحقق:**
```dart
validator: (v) => v?.trim().isEmpty ?? true ? 'أدخل عارض واحد على الأقل' : null,
```

**استدعاء API:**
```dart
final result = await ApiService.predictFault(
  deviceType: _deviceType,
  symptom1: _symptom1Controller.text.trim(),
  symptom2: _symptom2Controller.text.trim(),
  symptom3: _symptom3Controller.text.trim(),
);
```

**عرض النتيجة:** `_buildResult()` يعرض العطل المتوقع، الأسباب، الحلول، التحذيرات، ومتى تتصل بفني.

---

### 11. إضافة جهاز — `add_device_screen.dart`

**الحقول:** نوع الجهاز، الماركة، الموديل، اسم مخصص، تاريخ الشراء، تاريخ انتهاء الضمان.

**الاسم المخصص التلقائي:**
```dart
customName: _customNameController.text.trim().isEmpty
    ? '$_deviceType ${_brandController.text}'
    : _customNameController.text.trim(),
```

**زر الماسح الضوئي:**
- يفتح `ScannerScreen` الذي يعرض حقل إدخال يدوي للرمز (لا يوجد ماسح QR فعلي في الكود).
- النتيجة تُعاد عبر `Navigator.pop(context, code)` وتُكتب في حقل الموديل.

**اختيار التاريخ:**
- `showDatePicker()` يعيد `Future<DateTime?>`.
- `_formatDate()` يُحوّل التاريخ إلى `yyyy-MM-dd` للنقل إلى API.

---

### 12. أجهزتي — `my_devices_screen.dart`

**`RefreshIndicator`:**
- يسمح بالسحب للأسفل لتحديث القائمة (`onRefresh: _loadDevices`).

**الحالة الفارغة:** `_buildEmptyState()` تعرض رسالة وزر "إضافة جهاز".

**عند العودة من `AddDeviceScreen`:**
```dart
await Navigator.push(...);
if (mounted) _loadDevices();  // إعادة تحميل القائمة
```

---

### 13. الإعدادات — `settings_screen.dart`

**إذا لم يكن المستخدم مسجلاً:** عرض رسالة "يجب تسجيل الدخول" وزر للتوجه لـ `LoginScreen`.

**تحديث الملف الشخصي:**
- إذا حقل كلمة المرور الجديدة غير فارغ: إرسال `new_password` مع الاسم والهاتف.
- إذا فارغ: تحديث الاسم والهاتف فقط.

**تسجيل الخروج:**
```dart
await AuthService.logout();
Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(builder: (_) => const LoginScreen()),
  (_) => false,
);
```

---

### 14. خدمة API — `api_service.dart`

**دالة `_headers()`:**
```dart
static Future<Map<String, String>> _headers() async {
  final headers = {'Content-Type': 'application/json'};
  final token = await AuthService.getToken();
  if (token != null) {
    headers['Authorization'] = 'Bearer $token';
  }
  return headers;
}
```
- كل طلب محمي يضيف `Authorization: Bearer <token>`.

**معالجة الأخطاء:**
- `try/catch`: في حالة فشل الشبكة تُرجع `null` أو رسالة خطأ.
- لا يتم رمي الاستثناءات للمستخدم.

**`register()`:**
- عند النجاح: `return null` (لا خطأ).
- عند الفشل: `return data['error'] ?? 'فشل التسجيل'` أو "فشل الاتصال بالسيرفر".

**`updateProfile()`:**
- بعد التحديث الناجح: `AuthService.saveUser(user.copyWith(token: current.token))` لأن الاستجابة لا تحتوي على Token.

---

### 15. خدمة المصادقة — `auth_service.dart`

**التخزين:**
- `SharedPreferences`: تخزين مفتاح-قيمة على الجهاز.
- المفتاحان: `fixmate_user` (بيانات المستخدم كـ JSON)، `fixmate_token` (Token).

**`_currentUser`:**
- متغير ثابت (static) لتخزين المستخدم في الذاكرة وتجنب قراءة التخزين في كل مرة.

**`getCurrentUser()`:**
- إذا `_currentUser != null` تُرجع فوراً.
- وإلا تقرأ من `SharedPreferences` وتُحوّل JSON إلى `User`.

**`saveUser()`:**
- تحديث `_currentUser`.
- حفظ `user.toJson()` في التخزين.

**`logout()`:**
- مسح `_currentUser` وحذف المفاتيح من التخزين.

---

### 16. النماذج (Models)

**`User`:**
- `fromJson()`: تحويل من JSON (مثل استجابة API) إلى كائن.
- `toJson()`: تحويل إلى Map للتخزين أو الإرسال.
- `copyWith()`: إنشاء نسخة مع تغيير بعض الحقول (مثل الإبقاء على Token).

**`Device`:**
- `toJson()` يستخدم `device_type` (snake_case) لأن API يتوقع ذلك.
- عند الإضافة: إذا `customName` فارغ يُستخدم `'نوع_الجهاز الماركة'` تلقائياً.

**`Issue`:**
- `causesList`, `solutionsList`, `warningsList`: تحويل النص المفصول بـ `\n` إلى قوائم.

---

### 16.1. الثيم والبيانات المشتركة

**`app_theme.dart`:**
- `AppTheme.blue`, `AppTheme.green`, `AppTheme.white`: ألوان ثابتة.
- `ThemeData`: خط IBM Plex Sans Arabic، ألوان الأزرار، AppBar، حقول الإدخال، BottomNavigationBar.

**`device_data.dart`:**
- `devices`: قائمة `Map` لكل جهاز (id, name, icon).
- `deviceTypes`: قائمة نصية لأنواع الأجهزة تُستخدم في الـ Dropdown والتشخيص الذكي.

---

### 17. السيرفر — `backend/app.py` (تفصيلي)

#### تحميل النموذج
```python
def load_model():
    global _model_data
    if _model_data is None and os.path.exists(MODEL_PATH):
        _model_data = joblib.load(MODEL_PATH)
    return _model_data
```
- التحميل مرة واحدة فقط (Lazy Loading) لتوفير الذاكرة والوقت.

#### قاعدة البيانات
```python
def get_db():
    conn = sqlite3.connect(DATABASE)
    conn.row_factory = sqlite3.Row  # يجعل النتائج قابلة للوصول بالمفتاح: row['email']
    return conn
```

#### تشفير كلمة المرور
```python
def _hash_password(password):
    return hashlib.sha256(password.encode()).hexdigest()
```
- SHA-256: دالة hash أحادية الاتجاه (لا يمكن استرجاع كلمة المرور من الـ hash).

#### التحقق من Token
```python
def _get_user_from_token():
    token = request.headers.get('Authorization', '').replace('Bearer ', '')
    # ...
    cursor = conn.execute('SELECT user_id FROM user_tokens WHERE token = ?', (token,))
    row = cursor.fetchone()
    return row['user_id'] if row else None
```

#### التسجيل
- التحقق: البريد غير مستخدم، كلمة المرور ≥ 6 أحرف.
- إنشاء `password_hash` وإدخال المستخدم.
- إنشاء `token` بـ `secrets.token_hex(32)` وإدخاله في `user_tokens`.
- إرجاع بيانات المستخدم مع Token.

#### إضافة جهاز
- `user_id` يمكن أن يكون `None` إذا لم يكن المستخدم مسجلاً (استخدام بدون حساب).
- الأجهزة بدون `user_id` تظهر للمستخدمين غير المسجلين.

#### التشخيص الذكي (`/predict_fault`)
```python
device_encoded = encoders['device_type'].transform([device_type])[0]
# ...
X = np.array([[device_encoded, s1_encoded, s2_encoded, s3_encoded]], dtype=np.int64)
pred_encoded = model.predict(X)[0]
predicted_fault = encoders['fault_label'].inverse_transform([pred_encoded])[0]
```
- إذا كان العارض غير معروف في Encoder → `ValueError` → يُعاد رد افتراضي "يحتاج فحص من فني مختص".

---

### 18. تدريب النموذج — `ai/train_model.py` (تفصيلي)

**تحميل وتنظيف:**
```python
df = pd.read_csv(DATASET_PATH, encoding='utf-8')
df = df.dropna()  # حذف الصفوف التي تحتوي على قيم فارغة
df = df.apply(lambda x: x.str.strip() if x.dtype == 'object' else x)  # إزالة المسافات الزائدة
```

**LabelEncoder:**
```python
for col in ['device_type', 'symptom_1', 'symptom_2', 'symptom_3', 'fault_label']:
    le = LabelEncoder()
    df_encoded[col] = le.fit_transform(df[col].astype(str))
    encoders[col] = le
```
- `fit_transform`: يتعلم القيم الفريدة ويحولها إلى أرقام (0, 1, 2, ...).
- يجب حفظ `encoders` لأن نفس التحويل يُستخدم عند التوقع.

**تقسيم البيانات:**
```python
X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, random_state=42
)
```
- 80% تدريب، 20% اختبار.
- `random_state=42` لنتائج قابلة للتكرار.

**التدريب:**
- `DecisionTreeClassifier`: شجرة قرارات (أسئلة نعم/لا متسلسلة).
- `RandomForestClassifier`: مجموعة أشجار (n_estimators=100) للمقارنة فقط؛ النموذج المحفوظ هو Decision Tree.

**الحفظ:**
```python
model_data = {
    'model': dt_model,
    'encoders': encoders,
}
joblib.dump(model_data, MODEL_PATH)
```

---

### 19. تفاصيل الأعطال — `ai/fault_details.py`

**البنية:**
```python
FAULT_DETAILS = {
    'مشكلة في الكمبروسر': {
        'causes': ['...'],
        'solutions': ['...'],
        'warnings': ['...'],
    },
    # ...
}
```

**الدالة:**
```python
def get_fault_details(fault_label):
    details = FAULT_DETAILS.get(fault_label)
    if details:
        return details
    return {
        'causes': ['يحتاج فحص من فني مختص'],
        'solutions': ['تحقق من القاطع الكهربائي', 'افصل الجهاز وأعد التشغيل'],
        'warnings': ['لا تفتح الجهاز بنفسك', 'يجب الاتصال بفني مختص'],
    }
```
- إذا العطل غير موجود في القاموس تُرجع قيم افتراضية آمنة.

---

## قواعد وقواعد البيانات

### قواعد التحقق (Backend)

- **التسجيل**: البريد وكلمة المرور والاسم مطلوبة، كلمة المرور 6 أحرف على الأقل.
- **إضافة جهاز**: `device_type`, `brand`, `model`, `custom_name` مطلوبة.
- **التشخيص الذكي**: `device_type` مطلوب، `symptom_1` مطلوب على الأقل.

### بنية قاعدة البيانات

```sql
-- المستخدمون
CREATE TABLE users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    email TEXT UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,
    name TEXT NOT NULL,
    phone TEXT,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP
);

-- رموز الجلسة
CREATE TABLE user_tokens (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    token TEXT NOT NULL UNIQUE,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- الأجهزة
CREATE TABLE devices (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER,
    device_type TEXT NOT NULL,
    brand TEXT NOT NULL,
    model TEXT NOT NULL,
    custom_name TEXT NOT NULL,
    purchase_date TEXT,
    warranty_expiry TEXT,
    status TEXT DEFAULT 'يعمل جيداً',
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- الأعطال (بيانات ثابتة)
CREATE TABLE issues (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    device_type TEXT NOT NULL,
    issue_name TEXT NOT NULL,
    possible_causes TEXT NOT NULL,
    solutions TEXT NOT NULL,
    warnings TEXT NOT NULL
);
```

---

## طريقة التشغيل للمبتدئين

### الخطوة 0: التأكد من التثبيت

- **Flutter**: [رابط التثبيت](https://flutter.dev/docs/get-started/install) ثم تشغيل `flutter doctor`.
- **Python 3.10+**: من [python.org](https://www.python.org/downloads/).

---

### الخطوة 1: تثبيت مكتبات Python (Backend)

افتح الطرفية (Terminal) وانتقل لمجلد الـ backend:

```bash
cd D:\VSCode\Projects\flutterprojects\fixmate\backend
pip install -r requirements.txt
```

---

### الخطوة 2: تدريب نموذج الذكاء الاصطناعي

**مهم**: يجب تنفيذ هذا الأمر مرة واحدة قبل تشغيل السيرفر لأول مرة:

```bash
cd D:\VSCode\Projects\flutterprojects\fixmate\backend
python ai/train_model.py
```

سيظهر Accuracy و Confusion Matrix، ويُنشأ الملف `ai/fault_model.pkl`.

---

### الخطوة 3: تشغيل السيرفر (Flask)

```bash
cd D:\VSCode\Projects\flutterprojects\fixmate\backend
python app.py
```

السيرفر يعمل على: `http://0.0.0.0:5000` (المنفذ 5000).

---

### الخطوة 4: تشغيل التطبيق (Flutter)

افتح طرفية جديدة:

```bash
cd D:\VSCode\Projects\flutterprojects\fixmate
flutter pub get
flutter run
```

اختر الجهاز (محاكي أو جهاز حقيقي) عند ظهور الخيارات.

---

### الخطوة 5: الربط بين التطبيق والسيرفر

| البيئة | عنوان السيرفر |
|--------|----------------|
| محاكي أندرويد | `http://10.0.2.2:5000` (الافتراضي في `api_config.dart`) |
| محاكي iOS | غيّر `baseUrl` إلى `http://localhost:5000` |
| جهاز حقيقي على نفس الشبكة | غيّر `baseUrl` إلى `http://IP_جهازك:5000` (مثال: `http://192.168.1.5:5000`) |

لتغيير العنوان: عدّل الملف `lib/services/api_config.dart`.

---

### ترتيب التشغيل

1. تشغيل السيرفر أولاً (`python app.py`).
2. ثم تشغيل التطبيق (`flutter run`).

---

### استكشاف الأخطاء

| المشكلة | الحل |
|---------|------|
| "Model not loaded" | نفّذ `python ai/train_model.py` أولاً |
| "فشل الاتصال بالسيرفر" | تأكد أن السيرفر يعمل وأن العنوان في `api_config.dart` صحيح |
| خطأ في `flutter pub get` | تأكد من تثبيت Flutter وتشغيل `flutter doctor` |
| خطأ في `pip install` | تأكد من تثبيت Python وإضافته إلى PATH |

---

## ملخص سريع

- **التطبيق**: Flutter (Dart) — واجهة المستخدم.
- **السيرفر**: Flask (Python) — API وقاعدة بيانات SQLite.
- **الذكاء الاصطناعي**: scikit-learn (Decision Tree) — تشخيص العطل من الأعراض.
- **التواصل**: HTTP/JSON مع Token للمصادقة.
