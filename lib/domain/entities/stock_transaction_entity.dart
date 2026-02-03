import 'package:equatable/equatable.dart';

enum TransactionType {
  incoming,
  outgoing,
  adjustment,
  expired,
  damaged,
}

/// Domain entity representing a stock transaction
class StockTransaction extends Equatable {
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

  const StockTransaction({
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

  @override
  List<Object?> get props => [
    id,
    productId,
    productName,
    type,
    quantity,
    balanceAfter,
    pricePerUnit,
    totalAmount,
    remarks,
    invoiceNumber,
    supplierName,
    transactionDate,
    createdBy,
    createdAt,
  ];

  StockTransaction copyWith({
    String? id,
    String? productId,
    String? productName,
    TransactionType? type,
    int? quantity,
    int? balanceAfter,
    double? pricePerUnit,
    double? totalAmount,
    String? remarks,
    String? invoiceNumber,
    String? supplierName,
    DateTime? transactionDate,
    String? createdBy,
    DateTime? createdAt,
  }) {
    return StockTransaction(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      type: type ?? this.type,
      quantity: quantity ?? this.quantity,
      balanceAfter: balanceAfter ?? this.balanceAfter,
      pricePerUnit: pricePerUnit ?? this.pricePerUnit,
      totalAmount: totalAmount ?? this.totalAmount,
      remarks: remarks ?? this.remarks,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      supplierName: supplierName ?? this.supplierName,
      transactionDate: transactionDate ?? this.transactionDate,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}