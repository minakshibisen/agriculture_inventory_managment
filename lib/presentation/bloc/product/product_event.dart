import 'package:equatable/equatable.dart';
import '../../../domain/entities/product.dart';

/// Events for Product BLoC
abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

/// Load all products
class LoadProducts extends ProductEvent {
  const LoadProducts();
}

/// Load products by category
class LoadProductsByCategory extends ProductEvent {
  final String category;

  const LoadProductsByCategory(this.category);

  @override
  List<Object?> get props => [category];
}

/// Load low stock products
class LoadLowStockProducts extends ProductEvent {
  const LoadLowStockProducts();
}

/// Load expiring products
class LoadExpiringProducts extends ProductEvent {
  final int daysThreshold;

  const LoadExpiringProducts({this.daysThreshold = 30});

  @override
  List<Object?> get props => [daysThreshold];
}

/// Load expired products
class LoadExpiredProducts extends ProductEvent {
  const LoadExpiredProducts();
}

/// Search products
class SearchProducts extends ProductEvent {
  final String query;

  const SearchProducts(this.query);

  @override
  List<Object?> get props => [query];
}

/// Add a new product
class AddProduct extends ProductEvent {
  final Product product;

  const AddProduct(this.product);

  @override
  List<Object?> get props => [product];
}

/// Update an existing product
class UpdateProduct extends ProductEvent {
  final String id;
  final Product product;

  const UpdateProduct({required this.id, required this.product});

  @override
  List<Object?> get props => [id, product];
}

/// Delete a product
class DeleteProduct extends ProductEvent {
  final String id;

  const DeleteProduct(this.id);

  @override
  List<Object?> get props => [id];
}

/// Get a single product
class GetProduct extends ProductEvent {
  final String id;

  const GetProduct(this.id);

  @override
  List<Object?> get props => [id];
}