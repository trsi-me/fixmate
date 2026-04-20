import 'package:flutter/material.dart';

import '../models/device.dart';
import '../services/api_service.dart';
import '../widgets/app_theme.dart';
import '../widgets/device_data.dart';
import 'scanner_screen.dart';

class AddDeviceScreen extends StatefulWidget {
  const AddDeviceScreen({super.key});

  @override
  State<AddDeviceScreen> createState() => _AddDeviceScreenState();
}

class _AddDeviceScreenState extends State<AddDeviceScreen> {
  final _formKey = GlobalKey<FormState>();
  String _deviceType = deviceTypes.first;
  final _brandController = TextEditingController();
  final _modelController = TextEditingController();
  final _customNameController = TextEditingController();
  DateTime? _purchaseDate;
  DateTime? _warrantyExpiry;
  bool _saving = false;

  @override
  void dispose() {
    _brandController.dispose();
    _modelController.dispose();
    _customNameController.dispose();
    super.dispose();
  }

  Future<void> _openScanner() async {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (context) => const ScannerScreen(),
      ),
    );
    if (result != null && mounted) {
      _modelController.text = result;
    }
  }

  Future<void> _selectPurchaseDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (date != null && mounted) {
      setState(() => _purchaseDate = date);
    }
  }

  Future<void> _selectWarrantyExpiry() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 365)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
    );
    if (date != null && mounted) {
      setState(() => _warrantyExpiry = date);
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Future<void> _saveDevice() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);

    final device = Device(
      deviceType: _deviceType,
      brand: _brandController.text.trim(),
      model: _modelController.text.trim(),
      customName: _customNameController.text.trim().isEmpty
          ? '$_deviceType ${_brandController.text}'
          : _customNameController.text.trim(),
      purchaseDate: _purchaseDate != null ? _formatDate(_purchaseDate) : null,
      warrantyExpiry: _warrantyExpiry != null ? _formatDate(_warrantyExpiry) : null,
    );

    final success = await ApiService.addDevice(device);

    if (mounted) {
      setState(() => _saving = false);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم حفظ الجهاز بنجاح')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('فشل الحفظ. تأكد من تشغيل السيرفر.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      appBar: AppBar(
        title: const Text('إضافة جهاز'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('نوع الجهاز', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _deviceType,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                items: deviceTypes.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                onChanged: (v) => setState(() => _deviceType = v!),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _brandController,
                decoration: InputDecoration(
                  labelText: 'الماركة',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                validator: (v) => v?.trim().isEmpty ?? true ? 'أدخل الماركة' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _modelController,
                      decoration: InputDecoration(
                        labelText: 'الموديل',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      validator: (v) => v?.trim().isEmpty ?? true ? 'أدخل الموديل' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  IconButton.filled(
                    onPressed: _openScanner,
                    icon: const Icon(Icons.qr_code_scanner),
                    tooltip: 'الماسح الضوئي',
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _customNameController,
                decoration: InputDecoration(
                  labelText: 'اسم مخصص (مثال: مكيف غرفة النوم)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
              const SizedBox(height: 16),
              const Text('تاريخ الشراء', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              InkWell(
                onTap: _selectPurchaseDate,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today, color: AppTheme.blue),
                      const SizedBox(width: 12),
                      Text(_purchaseDate != null ? _formatDate(_purchaseDate) : 'اختر التاريخ'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text('تاريخ انتهاء الضمان', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              InkWell(
                onTap: _selectWarrantyExpiry,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today, color: AppTheme.blue),
                      const SizedBox(width: 12),
                      Text(_warrantyExpiry != null ? _formatDate(_warrantyExpiry) : 'اختر التاريخ'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _saving ? null : _saveDevice,
                child: _saving
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppTheme.white,
                        ),
                      )
                    : const Text('حفظ الجهاز'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
