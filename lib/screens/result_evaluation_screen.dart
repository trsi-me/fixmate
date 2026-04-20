import 'package:flutter/material.dart';

import '../widgets/app_theme.dart';
import 'device_selection_screen.dart';

class ResultEvaluationScreen extends StatelessWidget {
  final String deviceName;
  final String issueName;

  const ResultEvaluationScreen({
    super.key,
    required this.deviceName,
    required this.issueName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      appBar: AppBar(
        title: const Text('تقييم النتيجة'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 32),
            Text(
              'هل نجح الحل؟',
              style: Theme.of(context).textTheme.headlineLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            ElevatedButton(
              onPressed: () {
                _showSuccessDialog(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.green,
                padding: const EdgeInsets.symmetric(vertical: 20),
              ),
              child: const Text('نعم تم الحل'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _showTechnicianAlert(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.symmetric(vertical: 20),
              ),
              child: const Text('لا لم ينجح'),
            ),
          ],
        ),
      ),
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تم بنجاح'),
        content: const Text('تم حل المشكلة بنجاح. نتمنى لك تجربة سعيدة.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('حسناً'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const DeviceSelectionScreen(),
                ),
                (route) => false,
              );
            },
            child: const Text('العودة للبداية'),
          ),
        ],
      ),
    );
  }

  void _showTechnicianAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تواصل مع فني'),
        content: const Text(
          'يُنصح بالاتصال بفني مختص لفحص الجهاز وتشخيص العطل بشكل دقيق.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('حسناً'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const DeviceSelectionScreen(),
                ),
                (route) => false,
              );
            },
            child: const Text('العودة للبداية'),
          ),
        ],
      ),
    );
  }
}
