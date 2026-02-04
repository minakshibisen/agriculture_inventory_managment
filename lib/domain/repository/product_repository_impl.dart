import 'package:agriculture_inventory_managment/domain/repository/product_repository.dart';

import '../../data/firebase_service/firebase_service.dart';
import '../../data/model/product_model.dart';
import '../../data/model/stock_transaction.dart';
import '../../domain/entities/product.dart';

import '../entities/stock_transaction_entity.dart';


/// Implementation of ProductRepository using Firebase
class ProductRepositoryImpl implements ProductRepository {
  final FirebaseService _firebaseService;

  ProductRepositoryImpl({required FirebaseService firebaseService})
      : _firebaseService = firebaseService;

  @override
  Future<String> addProduct(Product product) async {
    try {
      final model = ProductModel.fromEntity(product);
      return await _firebaseService.addProduct(model);
    } catch (e) {
      throw Exception('Failed to Add Product: $e');
    }
  }

  @override
  Future<void> updateProduct(String id, Product product) async {
    try {
      final model = ProductModel.fromEntity(product);
      await _firebaseService.updateProduct(id, model);
    } catch (e) {
      throw Exception('Failed to update product: $e');
    }
  }

  @override
  Future<void> deleteProduct(String id) async {
    try {
      await _firebaseService.deleteProduct(id);
    } catch (e) {
      throw Exception('Failed to delete product: $e');
    }
  }

  @override
  Future<Product?> getProduct(String id) async {
    try {
      final model = await _firebaseService.getProduct(id);
      return model?.toEntity();
    } catch (e) {
      throw Exception('Failed to get product: $e');
    }
  }

  @override
  Stream<List<Product>> getAllProducts() {
    try {
      return _firebaseService
          .getAllProducts()
          .map((models) => models.map((m) => m.toEntity()).toList());
    } catch (e) {
      throw Exception('Failed to get all products: $e');
    }
  }

  @override
  Stream<List<Product>> getProductsByCategory(String category) {
    try {
      return _firebaseService
          .getProductsByCategory(category)
          .map((models) => models.map((m) => m.toEntity()).toList());
    } catch (e) {
      throw Exception('Failed to get products by category: $e');
    }
  }

  @override
  Stream<List<Product>> getLowStockProducts() {
    try {
      return _firebaseService
          .getLowStockProducts()
          .map((models) => models.map((m) => m.toEntity()).toList());
    } catch (e) {
      throw Exception('Failed to get low stock products: $e');
    }
  }

  @override
  Stream<List<Product>> getExpiringProducts({int daysThreshold = 30}) {
    try {
      return _firebaseService
          .getExpiringProducts(daysThreshold: daysThreshold)
          .map((models) => models.map((m) => m.toEntity()).toList());
    } catch (e) {
      throw Exception('Failed to get expiring products: $e');
    }
  }

  @override
  Stream<List<Product>> getExpiredProducts() {
    try {
      return _firebaseService
          .getExpiredProducts()
          .map((models) => models.map((m) => m.toEntity()).toList());
    } catch (e) {
      throw Exception('Failed to get expired products: $e');
    }
  }

  @override
  Stream<List<Product>> searchProducts(String query) {
    try {
      return _firebaseService
          .searchProducts(query)
          .map((models) => models.map((m) => m.toEntity()).toList());
    } catch (e) {
      throw Exception('Failed to search products: $e');
    }
  }

  @override
  Future<String> addTransaction(StockTransaction transaction) async {
    try {
      final model = StockTransactionModel.fromEntity(transaction);
      return await _firebaseService.addTransaction(model);
    } catch (e) {
      throw Exception('Failed to add transaction: $e');
    }
  }

  @override
  Stream<List<StockTransaction>> getProductTransactions(String productId) {
    try {
      return _firebaseService
          .getProductTransactions(productId)
          .map((models) => models.map((m) => m.toEntity()).toList());
    } catch (e) {
      throw Exception('Failed to get product transactions: $e');
    }
  }

  @override
  Stream<List<StockTransaction>> getAllTransactions({
    int? limit,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    try {
      return _firebaseService
          .getAllTransactions(
        limit: limit,
        startDate: startDate,
        endDate: endDate,
      )
          .map((models) => models.map((m) => m.toEntity()).toList());
    } catch (e) {
      throw Exception('Failed to get all transactions: $e');
    }
  }

  @override
  Future<void> updateStockWithTransaction({
    required String productId,
    required int quantityChange,
    required StockTransaction transaction,
  }) async {
    try {
      final model = StockTransactionModel.fromEntity(transaction);
      await _firebaseService.updateStockWithTransaction(
        productId: productId,
        quantityChange: quantityChange,
        transaction: model,
      );
    } catch (e) {
      throw Exception('Failed to update stock with transaction: $e');
    }
  }
}