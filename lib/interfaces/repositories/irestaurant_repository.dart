import '../../domain/entities/restaurant_entity.dart';

abstract class IRestaurantRepository {
  // Hàm này hứa hẹn sẽ trả về một List các quán ăn (trong tương lai - Future)
  Future<List<RestaurantEntity>> getHighRatingRestaurants();
}