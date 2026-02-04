import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/product.dart';
import '../../../domain/repository/product_repository.dart';
import 'product_event.dart';
import 'product_state.dart';

/// BLoC for managing product operations
class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository _productRepository;
  StreamSubscription? _productSubscription;

  ProductBloc({required ProductRepository productRepository})
      : _productRepository = productRepository,
        super(const ProductInitial()) {
    on<LoadProducts>(_onLoadProducts);
    on<LoadProductsByCategory>(_onLoadProductsByCategory);
    on<LoadLowStockProducts>(_onLoadLowStockProducts);
    on<LoadExpiringProducts>(_onLoadExpiringProducts);
    on<LoadExpiredProducts>(_onLoadExpiredProducts);
    on<SearchProducts>(_onSearchProducts);
    on<AddProduct>(_onAddProduct);
    on<UpdateProduct>(_onUpdateProduct);
    on<DeleteProduct>(_onDeleteProduct);
    on<GetProduct>(_onGetProduct);
  }

  Future<void> _onLoadProducts(
      LoadProducts event,
      Emitter<ProductState> emit,
      ) async {
    emit(const ProductLoading());

    try {
      await _productSubscription?.cancel();

      await emit.forEach<List<Product>>(
        _productRepository.getAllProducts(),
        onData: (products) => ProductsLoaded(products),
        onError: (error, stackTrace) {
          print('Error loading products: $error');
          return ProductError(error.toString());
        },
      );
    } catch (e) {
      print('Exception in _onLoadProducts: $e');
      if (!emit.isDone) {
        emit(ProductError(e.toString()));
      }
    }
  }

  Future<void> _onLoadProductsByCategory(
      LoadProductsByCategory event,
      Emitter<ProductState> emit,
      ) async {
    emit(const ProductLoading());

    try {
      await _productSubscription?.cancel();

      await emit.forEach<List<Product>>(
        _productRepository.getProductsByCategory(event.category),
        onData: (products) => ProductsLoaded(products),
        onError: (error, stackTrace) {
          print('Error loading products by category: $error');
          return ProductError(error.toString());
        },
      );
    } catch (e) {
      print('Exception in _onLoadProductsByCategory: $e');
      if (!emit.isDone) {
        emit(ProductError(e.toString()));
      }
    }
  }

  Future<void> _onLoadLowStockProducts(
      LoadLowStockProducts event,
      Emitter<ProductState> emit,
      ) async {
    emit(const ProductLoading());

    try {
      await _productSubscription?.cancel();

      await emit.forEach<List<Product>>(
        _productRepository.getLowStockProducts(),
        onData: (products) => ProductsLoaded(products),
        onError: (error, stackTrace) {
          print('Error loading low stock products: $error');
          return ProductError(error.toString());
        },
      );
    } catch (e) {
      print('Exception in _onLoadLowStockProducts: $e');
      if (!emit.isDone) {
        emit(ProductError(e.toString()));
      }
    }
  }

  Future<void> _onLoadExpiringProducts(
      LoadExpiringProducts event,
      Emitter<ProductState> emit,
      ) async {
    emit(const ProductLoading());

    try {
      await _productSubscription?.cancel();

      await emit.forEach<List<Product>>(
        _productRepository.getExpiringProducts(daysThreshold: event.daysThreshold),
        onData: (products) => ProductsLoaded(products),
        onError: (error, stackTrace) {
          print('Error loading expiring products: $error');
          return ProductError(error.toString());
        },
      );
    } catch (e) {
      print('Exception in _onLoadExpiringProducts: $e');
      if (!emit.isDone) {
        emit(ProductError(e.toString()));
      }
    }
  }

  Future<void> _onLoadExpiredProducts(
      LoadExpiredProducts event,
      Emitter<ProductState> emit,
      ) async {
    emit(const ProductLoading());

    try {
      await _productSubscription?.cancel();

      await emit.forEach<List<Product>>(
        _productRepository.getExpiredProducts(),
        onData: (products) => ProductsLoaded(products),
        onError: (error, stackTrace) {
          print('Error loading expired products: $error');
          return ProductError(error.toString());
        },
      );
    } catch (e) {
      print('Exception in _onLoadExpiredProducts: $e');
      if (!emit.isDone) {
        emit(ProductError(e.toString()));
      }
    }
  }

  Future<void> _onSearchProducts(
      SearchProducts event,
      Emitter<ProductState> emit,
      ) async {
    if (event.query.isEmpty) {
      add(const LoadProducts());
      return;
    }

    emit(const ProductLoading());

    try {
      await _productSubscription?.cancel();

      await emit.forEach<List<Product>>(
        _productRepository.searchProducts(event.query),
        onData: (products) => ProductsLoaded(products),
        onError: (error, stackTrace) {
          print('Error searching products: $error');
          return ProductError(error.toString());
        },
      );
    } catch (e) {
      print('Exception in _onSearchProducts: $e');
      if (!emit.isDone) {
        emit(ProductError(e.toString()));
      }
    }
  }

  Future<void> _onAddProduct(
      AddProduct event,
      Emitter<ProductState> emit,
      ) async {
    try {
      emit(const ProductLoading());
      await _productRepository.addProduct(event.product);
      emit(const ProductOperationSuccess('Product added successfully'));
      add(const LoadProducts());
    } catch (e) {
      print('Exception in _onAddProduct: $e');
      emit(ProductError(e.toString()));
    }
  }

  Future<void> _onUpdateProduct(
      UpdateProduct event,
      Emitter<ProductState> emit,
      ) async {
    try {
      emit(const ProductLoading());
      await _productRepository.updateProduct(event.id, event.product);
      emit(const ProductOperationSuccess('Product updated successfully'));
      add(const LoadProducts());
    } catch (e) {
      print('Exception in _onUpdateProduct: $e');
      emit(ProductError(e.toString()));
    }
  }

  Future<void> _onDeleteProduct(
      DeleteProduct event,
      Emitter<ProductState> emit,
      ) async {
    try {
      emit(const ProductLoading());
      await _productRepository.deleteProduct(event.id);
      emit(const ProductOperationSuccess('Product deleted successfully'));
      add(const LoadProducts());
    } catch (e) {
      print('Exception in _onDeleteProduct: $e');
      emit(ProductError(e.toString()));
    }
  }

  Future<void> _onGetProduct(
      GetProduct event,
      Emitter<ProductState> emit,
      ) async {
    try {
      emit(const ProductLoading());
      final product = await _productRepository.getProduct(event.id);
      if (product != null) {
        emit(ProductLoaded(product));
      } else {
        emit(const ProductError('Product not found'));
      }
    } catch (e) {
      print('Exception in _onGetProduct: $e');
      emit(ProductError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _productSubscription?.cancel();
    return super.close();
  }
}