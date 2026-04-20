import 'package:flutter/material.dart';

import '../widgets/app_theme.dart';

class TipsScreen extends StatelessWidget {
  const TipsScreen({super.key});

  static const List<Map<String, String>> tips = [
    {'title': 'صيانة المكيف', 'tip': 'نظّف فلتر المكيف كل أسبوعين لتحسين التبريد وتقليل استهلاك الكهرباء.'},
    {'title': 'صيانة الثلاجة', 'tip': 'تأكد من إغلاق باب الثلاجة جيداً وتجنب فتحه لفترات طويلة.'},
    {'title': 'صيانة الغسالة', 'tip': 'وزّع الملابس بشكل متوازن داخل الغسالة لتجنب الاهتزاز والأصوات العالية.'},
    {'title': 'صيانة التلفزيون', 'tip': 'نظّف فتحات التهوية من الغبار لتفادي ارتفاع الحرارة.'},
    {'title': 'صيانة الجوال', 'tip': 'تجنب الشحن الكامل (100%) بشكل متكرر للحفاظ على عمر البطارية.'},
    {'title': 'صيانة الحاسب', 'tip': 'نظّف مراوح التبريد دورياً لمنع ارتفاع درجة الحرارة.'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      appBar: AppBar(
        title: const Text('نصائح الصيانة'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: tips.length,
        itemBuilder: (context, index) {
          final item = tips[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.blue.withOpacity(0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.lightbulb_outline, color: AppTheme.green, size: 24),
                      const SizedBox(width: 8),
                      Text(
                        item['title']!,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: AppTheme.blue,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item['tip']!,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
