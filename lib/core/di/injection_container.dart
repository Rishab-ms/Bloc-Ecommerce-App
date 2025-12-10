import 'package:get_it/get_it.dart';
import '../network/dio_client.dart';
import '../../data/repositories/product_repository_impl.dart';
import '../../data/repositories/mock_cart_repository.dart';
import '../../domain/repositories/product_repository.dart';
import '../../domain/repositories/cart_repository.dart';

// Common name: "sl" = Service Locator.
// This gives us global access to the dependency container.
final sl = GetIt.instance;

// Called once in main.dart to register everything the app needs.
// After this, any part of the app can request a dependency from `sl`.
void setupLocator() {
  
  // ──────────────────────────────────────────────────────────────
  // CORE
  // ──────────────────────────────────────────────────────────────
  //
  // DioClient is registered as a lazy singleton.
  // Why lazy singleton?
  //
  // - It’s created only when first used.
  // - Afterwards, the same instance is reused everywhere.
  // - This is important because:
  //     • One Dio instance = consistent interceptors, headers, cookies, etc.
  //     • Avoids unnecessarily creating multiple HTTP clients.
  //     • Many features (logging, auth, cookies) break if multiple clients exist.
  //
  sl.registerLazySingleton<DioClient>(() => DioClient());



  // ──────────────────────────────────────────────────────────────
  // REPOSITORIES
  // ──────────────────────────────────────────────────────────────
  //
  // ProductRepository → ProductRepositoryImpl
  //
  // Why register interfaces instead of concrete classes?
  // - Allows swapping implementations later (e.g., mock, real API).
  // - Keeps UI and business logic decoupled from data layer.
  // - Makes testing much easier because we can replace with a fake.
  //
  // Why use DI to inject DioClient?
  // - The repo becomes independent of how DioClient is created.
  // - The repo only cares about the contract, not the setup.
  // - Makes repository code easier to test and maintain.
  //
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(dioClient: sl<DioClient>()),
  );



  // CartRepository → MockCartRepository
  //
  // Why singleton?
  // - This repository holds in-memory state (cart items).
  // - If we created a *new* instance each time, state would reset.
  // - Singleton ensures the cart behaves like a persistent store
  //   for the duration of the app session.
  //
  // Why still register via GetIt?
  // - Even though it's "just" a singleton, keeping it in DI means:
  //     • Easy to replace with a real API-based repo later.
  //     • UI stays completely unaware of how the cart is stored.
  //     • Everything follows one consistent pattern.
  //
  sl.registerLazySingleton<CartRepository>(
    () => MockCartRepository(),
  );



  // ──────────────────────────────────────────────────────────────
  // BLOCS
  // ──────────────────────────────────────────────────────────────
  //
  // Why register blocs here (when added later)?
  // - Keeps creation logic in one place.
  // - Makes blocs easy to test or replace.
  // - Ensures each bloc receives the correct repositories.
  //
  // Example:
  // sl.registerFactory(() => HomeBloc(sl<ProductRepository>()));
}
