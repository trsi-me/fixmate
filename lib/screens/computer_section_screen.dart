import 'package:flutter/material.dart';

import '../data/computer_diagnostic_catalog.dart';
import '../widgets/app_theme.dart';
import 'computer_problem_selection_screen.dart';

/// قائمة أقسام الحاسب (الأصوات، النظام، البطارية، …).
class ComputerSectionScreen extends StatelessWidget {
  final String deviceName;
  final String brandName;

  const ComputerSectionScreen({
    super.key,
    required this.deviceName,
    required this.brandName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      appBar: AppBar(
        title: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(deviceName),
            Text(
              brandName,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.normal,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: computerDiagnosticSections.length,
        itemBuilder: (context, index) {
          final section = computerDiagnosticSections[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ComputerProblemSelectionScreen(
                        deviceName: deviceName,
                        brandName: brandName,
                        section: section,
                      ),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                  decoration: BoxDecoration(
                    color: AppTheme.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppTheme.blue.withOpacity(0.3), width: 2),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(section.emoji, style: const TextStyle(fontSize: 28)),
                      const SizedBox(width: 14),
                      Icon(section.icon, color: AppTheme.blue, size: 26),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              section.title,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            Text(
                              section.subtitleLabel,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.grey.shade600,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios, size: 16, color: AppTheme.blue),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
