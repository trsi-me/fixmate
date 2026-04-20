class Device {
  final int? id;
  final String deviceType;
  final String brand;
  final String model;
  final String customName;
  final String? purchaseDate;
  final String? warrantyExpiry;
  final String status;

  Device({
    this.id,
    required this.deviceType,
    required this.brand,
    required this.model,
    required this.customName,
    this.purchaseDate,
    this.warrantyExpiry,
    this.status = 'يعمل جيداً',
  });

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      id: json['id'] as int?,
      deviceType: json['device_type'] as String,
      brand: json['brand'] as String,
      model: json['model'] as String,
      customName: json['custom_name'] as String,
      purchaseDate: json['purchase_date'] as String?,
      warrantyExpiry: json['warranty_expiry'] as String?,
      status: json['status'] as String? ?? 'يعمل جيداً',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'device_type': deviceType,
      'brand': brand,
      'model': model,
      'custom_name': customName,
      'purchase_date': purchaseDate,
      'warranty_expiry': warrantyExpiry,
    };
  }
}
