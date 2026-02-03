
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/stock_transaction_entity.dart';

/// Data model for StockTransaction with Firebase serialization
class StockTransactionModel {
  final String id;
  final String productId;
  final String productName;
  final TransactionType type;
  final int quantity;
  final int balanceAfter;
  final double pricePerUnit;
  final double totalAmount;
  final String? remarks;
  final String? invoiceNumber;
  final String? supplierName;
  final DateTime transactionDate;
  final String createdBy;
  final DateTime createdAt;

  StockTransactionModel({
    required this.id,
    required this.productId,
    required this.productName,
    required this.type,
    required this.quantity,
    required this.balanceAfter,
    required this.pricePerUnit,
    required this.totalAmount,
    this.remarks,
    this.invoiceNumber,
    this.supplierName,
    required this.transactionDate,
    required this.createdBy,
    required this.createdAt,
  });

  /// Convert to domain entity
  StockTransaction toEntity() {
    return StockTransaction(
      id: id,
      productId: productId,
      productName: productName,
      type: type,
      quantity: quantity,
      balanceAfter: balanceAfter,
      pricePerUnit: pricePerUnit,
      totalAmount: totalAmount,
      remarks: remarks,
      invoiceNumber: invoiceNumber,
      supplierName: supplierName,
      transactionDate: transactionDate,
      createdBy: createdBy,
      createdAt: createdAt,
    );
  }

  /// Create from domain entity
  factory StockTransactionModel.fromEntity(StockTransaction entity) {
    return StockTransactionModel(
      id: entity.id,
      productId: entity.productId,
      productName: entity.productName,
      type: entity.type,
      quantity: entity.quantity,
      balanceAfter: entity.balanceAfter,
      pricePerUnit: entity.pricePerUnit,
      totalAmount: entity.totalAmount,
      remarks: entity.remarks,
      invoiceNumber: entity.invoiceNumber,
      supplierName: entity.supplierName,
      transactionDate: entity.transactionDate,
      createdBy: entity.createdBy,
      createdAt: entity.createdAt,
    );
  }

  /// Create from Firestore document
  factory StockTransactionModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return StockTransactionModel(
      id: doc.id,
      productId: data['productId'] ?? '',
      productName: data['productName'] ?? '',
      type: TransactionType.values.firstWhere(
            (e) => e.name == data['type'],
        orElse: () => TransactionType.incoming,
      ),
      quantity: data['quantity'] ?? 0,
      balanceAfter: data['balanceAfter'] ?? 0,
      pricePerUnit: (data['pricePerUnit'] ?? 0).toDouble(),
      totalAmount: (data['totalAmount'] ?? 0).toDouble(),
      remarks: data['remarks'],
      invoiceNumber: data['invoiceNumber'],
      supplierName: data['supplierName'],
      transactionDate: (data['transactionDate'] as Timestamp).toDate(),
      createdBy: data['createdBy'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  /// Convert to Firestore map
  Map<String, dynamic> toFirestore() {
    return {
      'productId': productId,
      'productName': productName,
      'type': type.name,
      'quantity': quantity,
      'balanceAfter': balanceAfter,
      'pricePerUnit': pricePerUnit,
      'totalAmount': totalAmount,
      'remarks': remarks,
      'invoiceNumber': invoiceNumber,
      'supplierName': supplierName,
      'transactionDate': Timestamp.fromDate(transactionDate),
      'createdBy': createdBy,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  /// Create from JSON
  factory StockTransactionModel.fromJson(Map<String, dynamic> json) {
    return StockTransactionModel(
      id: json['id'] ?? '',
      productId: json['productId'] ?? '',
      productName: json['productName'] ?? '',
      type: TransactionType.values.firstWhere(
            (e) => e.name == json['type'],
        orElse: () => TransactionType.incoming,
      ),
      quantity: json['quantity'] ?? 0,
      balanceAfter: json['balanceAfter'] ?? 0,
      pricePerUnit: (json['pricePerUnit'] ?? 0).toDouble(),
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      remarks: json['remarks'],
      invoiceNumber: json['invoiceNumber'],
      supplierName: json['supplierName'],
      transactionDate: DateTime.parse(json['transactionDate']),
      createdBy: json['createdBy'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'productName': productName,
      'type': type.name,
      'quantity': quantity,
      'balanceAfter': balanceAfter,
      'pricePerUnit': pricePerUnit,
      'totalAmount': totalAmount,
      'remarks': remarks,
      'invoiceNumber': invoiceNumber,
      'supplierName': supplierName,
      'transactionDate': transactionDate.toIso8601String(),
      'createdBy': createdBy,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}