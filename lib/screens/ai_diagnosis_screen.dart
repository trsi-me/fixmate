import 'package:flutter/material.dart';

import '../services/api_service.dart';
import '../widgets/app_theme.dart';
import '../widgets/device_data.dart';

class AiDiagnosisScreen extends StatefulWidget {
  const AiDiagnosisScreen({super.key});

  @override
  State<AiDiagnosisScreen> createState() => _AiDiagnosisScreenState();
}

class _AiDiagnosisScreenState extends State<AiDiagnosisScreen> {
  final _formKey = GlobalKey<FormState>();
  String _deviceType = deviceTypes.first;
  final _symptom1Controller = TextEditingController();
  final _symptom2Controller = TextEditingController();
  final _symptom3Controller = TextEditingController();
  bool _loading = false;
  Map<String, dynamic>? _result;

  @override
  void dispose() {
    _symptom1Controller.dispose();
    _symptom2Controller.dispose();
    _symptom3Controller.dispose();
    super.dispose();
  }

  Future<void> _predict() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
      _result = null;
    });

    final result = await ApiService.predictFault(
      deviceType: _deviceType,
      symptom1: _symptom1Controller.text.trim(),
      symptom2: _symptom2Controller.text.trim(),
      symptom3: _symptom3Controller.text.trim(),
    );

    if (mounted) {
      setState(() {
        _loading = false;
        _result = result;
      });
      if (result == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('فشل الاتصال. تأكد من تشغيل السيرفر وتدريب النموذج.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      appBar: AppBar(
        title: const Text('تشخيص العطل الذكي'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'نوع الجهاز',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _deviceType,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                items: deviceTypes
                    .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                    .toList(),
                onChanged: (v) => setState(() => _deviceType = v!),
              ),
              const SizedBox(height: 24),
              const Text(
                'الأعراض (أدخل ما تلاحظه)',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _symptom1Controller,
                decoration: InputDecoration(
                  labelText: 'العارض الأول (مثال: لا تبرد)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                validator: (v) =>
                    v?.trim().isEmpty ?? true ? 'أدخل عارض واحد على الأقل' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _symptom2Controller,
                decoration: InputDecoration(
                  labelText: 'العارض الثاني (اختياري)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _symptom3Controller,
                decoration: InputDecoration(
                  labelText: 'العارض الثالث (اختياري)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _loading ? null : _predict,
                child: _loading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppTheme.white,
                        ),
                      )
                    : const Text('تشخيص العطل'),
              ),
              if (_result != null) ...[
                const SizedBox(height: 32),
                _buildResult(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResult() {
    final fault = _result!['predicted_fault'] as String? ?? '';
    final causes = _result!['possible_causes'] as List<dynamic>? ?? [];
    final solutions = _result!['solutions'] as List<dynamic>? ?? [];
    final warnings = _result!['warnings'] as List<dynamic>? ?? [];
    final callTech = _result!['call_technician'] as String? ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.blue.withOpacity(0.5), width: 2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.psychology, color: AppTheme.blue, size: 28),
                  const SizedBox(width: 8),
                  Text(
                    'العطل المتوقع',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: AppTheme.blue,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                fault,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        _ResultSection(
          title: 'الأسباب المحتملة',
          icon: Icons.lightbulb_outline,
          items: causes.map((e) => e.toString()).toList(),
          color: AppTheme.blue,
        ),
        const SizedBox(height: 20),
        _ResultSection(
          title: 'خطوات الحل',
          icon: Icons.checklist,
          items: solutions.map((e) => e.toString()).toList(),
          color: AppTheme.green,
          numbered: true,
        ),
        const SizedBox(height: 20),
        _ResultSection(
          title: 'التحذيرات',
          icon: Icons.warning_amber,
          items: warnings.map((e) => e.toString()).toList(),
          color: Colors.orange,
        ),
        const SizedBox(height: 20),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.green.withOpacity(0.15),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.green.withOpacity(0.5), width: 2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.phone, color: AppTheme.green, size: 28),
                  const SizedBox(width: 8),
                  Text(
                    'متى تتصل بفني',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: AppTheme.green,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                callTech,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ResultSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<String> items;
  final Color color;
  final bool numbered;

  const _ResultSection({
    required this.title,
    required this.icon,
    required this.items,
    required this.color,
    this.numbered = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(width: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: color,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (numbered) ...[
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: color,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Text(
                    item,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
