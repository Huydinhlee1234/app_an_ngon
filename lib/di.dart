import 'package:get_it/get_it.dart';

// --- Imports Interfaces ---
import 'interfaces/repositories/iauth_repository.dart';
import 'interfaces/repositories/irestaurant_repository.dart';
import 'interfaces/repositories/isearch_repository.dart';

// --- Imports Implementations ---
import 'data/implementations/repositories/auth_repository_impl.dart';
import 'data/implementations/repositories/restaurant_repository_impl.dart';
import 'data/implementations/repositories/search_repository_impl.dart';

// --- Imports ViewModels ---
import 'viewmodels/auth/auth_viewmodel.dart';
import 'viewmodels/home/restaurant_viewmodel.dart';
import 'viewmodels/search/search_viewmodel.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  // 1. Đăng ký Repositories (Dùng LazySingleton để chỉ tạo 1 bản sao duy nhất trong suốt vòng đời app)
  // Lưu ý: Nếu bạn chưa có file AuthRepositoryImpl, hãy tạm comment dòng Auth lại nhé.
  getIt.registerLazySingleton<IAuthRepository>(() => AuthRepositoryImpl());
  getIt.registerLazySingleton<IRestaurantRepository>(() => RestaurantRepositoryImpl());
  getIt.registerLazySingleton<ISearchRepository>(() => SearchRepositoryImpl());

  // 2. Đăng ký ViewModels (Dùng Factory để mỗi lần gọi là một instance mới, hoặc tiêm vào Provider)
  // getIt() sẽ tự động tìm các Repository đã đăng ký ở trên để nhét vào constructor của ViewModel
  getIt.registerFactory(() => AuthViewModel(getIt<IAuthRepository>()));
  getIt.registerFactory(() => RestaurantViewModel(getIt<IRestaurantRepository>()));

  // SearchViewModel cần tới 2 kho dữ liệu: Quán ăn và Lịch sử tìm kiếm
  getIt.registerFactory(() => SearchViewModel(
    getIt<IRestaurantRepository>(),
    getIt<ISearchRepository>(),
  ));
}