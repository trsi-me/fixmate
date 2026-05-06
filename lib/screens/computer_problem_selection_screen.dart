import 'package:flutter/material.dart';

import '../data/computer_diagnostic_catalog.dart';
import '../services/diagnostic_sound.dart';
import '../widgets/app_theme.dart';
import 'problem_details_screen.dart';

/// قائمة مشكلات داخل قسم واحد؛ صوت عند الدخول وعند اختيار مشكلة.
class ComputerProblemSelectionScreen extends StatefulWidget {
  final String deviceName;
  final String brandName;
  final ComputerDiagnosticSection section;

  const ComputerProblemSelectionScreen({
    super.key,
    required this.deviceName,
    required this.brandName,
    required this.section,
  });

  @override
  State<ComputerProblemSelectionScreen> createState() =>
      _ComputerProblemSelectionScreenState();
}

class _ComputerProblemSelectionScreenState extends State<ComputerProblemSelectionScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      DiagnosticSound.sectionOpened();
    });
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.section;
    return Scaffold(
      backgroundColor: AppTheme.white,
      appBar: AppBar(
        title: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${s.emoji} ${s.title}'),
            Text(
              s.subtitleLabel,
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
        itemCount: s.problems.length,
        itemBuilder: (context, index) {
          final problem = s.problems[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  DiagnosticSound.problemSelected();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProblemDetailsScreen(
                        deviceType: 'حاسب',
                        deviceName: '${widget.deviceName} — ${widget.brandName}',
                        issueName: problem.title,
                        issue: null,
                        overrideCauses: problem.causes,
                        overrideSolutions: problem.solutions,
                        overrideWarnings: problem.warnings,
                        playSolutionSound: true,
                      ),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  decoration: BoxDecoration(
                    color: AppTheme.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppTheme.blue.withOpacity(0.3), width: 2),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.warning_amber_outlined,
                          color: AppTheme.blue, size: 28),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          problem.title,
                          style: Theme.of(context).textTheme.titleLarge,
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
