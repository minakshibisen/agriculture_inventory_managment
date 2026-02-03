import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/product.dart';

/// Data model for Product with Firebase serialization
class ProductModel {
  final String id;
  final String name;
  final String category;
  final String description;
  final String manufacturer;
  final double price;
  final int currentStock;
  final int minimumStock;
  final String unit;
  final DateTime expiryDate;
  final DateTime? manufactureDate;
  final String? batchNumber;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;

  ProductModel({
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

  /// Convert to domain entity
  Product toEntity() {
    return Product(
      id: id,
      name: name,
      category: category,
      description: description,
      manufacturer: manufacturer,
      price: price,
      currentStock: currentStock,
      minimumStock: minimumStock,
      unit: unit,
      expiryDate: expiryDate,
      manufactureDate: manufactureDate,
      batchNumber: batchNumber,
      createdAt: createdAt,
      updatedAt: updatedAt,
      isActive: isActive,
    );
  }

  /// Create from domain entity
  factory ProductModel.fromEntity(Product entity) {
    return ProductModel(
      id: entity.id,
      name: entity.name,
      category: entity.category,
      description: entity.description,
      manufacturer: entity.manufacturer,
      price: entity.price,
      currentStock: entity.currentStock,
      minimumStock: entity.minimumStock,
      unit: entity.unit,
      expiryDate: entity.expiryDate,
      manufactureDate: entity.manufactureDate,
      batchNumber: entity.batchNumber,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      isActive: entity.isActive,
    );
  }

  /// Create from Firestore document
  factory ProductModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ProductModel(
      id: doc.id,
      name: data['name'] ?? '',
      category: data['category'] ?? '',
      description: data['description'] ?? '',
      manufacturer: data['manufacturer'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      currentStock: data['currentStock'] ?? 0,
      minimumStock: data['minimumStock'] ?? 0,
      unit: data['unit'] ?? '',
      expiryDate: (data['expiryDate'] as Timestamp).toDate(),
      manufactureDate: data['manufactureDate'] != null
          ? (data['manufactureDate'] as Timestamp).toDate()
          : null,
      batchNumber: data['batchNumber'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      isActive: data['isActive'] ?? true,
    );
  }

  /// Convert to Firestore map
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'category': category,
      'description': description,
      'manufacturer': manufacturer,
      'price': price,
      'currentStock': currentStock,
      'minimumStock': minimumStock,
      'unit': unit,
      'expiryDate': Timestamp.fromDate(expiryDate),
      'manufactureDate': manufactureDate != null
          ? Timestamp.fromDate(manufactureDate!)
          : null,
      'batchNumber': batchNumber,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'isActive': isActive,
    };
  }

  /// Create from JSON
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      description: json['description'] ?? '',
      manufacturer: json['manufacturer'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      currentStock: json['currentStock'] ?? 0,
      minimumStock: json['minimumStock'] ?? 0,
      unit: json['unit'] ?? '',
      expiryDate: DateTime.parse(json['expiryDate']),
      manufactureDate: json['manufactureDate'] != null
          ? DateTime.parse(json['manufactureDate'])
          : null,
      batchNumber: json['batchNumber'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      isActive: json['isActive'] ?? true,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'description': description,
      'manufacturer': manufacturer,
      'price': price,
      'currentStock': currentStock,
      'minimumStock': minimumStock,
      'unit': unit,
      'expiryDate': expiryDate.toIso8601String(),
      'manufactureDate': manufactureDate?.toIso8601String(),
      'batchNumber': batchNumber,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isActive': isActive,
    };
  }
}