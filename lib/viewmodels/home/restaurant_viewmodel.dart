import 'package:flutter/material.dart';
import '../../domain/entities/restaurant_entity.dart';
import '../../interfaces/repositories/irestaurant_repository.dart';

class RestaurantViewModel extends ChangeNotifier {
  final IRestaurantRepository _repository;

  List<RestaurantEntity> restaurants = [];
  bool isLoading = false;
  String? errorMessage;

  // Constructor yêu cầu phải tiêm Repository vào
  RestaurantViewModel(this._repository);

  Future<void> fetchRestaurants() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners(); // Báo UI: Đang tải dữ liệu!

    try {
      restaurants = await _repository.getHighRatingRestaurants();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners(); // Báo UI: Tải xong rồi (hoặc lỗi), vẽ lại màn hình đi!
    }
  }
}