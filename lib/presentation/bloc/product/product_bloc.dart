import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    try {
      emit(const ProductLoading());
      await _productSubscription?.cancel();

      // This should return a Stream
      _productSubscription = _productRepository.getAllProducts().listen(
            (products) {
          emit(ProductsLoaded(products));
        },
        onError: (error) {
          emit(ProductError(error.toString()));
        },
      );
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }
  Future<void> _onLoadProductsByCategory(
      LoadProductsByCategory event,
      Emitter<ProductState> emit,
      ) async {
    try {
      emit(const ProductLoading());
      await _productSubscription?.cancel();
      _productSubscription =
          _productRepository.getProductsByCategory(event.category).listen(
                (products) {
              emit(ProductsLoaded(products));
            },
            onError: (error) {
              emit(ProductError(error.toString()));
            },
          );
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> _onLoadLowStockProducts(
      LoadLowStockProducts event,
      Emitter<ProductState> emit,
      ) async {
    try {
      emit(const ProductLoading());
      await _productSubscription?.cancel();
      _productSubscription = _productRepository.getLowStockProducts().listen(
            (products) {
          emit(ProductsLoaded(products));
        },
        onError: (error) {
          emit(ProductError(error.toString()));
        },
      );
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> _onLoadExpiringProducts(
      LoadExpiringProducts event,
      Emitter<ProductState> emit,
      ) async {
    try {
      emit(const ProductLoading());
      await _productSubscription?.cancel();
      _productSubscription = _productRepository
          .getExpiringProducts(daysThreshold: event.daysThreshold)
          .listen(
            (products) {
          emit(ProductsLoaded(products));
        },
        onError: (error) {
          emit(ProductError(error.toString()));
        },
      );
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> _onLoadExpiredProducts(
      LoadExpiredProducts event,
      Emitter<ProductState> emit,
      ) async {
    try {
      emit(const ProductLoading());
      await _productSubscription?.cancel();
      _productSubscription = _productRepository.getExpiredProducts().listen(
            (products) {
          emit(ProductsLoaded(products));
        },
        onError: (error) {
          emit(ProductError(error.toString()));
        },
      );
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> _onSearchProducts(
      SearchProducts event,
      Emitter<ProductState> emit,
      ) async {
    try {
      if (event.query.isEmpty) {
        add(const LoadProducts());
        return;
      }
      emit(const ProductLoading());
      await _productSubscription?.cancel();
      _productSubscription =
          _productRepository.searchProducts(event.query).listen(
                (products) {
              emit(ProductsLoaded(products));
            },
            onError: (error) {
              emit(ProductError(error.toString()));
            },
          );
    } catch (e) {
      emit(ProductError(e.toString()));
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
      emit(ProductError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _productSubscription?.cancel();
    return super.close();
  }
}