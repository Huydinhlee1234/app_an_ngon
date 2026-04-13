import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../domain/entities/category_entity.dart';
import '../../../domain/entities/restaurant_entity.dart';
import '../../../interfaces/repositories/irestaurant_repository.dart';
import '../../dtos/category/category_dto.dart';
import '../../dtos/restaurant/restaurant_dto.dart';
import '../mapper/category_mapper.dart';
import '../mapper/restaurant_mapper.dart';

class RestaurantRepositoryImpl implements IRestaurantRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<List<CategoryEntity>> getCategories() async {
    try {
      final snapshot = await _firestore.collection('categories').get();

      // Chuyển Firebase Doc -> DTO -> Entity
      return snapshot.docs.map((doc) {
        final dto = CategoryDto.fromFirestore(doc);
        return CategoryMapper.toEntity(dto);
      }).toList();

    } catch (e) {
      throw Exception('Lỗi khi tải danh mục: $e');
    }
  }

  @override
  Future<List<RestaurantEntity>> getHighRatingRestaurants() async {
    try {
      final snapshot = await _firestore.collection('restaurants').orderBy('rating', descending: true).get();

      return snapshot.docs.map((doc) {
        // Bước 1: Firebase -> DTO
        final dto = RestaurantDto.fromFirestore(doc);

        // Bước 2: DTO -> Entity
        return RestaurantMapper.toEntity(dto);
      }).toList();

    } catch (e) {
      throw Exception('Lỗi khi tải danh sách nhà hàng: $e');
    }
  }
}