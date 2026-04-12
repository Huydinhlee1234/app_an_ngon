import '../../dtos/restaurant/restaurant_dto.dart';
import '../../../domain/entities/restaurant_entity.dart';

class RestaurantMapper {
  static RestaurantEntity toEntity(String documentId, RestaurantDto dto) {
    return RestaurantEntity(
      id: documentId, // ID lấy từ Document ID của Firebase
      name: dto.name ?? 'Chưa có tên',
      cuisine: dto.cuisine ?? 'Đang cập nhật',
      rating: (dto.rating ?? 0.0).toDouble(),
      reviewCount: dto.reviewCount ?? 0,
      priceRange: dto.priceRange ?? 1,
      distance: (dto.distance ?? 0.0).toDouble(),
      address: dto.address ?? 'Chưa có địa chỉ',
      hours: dto.hours ?? 'Chưa rõ',
      isOpen: dto.isOpen ?? false,
      imageUrl: dto.image ?? '',
      images: dto.images?.map((e) => e.toString()).toList() ?? [],
      description: dto.description ?? 'Chưa có mô tả',
    );
  }
}