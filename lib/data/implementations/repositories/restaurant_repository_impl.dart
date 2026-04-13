import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../domain/entities/restaurant_entity.dart';
import '../../../interfaces/repositories/irestaurant_repository.dart';
import '../../dtos/restaurant/restaurant_dto.dart';
import '../mapper/restaurant_mapper.dart';
import '../../../core/constants/app_constants.dart';

class RestaurantRepositoryImpl implements IRestaurantRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<List<RestaurantEntity>> getHighRatingRestaurants() async {
    final snapshot = await _firestore
        .collection(AppConstants.restaurantsCollection) // Thay chuỗi 'restaurants' bằng hằng số
        .where('rating', isGreaterThanOrEqualTo: 4.0)
        .orderBy('rating', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      final dto = RestaurantDto.fromJson(doc.data());
      return RestaurantMapper.toEntity(doc.id, dto);
    }).toList();
  }
}