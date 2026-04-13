import '../../domain/entities/category_entity.dart';
import '../../domain/entities/restaurant_entity.dart';

abstract class IRestaurantRepository {
  Future<List<CategoryEntity>> getCategories();
  Future<List<RestaurantEntity>> getHighRatingRestaurants();
}