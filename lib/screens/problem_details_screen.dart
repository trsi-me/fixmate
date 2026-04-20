import 'package:flutter/material.dart';

import '../models/issue.dart';
import '../widgets/app_theme.dart';
import 'result_evaluation_screen.dart';

class ProblemDetailsScreen extends StatelessWidget {
  final String deviceType;
  final String deviceName;
  final String issueName;
  final Issue? issue;

  const ProblemDetailsScreen({
    super.key,
    required this.deviceType,
    required this.deviceName,
    required this.issueName,
    this.issue,
  });

  @override
  Widget build(BuildContext context) {
    final causes = issue?.causesList ?? _getFallbackCauses(deviceType, issueName);
    final solutions = issue?.solutionsList ?? _getFallbackSolutions(deviceType, issueName);
    final warnings = issue?.warningsList ?? _getFallbackWarnings(deviceType);

    return Scaffold(
      backgroundColor: AppTheme.white,
      appBar: AppBar(
        title: Text(issueName),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Section(
              title: 'السبب المحتمل',
              icon: Icons.lightbulb_outline,
              items: causes,
            ),
            const SizedBox(height: 24),
            _Section(
              title: 'خطوات الحل',
              icon: Icons.checklist,
              items: solutions,
              numbered: true,
            ),
            const SizedBox(height: 24),
            _Section(
              title: 'التحذيرات',
              icon: Icons.warning_amber,
              items: warnings,
              isWarning: true,
            ),
            const SizedBox(height: 24),
            _CallTechnicianSection(),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ResultEvaluationScreen(
                        deviceName: deviceName,
                        issueName: issueName,
                      ),
                    ),
                  );
                },
                child: const Text('تقييم النتيجة'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<String> _getFallbackCauses(String deviceType, String issueName) {
    if (deviceType == 'ثلاجة') {
      return ['عدم وجود كهرباء', 'انسداد الفلتر', 'عطل في الكمبروسر'];
    }
    return ['عدم وجود كهرباء', 'عطل في الجهاز', 'مشكلة في الإعدادات'];
  }

  List<String> _getFallbackSolutions(String deviceType, String issueName) {
    if (deviceType == 'ثلاجة') {
      return [
        'تحقق من القاطع الكهربائي',
        'افصل الجهاز لمدة 5 دقائق',
        'أعد تشغيل الجهاز',
        'تأكد من نظافة الفلاتر',
      ];
    }
    return [
      'تحقق من القاطع الكهربائي',
      'افصل الجهاز لمدة 5 دقائق',
      'أعد تشغيل الجهاز',
    ];
  }

  List<String> _getFallbackWarnings(String deviceType) {
    return [
      'لا تفتح غطاء الكمبروسر',
      'لا تلمس الأسلاك المكشوفة',
      'افصل الكهرباء قبل الفحص',
    ];
  }
}

class _Section extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<String> items;
  final bool numbered;
  final bool isWarning;

  const _Section({
    required this.title,
    required this.icon,
    required this.items,
    this.numbered = false,
    this.isWarning = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isWarning ? Colors.orange : AppTheme.blue;

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

class _CallTechnicianSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
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
            'إذا لم تنجح الخطوات السابقة أو كان العطل كهربائياً داخلياً يجب الاتصال بفني مختص.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
