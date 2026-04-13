import 'package:get_it/get_it.dart';
import 'data/implementations/repositories/restaurant_repository_impl.dart';
import 'interfaces/repositories/irestaurant_repository.dart';
import 'viewmodels/home/restaurant_viewmodel.dart';
import 'data/implementations/repositories/auth_repository_impl.dart';
import 'interfaces/repositories/iauth_repository.dart';
import 'viewmodels/auth/auth_viewmodel.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  // 1. Dạy cho app biết: Cứ ai đòi IRestaurantRepository thì đưa cho họ RestaurantRepositoryImpl
  getIt.registerLazySingleton<IRestaurantRepository>(
        () => RestaurantRepositoryImpl(),
  );

  // 2. Dạy cho app biết cách khởi tạo RestaurantViewModel
  getIt.registerFactory(
        () => RestaurantViewModel(getIt<IRestaurantRepository>()),
  );

  // --- AUTH ---
  getIt.registerLazySingleton<IAuthRepository>(() => AuthRepositoryImpl());
  getIt.registerLazySingleton<AuthViewModel>(() => AuthViewModel(getIt<IAuthRepository>()));
}