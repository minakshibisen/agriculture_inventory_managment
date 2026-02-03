import 'package:get_it/get_it.dart';

import '../../data/firebase_service/firebase_service.dart';
import '../../domain/repository/product_repository.dart';
import '../../domain/repository/product_repository_impl.dart';
import '../../presentation/bloc/product/product_bloc.dart';
import '../../presentation/bloc/transaction/transaction_bloc.dart';


final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Services
  getIt.registerLazySingleton<FirebaseService>(
        () => FirebaseService(),
  );

  // Repositories
  getIt.registerLazySingleton<ProductRepository>(
        () => ProductRepositoryImpl(
      firebaseService: getIt<FirebaseService>(),
    ),
  );

  // BLoCs
  getIt.registerFactory<ProductBloc>(
        () => ProductBloc(
      productRepository: getIt<ProductRepository>(),
    ),
  );

  getIt.registerFactory<TransactionBloc>(
        () => TransactionBloc(
      productRepository: getIt<ProductRepository>(),
    ),
  );
}