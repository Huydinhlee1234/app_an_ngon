import '../../../domain/entities/restaurant_entity.dart';
import '../../dtos/restaurant/restaurant_dto.dart';

class RestaurantMapper {
  static RestaurantEntity toEntity(RestaurantDto dto) {
    return RestaurantEntity(
      id: dto.id,
      name: dto.name ?? 'Nhà hàng ẩn danh',
      category: dto.category ?? 'other',
      cuisine: dto.cuisine ?? 'Đang cập nhật',
      rating: dto.rating?.toDouble() ?? 0.0,
      reviewCount: dto.reviewCount?.toInt() ?? 0,
      priceRange: dto.priceRange?.toInt() ?? 1,
      distance: dto.distance?.toDouble() ?? 0.0,
      address: dto.address ?? 'Đang cập nhật địa chỉ',
      hours: dto.hours ?? 'Đang cập nhật',
      isOpen: dto.isOpen ?? true,
      image: dto.image ?? 'https://via.placeholder.com/150',
      images: dto.images?.map((e) => e.toString()).toList() ?? [],
      tags: dto.tags?.map((e) => e.toString()).toList() ?? [],
      description: dto.description ?? 'Chưa có mô tả chi tiết.',
    );
  }
}