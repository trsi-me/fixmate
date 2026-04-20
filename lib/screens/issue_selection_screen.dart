import 'package:flutter/material.dart';

import '../models/issue.dart';
import '../services/api_service.dart';
import '../widgets/app_theme.dart';
import 'problem_details_screen.dart';

class IssueSelectionScreen extends StatefulWidget {
  final String deviceType;
  final String deviceName;

  const IssueSelectionScreen({
    super.key,
    required this.deviceType,
    required this.deviceName,
  });

  @override
  State<IssueSelectionScreen> createState() => _IssueSelectionScreenState();
}

class _IssueSelectionScreenState extends State<IssueSelectionScreen> {
  List<Issue> _issues = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadIssues();
  }

  Future<void> _loadIssues() async {
    final issues = await ApiService.getDeviceIssues(widget.deviceType);
    if (mounted) {
      setState(() {
        _issues = issues;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      appBar: AppBar(
        title: Text('أعطال ${widget.deviceName}'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _issues.isEmpty
              ? _buildFallbackIssues()
              : _buildIssuesList(),
    );
  }

  Widget _buildFallbackIssues() {
    final fallbackIssues = _getFallbackIssues(widget.deviceType);
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: fallbackIssues.length,
      itemBuilder: (context, index) {
        final issue = fallbackIssues[index];
        return _IssueItem(
          label: issue,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProblemDetailsScreen(
                  deviceType: widget.deviceType,
                  deviceName: widget.deviceName,
                  issueName: issue,
                  issue: null,
                ),
              ),
            );
          },
        );
      },
    );
  }

  List<String> _getFallbackIssues(String deviceType) {
    switch (deviceType) {
      case 'ثلاجة':
        return ['لا تبرد', 'تسريب ماء', 'صوت مرتفع', 'تجمد زائد', 'توقف عن العمل'];
      case 'مكيف':
        return ['لا يبرد', 'تسريب ماء', 'صوت مرتفع', 'لا يعمل', 'رائحة كريهة'];
      case 'تلفزيون':
        return ['لا يعمل', 'صورة مشوشة', 'لا صوت', 'شاشة سوداء', 'توقف عن العمل'];
      case 'غسالة':
        return ['لا تدور', 'تسريب ماء', 'صوت مرتفع', 'لا تعمل', 'لا تصرف الماء'];
      case 'جوال':
        return ['لا يشحن', 'شاشة مكسورة', 'بطارية سريعة', 'لا يعمل', 'بطء'];
      case 'رسيفر':
        return ['لا يعمل', 'لا إشارة', 'توقف عن العمل', 'صورة مشوشة', 'لا صوت'];
      case 'حاسب':
        return ['لا يعمل', 'بطء', 'شاشة سوداء', 'صوت مرتفع', 'لا يشحن'];
      default:
        return ['لا يعمل', 'توقف عن العمل', 'صوت مرتفع'];
    }
  }

  Widget _buildIssuesList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _issues.length,
      itemBuilder: (context, index) {
        final issue = _issues[index];
        return _IssueItem(
          label: issue.issueName,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProblemDetailsScreen(
                  deviceType: widget.deviceType,
                  deviceName: widget.deviceName,
                  issueName: issue.issueName,
                  issue: issue,
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _IssueItem extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _IssueItem({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
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
                Icon(Icons.build, color: AppTheme.blue, size: 28),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    label,
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
  }
}
