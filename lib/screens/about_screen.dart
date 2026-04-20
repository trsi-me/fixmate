import 'package:flutter/material.dart';

import '../widgets/app_theme.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      appBar: AppBar(
        title: const Text('نبذة عن التطبيق'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 24),
            Image.asset(
              'assets/images/Logo.png',
              height: 100,
              width: 100,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 16),
            Text(
              'FixMate',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: AppTheme.blue,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'دليلك لإصلاح الأجهزة المنزلية',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.blue.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.blue.withOpacity(0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'عن التطبيق',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: AppTheme.blue,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'FixMate تطبيق يساعدك على تشخيص أعطال الأجهزة المنزلية بطريقة منظمة وآمنة. يوفر تشخيص الأعطال الشائعة، خطوات إصلاح بسيطة، ونظام ذكاء اصطناعي لتوقع العطل بناءً على الأعراض.',
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.green.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.green.withOpacity(0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'المميزات',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: AppTheme.green,
                        ),
                  ),
                  const SizedBox(height: 12),
                  _FeatureItem(text: 'تشخيص الأعطال الشائعة للأجهزة المنزلية'),
                  _FeatureItem(text: 'خطوات إصلاح بسيطة وآمنة'),
                  _FeatureItem(text: 'تشخيص ذكي بالذكاء الاصطناعي'),
                  _FeatureItem(text: 'إدارة أجهزتك وإضافة أجهزة مخصصة'),
                  _FeatureItem(text: 'تنبيهات متى يجب الاتصال بفني مختص'),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Text(
              '© 2026 جميع الحقوق محفوظة',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade600,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final String text;

  const _FeatureItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle, color: AppTheme.green, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }
}
