import 'package:flutter/material.dart';

import '../data/computer_diagnostic_catalog.dart';
import '../widgets/app_theme.dart';
import 'computer_section_screen.dart';

/// اختيار شركة الحاسب قبل الأقسام (حاسب → شركة → قسم → مشكلة → حل).
class ComputerBrandScreen extends StatelessWidget {
  final String deviceName;

  const ComputerBrandScreen({
    super.key,
    required this.deviceName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      appBar: AppBar(
        title: Text(deviceName),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: computerBrands.length,
        itemBuilder: (context, index) {
          final brand = computerBrands[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _BrandTile(
              label: brand['name']!,
              icon: Icons.laptop_windows,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ComputerSectionScreen(
                      deviceName: deviceName,
                      brandName: brand['name']!,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _BrandTile extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _BrandTile({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
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
              Icon(icon, color: AppTheme.blue, size: 28),
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
    );
  }
}
