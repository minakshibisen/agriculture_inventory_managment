
// BLOC
import 'dart:async';

import 'package:agriculture_inventory_managment/presentation/bloc/transaction/transaction_event.dart';
import 'package:agriculture_inventory_managment/presentation/bloc/transaction/transaction_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/repository/product_repository.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final ProductRepository _productRepository;
  StreamSubscription? _transactionSubscription;

  TransactionBloc({required ProductRepository productRepository})
      : _productRepository = productRepository,
        super(const TransactionInitial()) {
    on<LoadAllTransactions>(_onLoadAllTransactions);
    on<LoadProductTransactions>(_onLoadProductTransactions);
    on<AddStockTransaction>(_onAddStockTransaction);
  }

  Future<void> _onLoadAllTransactions(
      LoadAllTransactions event,
      Emitter<TransactionState> emit,
      ) async {
    try {
      emit(const TransactionLoading());
      await _transactionSubscription?.cancel();
      _transactionSubscription = _productRepository
          .getAllTransactions(
        limit: event.limit,
        startDate: event.startDate,
        endDate: event.endDate,
      )
          .listen(
            (transactions) {
          emit(TransactionsLoaded(transactions));
        },
        onError: (error) {
          emit(TransactionError(error.toString()));
        },
      );
    } catch (e) {
      emit(TransactionError(e.toString()));
    }
  }

  Future<void> _onLoadProductTransactions(
      LoadProductTransactions event,
      Emitter<TransactionState> emit,
      ) async {
    try {
      emit(const TransactionLoading());
      await _transactionSubscription?.cancel();
      _transactionSubscription =
          _productRepository.getProductTransactions(event.productId).listen(
                (transactions) {
              emit(TransactionsLoaded(transactions));
            },
            onError: (error) {
              emit(TransactionError(error.toString()));
            },
          );
    } catch (e) {
      emit(TransactionError(e.toString()));
    }
  }

  Future<void> _onAddStockTransaction(
      AddStockTransaction event,
      Emitter<TransactionState> emit,
      ) async {
    try {
      emit(const TransactionLoading());
      await _productRepository.updateStockWithTransaction(
        productId: event.productId,
        quantityChange: event.quantityChange,
        transaction: event.transaction,
      );
      emit(const TransactionOperationSuccess(
          'Stock transaction completed successfully'));
    } catch (e) {
      emit(TransactionError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _transactionSubscription?.cancel();
    return super.close();
  }
}