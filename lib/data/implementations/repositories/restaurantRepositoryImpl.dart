import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../domain/entities/restaurant_entity.dart';
import '../../../interfaces/repositories/IRestaurantRepository.dart';
import '../../dtos/restaurant/restaurant_dto.dart';
import '../mapper/restaurant_mapper.dart';

class RestaurantRepositoryImpl implements IRestaurantRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<List<RestaurantEntity>> getHighRatingRestaurants() async {
    final snapshot = await _firestore
        .collection('restaurants')
        .where('rating', isGreaterThanOrEqualTo: 4.0)
        .orderBy('rating', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      // 1. Chuyển JSON thành DTO
      final dto = RestaurantDto.fromJson(doc.data());
      // 2. Chuyển DTO thành Entity bằng Mapper
      return RestaurantMapper.toEntity(doc.id, dto);
    }).toList();
  }
}