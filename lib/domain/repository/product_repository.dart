import '../entities/product.dart';
import '../entities/stock_transaction_entity.dart';

/// Repository interface for product operations
abstract class ProductRepository {
  /// Add a new product
  Future<String> addProduct(Product product);

  /// Update an existing product
  Future<void> updateProduct(String id, Product product);

  /// Delete a product
  Future<void> deleteProduct(String id);

  /// Get a single product by ID
  Future<Product?> getProduct(String id);

  /// Get all active products
  Stream<List<Product>> getAllProducts();

  /// Get products by category
  Stream<List<Product>> getProductsByCategory(String category);

  /// Get low stock products
  Stream<List<Product>> getLowStockProducts();

  /// Get expiring products
  Stream<List<Product>> getExpiringProducts({int daysThreshold = 30});

  /// Get expired products
  Stream<List<Product>> getExpiredProducts();

  /// Search products by name
  Stream<List<Product>> searchProducts(String query);

  /// Add a stock transaction
  Future<String> addTransaction(StockTransaction transaction);

  /// Get transactions for a product
  Stream<List<StockTransaction>> getProductTransactions(String productId);

  /// Get all transactions
  Stream<List<StockTransaction>> getAllTransactions({
    int? limit,
    DateTime? startDate,
    DateTime? endDate,
  });

  /// Update product stock with transaction
  Future<void> updateStockWithTransaction({
    required String productId,
    required int quantityChange,
    required StockTransaction transaction,
  });
}