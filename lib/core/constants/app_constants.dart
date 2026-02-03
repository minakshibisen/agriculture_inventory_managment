class AppConstants {
  // App Info
  static const String appName = 'Krishi Seva Kendra';
  static const String appVersion = '1.0.0';

  // Product Categories
  static const List<String> productCategories = [
    'Pesticides',
    'Fertilizers',
    'Herbicides',
    'Fungicides',
    'Insecticides',
    'Seeds',
    'Growth Regulators',
    'Bio-pesticides',
    'Micronutrients',
    'Other',
  ];

  // Units of Measurement
  static const List<String> units = [
    'kg',
    'liter',
    'gram',
    'ml',
    'pieces',
    'packets',
    'boxes',
  ];

  // Stock Alert Thresholds
  static const int lowStockThreshold = 10;
  static const int expiryAlertDays = 30;

  // Pagination
  static const int itemsPerPage = 20;

  // Date Formats
  static const String dateFormat = 'dd/MM/yyyy';
  static const String dateTimeFormat = 'dd/MM/yyyy HH:mm';

  // Validation
  static const int minProductNameLength = 3;
  static const int maxProductNameLength = 100;
  static const int minStockQuantity = 0;
  static const double minPrice = 0.0;

  // Firebase Collections
  static const String productsCollection = 'products';
  static const String transactionsCollection = 'transactions';
  static const String usersCollection = 'users';

  // Error Messages
  static const String networkError = 'Network connection error. Please check your internet connection.';
  static const String genericError = 'Something went wrong. Please try again.';
  static const String authError = 'Authentication error. Please login again.';
  static const String validationError = 'Please check your input and try again.';

  // Success Messages
  static const String productAddedSuccess = 'Product added successfully';
  static const String productUpdatedSuccess = 'Product updated successfully';
  static const String productDeletedSuccess = 'Product deleted successfully';
  static const String stockUpdatedSuccess = 'Stock updated successfully';

  // Transaction Types
  static const Map<String, String> transactionTypeLabels = {
    'incoming': 'Stock In',
    'outgoing': 'Stock Out',
    'adjustment': 'Adjustment',
    'expired': 'Expired',
    'damaged': 'Damaged',
  };
}