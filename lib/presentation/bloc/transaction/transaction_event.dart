import 'package:equatable/equatable.dart';

import '../../../domain/entities/stock_transaction_entity.dart';

abstract class TransactionEvent extends Equatable {
  const TransactionEvent();

  @override
  List<Object?> get props => [];
}

class LoadAllTransactions extends TransactionEvent {
  final int? limit;
  final DateTime? startDate;
  final DateTime? endDate;

  const LoadAllTransactions({this.limit, this.startDate, this.endDate});

  @override
  List<Object?> get props => [limit, startDate, endDate];
}

class LoadProductTransactions extends TransactionEvent {
  final String productId;

  const LoadProductTransactions(this.productId);

  @override
  List<Object?> get props => [productId];
}

class AddStockTransaction extends TransactionEvent {
  final String productId;
  final int quantityChange;
  final StockTransaction transaction;

  const AddStockTransaction({
    required this.productId,
    required this.quantityChange,
    required this.transaction,
  });

  @override
  List<Object?> get props => [productId, quantityChange, transaction];
}