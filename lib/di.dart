import 'package:get_it/get_it.dart';
import 'data/implementations/repositories/restaurantRepositoryImpl.dart';
import 'interfaces/repositories/IRestaurantRepository.dart';
import 'viewmodels/home/restaurant_viewmodel.dart';

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
}