import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/product_model.dart';
import '../model/stock_transaction.dart';


/// Service class for Firebase Firestore operations
class FirebaseService {
  final FirebaseFirestore _firestore;

  FirebaseService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  // Collection references
  CollectionReference get _productsCollection =>
      _firestore.collection('products');
  CollectionReference get _transactionsCollection =>
      _firestore.collection('transactions');

  // PRODUCT OPERATIONS

  /// Add a new product
  Future<String> addProduct(ProductModel product) async {
    try {
      final docRef = await _productsCollection.add(product.toFirestore());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to Add Product: $e');
    }
  }

  /// Update an existing product
  Future<void> updateProduct(String id, ProductModel product) async {
    try {
      await _productsCollection.doc(id).update(product.toFirestore());
    } catch (e) {
      throw Exception('Failed to update product: $e');
    }
  }

  /// Delete a product (soft delete)
  Future<void> deleteProduct(String id) async {
    try {
      await _productsCollection.doc(id).update({
        'isActive': false,
        'updatedAt': Timestamp.now(),
      });
    } catch (e) {
      throw Exception('Failed to delete product: $e');
    }
  }

  /// Get a single product by ID
  Future<ProductModel?> getProduct(String id) async {
    try {
      final doc = await _productsCollection.doc(id).get();
      if (doc.exists) {
        return ProductModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get product: $e');
    }
  }

  /// Get all active products - SIMPLIFIED (No compound index needed)
  Stream<List<ProductModel>> getAllProducts() {
    try {
      // Simple query without compound index
      return _productsCollection
          .where('isActive', isEqualTo: true)
          .snapshots()
          .map((snapshot) {
        final products = snapshot.docs
            .map((doc) => ProductModel.fromFirestore(doc))
            .toList();

        // Sort in memory instead of using orderBy (which requires index)
        products.sort((a, b) => a.name.compareTo(b.name));
        return products;
      });
    } catch (e) {
      throw Exception('Failed to get products: $e');
    }
  }

  /// Get products by category - SIMPLIFIED
  Stream<List<ProductModel>> getProductsByCategory(String category) {
    try {
      return _productsCollection
          .where('isActive', isEqualTo: true)
          .where('category', isEqualTo: category)
          .snapshots()
          .map((snapshot) {
        final products = snapshot.docs
            .map((doc) => ProductModel.fromFirestore(doc))
            .toList();

        // Sort in memory
        products.sort((a, b) => a.name.compareTo(b.name));
        return products;
      });
    } catch (e) {
      throw Exception('Failed to get products by category: $e');
    }
  }

  /// Get low stock products - SIMPLIFIED
  Stream<List<ProductModel>> getLowStockProducts() {
    try {
      return _productsCollection
          .where('isActive', isEqualTo: true)
          .snapshots()
          .map((snapshot) {
        final products = snapshot.docs
            .map((doc) => ProductModel.fromFirestore(doc))
            .where((p) => p.currentStock <= p.minimumStock)
            .toList();

        // Sort by stock level
        products.sort((a, b) => a.currentStock.compareTo(b.currentStock));
        return products;
      });
    } catch (e) {
      throw Exception('Failed to get low stock products: $e');
    }
  }

  /// Get expiring products (within specified days) - SIMPLIFIED
  Stream<List<ProductModel>> getExpiringProducts({int daysThreshold = 30}) {
    try {
      final now = DateTime.now();
      final thresholdDate = now.add(Duration(days: daysThreshold));

      return _productsCollection
          .where('isActive', isEqualTo: true)
          .snapshots()
          .map((snapshot) {
        final products = snapshot.docs
            .map((doc) => ProductModel.fromFirestore(doc))
            .where((p) =>
        p.expiryDate.isAfter(now) &&
            p.expiryDate.isBefore(thresholdDate))
            .toList();

        // Sort by expiry date
        products.sort((a, b) => a.expiryDate.compareTo(b.expiryDate));
        return products;
      });
    } catch (e) {
      throw Exception('Failed to get expiring products: $e');
    }
  }

  /// Get expired products - SIMPLIFIED
  Stream<List<ProductModel>> getExpiredProducts() {
    try {
      final now = DateTime.now();

      return _productsCollection
          .where('isActive', isEqualTo: true)
          .snapshots()
          .map((snapshot) {
        final products = snapshot.docs
            .map((doc) => ProductModel.fromFirestore(doc))
            .where((p) => p.expiryDate.isBefore(now))
            .toList();

        // Sort by expiry date (most recently expired first)
        products.sort((a, b) => b.expiryDate.compareTo(a.expiryDate));
        return products;
      });
    } catch (e) {
      throw Exception('Failed to get expired products: $e');
    }
  }

  /// Search products by name - SIMPLIFIED
  Stream<List<ProductModel>> searchProducts(String query) {
    try {
      final lowercaseQuery = query.toLowerCase();

      return _productsCollection
          .where('isActive', isEqualTo: true)
          .snapshots()
          .map((snapshot) {
        final products = snapshot.docs
            .map((doc) => ProductModel.fromFirestore(doc))
            .where((p) => p.name.toLowerCase().contains(lowercaseQuery))
            .toList();

        // Sort by relevance (exact matches first, then contains)
        products.sort((a, b) {
          final aName = a.name.toLowerCase();
          final bName = b.name.toLowerCase();

          // Exact match priority
          if (aName == lowercaseQuery && bName != lowercaseQuery) return -1;
          if (bName == lowercaseQuery && aName != lowercaseQuery) return 1;

          // Starts with priority
          if (aName.startsWith(lowercaseQuery) && !bName.startsWith(lowercaseQuery)) return -1;
          if (bName.startsWith(lowercaseQuery) && !aName.startsWith(lowercaseQuery)) return 1;

          // Alphabetical
          return aName.compareTo(bName);
        });

        return products;
      });
    } catch (e) {
      throw Exception('Failed to search products: $e');
    }
  }

  // STOCK TRANSACTION OPERATIONS

  /// Add a new stock transaction
  Future<String> addTransaction(StockTransactionModel transaction) async {
    try {
      final docRef =
      await _transactionsCollection.add(transaction.toFirestore());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to add transaction: $e');
    }
  }

  /// Get all transactions for a product
  Stream<List<StockTransactionModel>> getProductTransactions(
      String productId) {
    try {
      return _transactionsCollection
          .where('productId', isEqualTo: productId)
          .snapshots()
          .map((snapshot) {
        final transactions = snapshot.docs
            .map((doc) => StockTransactionModel.fromFirestore(doc))
            .toList();

        // Sort in memory by transaction date (descending)
        transactions.sort((a, b) => b.transactionDate.compareTo(a.transactionDate));
        return transactions;
      });
    } catch (e) {
      throw Exception('Failed to get product transactions: $e');
    }
  }

  /// Get all transactions
  Stream<List<StockTransactionModel>> getAllTransactions(
      {int? limit, DateTime? startDate, DateTime? endDate}) {
    try {
      return _transactionsCollection
          .snapshots()
          .map((snapshot) {
        var transactions = snapshot.docs
            .map((doc) => StockTransactionModel.fromFirestore(doc))
            .toList();

        // Filter by date range in memory
        if (startDate != null) {
          transactions = transactions
              .where((t) => t.transactionDate.isAfter(startDate))
              .toList();
        }

        if (endDate != null) {
          transactions = transactions
              .where((t) => t.transactionDate.isBefore(endDate))
              .toList();
        }

        // Sort by transaction date (descending)
        transactions.sort((a, b) => b.transactionDate.compareTo(a.transactionDate));

        // Apply limit in memory
        if (limit != null && transactions.length > limit) {
          transactions = transactions.sublist(0, limit);
        }

        return transactions;
      });
    } catch (e) {
      throw Exception('Failed to get transactions: $e');
    }
  }

  /// Update product stock with transaction
  Future<void> updateStockWithTransaction({
    required String productId,
    required int quantityChange,
    required StockTransactionModel transaction,
  }) async {
    try {
      await _firestore.runTransaction((txn) async {
        final productDoc = await txn.get(_productsCollection.doc(productId));

        if (!productDoc.exists) {
          throw Exception('Product not found');
        }

        final currentStock = productDoc.get('currentStock') as int;
        final newStock = currentStock + quantityChange;

        if (newStock < 0) {
          throw Exception('Insufficient stock');
        }

        // Update product stock
        txn.update(_productsCollection.doc(productId), {
          'currentStock': newStock,
          'updatedAt': Timestamp.now(),
        });

        // Add transaction record
        final transactionWithBalance = StockTransactionModel(
          id: transaction.id,
          productId: transaction.productId,
          productName: transaction.productName,
          type: transaction.type,
          quantity: transaction.quantity,
          balanceAfter: newStock,
          pricePerUnit: transaction.pricePerUnit,
          totalAmount: transaction.totalAmount,
          remarks: transaction.remarks,
          invoiceNumber: transaction.invoiceNumber,
          supplierName: transaction.supplierName,
          transactionDate: transaction.transactionDate,
          createdBy: transaction.createdBy,
          createdAt: transaction.createdAt,
        );

        txn.set(_transactionsCollection.doc(),
            transactionWithBalance.toFirestore());
      });
    } catch (e) {
      throw Exception('Failed to update stock: $e');
    }
  }
}