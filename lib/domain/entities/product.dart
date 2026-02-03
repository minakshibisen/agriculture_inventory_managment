import 'package:equatable/equatable.dart';

/// Domain entity representing an agricultural product/medicine
class Product extends Equatable {
  final String id;
  final String name;
  final String category;
  final String description;
  final String manufacturer;
  final double price;
  final int currentStock;
  final int minimumStock;
  final String unit; // kg, liter, pieces, etc.
  final DateTime expiryDate;
  final DateTime? manufactureDate;
  final String? batchNumber;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;

  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.manufacturer,
    required this.price,
    required this.currentStock,
    required this.minimumStock,
    required this.unit,
    required this.expiryDate,
    this.manufactureDate,
    this.batchNumber,
    required this.createdAt,
    required this.updatedAt,
    this.isActive = true,
  });

  /// Check if product is expired
  bool get isExpired => DateTime.now().isAfter(expiryDate);

  /// Check if product is low on stock
  bool get isLowStock => currentStock <= minimumStock;

  /// Days until expiry
  int get daysUntilExpiry => expiryDate.difference(DateTime.now()).inDays;

  /// Check if expiring soon (within 30 days)
  bool get isExpiringSoon => daysUntilExpiry <= 30 && daysUntilExpiry > 0;

  @override
  List<Object?> get props => [
    id,
    name,
    category,
    description,
    manufacturer,
    price,
    currentStock,
    minimumStock,
    unit,
    expiryDate,
    manufactureDate,
    batchNumber,
    createdAt,
    updatedAt,
    isActive,
  ];

  Product copyWith({
    String? id,
    String? name,
    String? category,
    String? description,
    String? manufacturer,
    double? price,
    int? currentStock,
    int? minimumStock,
    String? unit,
    DateTime? expiryDate,
    DateTime? manufactureDate,
    String? batchNumber,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      description: description ?? this.description,
      manufacturer: manufacturer ?? this.manufacturer,
      price: price ?? this.price,
      currentStock: currentStock ?? this.currentStock,
      minimumStock: minimumStock ?? this.minimumStock,
      unit: unit ?? this.unit,
      expiryDate: expiryDate ?? this.expiryDate,
      manufactureDate: manufactureDate ?? this.manufactureDate,
      batchNumber: batchNumber ?? this.batchNumber,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
    );
  }
}