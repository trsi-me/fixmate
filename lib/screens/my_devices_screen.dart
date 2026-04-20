import 'package:flutter/material.dart';

import '../models/device.dart';
import '../services/api_service.dart';
import '../widgets/app_theme.dart';
import 'add_device_screen.dart';

class MyDevicesScreen extends StatefulWidget {
  const MyDevicesScreen({super.key});

  @override
  State<MyDevicesScreen> createState() => _MyDevicesScreenState();
}

class _MyDevicesScreenState extends State<MyDevicesScreen> {
  List<Device> _devices = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadDevices();
  }

  Future<void> _loadDevices() async {
    setState(() => _loading = true);
    final devices = await ApiService.getDevices();
    if (mounted) {
      setState(() {
        _devices = devices;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      appBar: AppBar(
        title: const Text('أجهزتي'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddDeviceScreen(),
                ),
              );
              if (mounted) _loadDevices();
            },
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _devices.isEmpty
              ? _buildEmptyState()
              : _buildDevicesList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.devices_other, size: 80, color: AppTheme.blue.withOpacity(0.5)),
            const SizedBox(height: 24),
            Text(
              'لا توجد أجهزة مضافة',
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'اضغط + لإضافة جهاز جديد',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddDeviceScreen(),
                  ),
                );
                _loadDevices();
              },
              icon: const Icon(Icons.add),
              label: const Text('إضافة جهاز'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDevicesList() {
    return RefreshIndicator(
      onRefresh: _loadDevices,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _devices.length,
        itemBuilder: (context, index) {
          final device = _devices[index];
          return _DeviceItem(device: device);
        },
      ),
    );
  }
}

class _DeviceItem extends StatelessWidget {
  final Device device;

  const _DeviceItem({required this.device});

  @override
  Widget build(BuildContext context) {
    final isGood = device.status == 'يعمل جيداً';

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isGood ? AppTheme.green.withOpacity(0.5) : Colors.orange.withOpacity(0.5),
            width: 2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              device.customName,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'النوع: ${device.deviceType}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Text(
              'الماركة: ${device.brand}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  isGood ? Icons.check_circle : Icons.build_circle,
                  color: isGood ? AppTheme.green : Colors.orange,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  device.status,
                  style: TextStyle(
                    color: isGood ? AppTheme.green : Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
