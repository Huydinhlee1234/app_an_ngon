import 'package:flutter/material.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/restaurant_entity.dart';
import '../../interfaces/repositories/irestaurant_repository.dart';

class RestaurantViewModel extends ChangeNotifier {
  final IRestaurantRepository _repository;

  List<RestaurantEntity> restaurants = [];
  List<CategoryEntity> categories = [];

  bool isLoading = false;
  String? errorMessage;

  RestaurantViewModel(this._repository);

  Future<void> loadInitialData() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      // Chạy 2 luồng tải dữ liệu song song để tiết kiệm thời gian
      final results = await Future.wait([
        _repository.getCategories(),
        _repository.getHighRatingRestaurants(),
      ]);

      categories = results[0] as List<CategoryEntity>;
      restaurants = results[1] as List<RestaurantEntity>;
    } catch (e) {
      errorMessage = 'Lỗi kết nối máy chủ: ${e.toString()}';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}