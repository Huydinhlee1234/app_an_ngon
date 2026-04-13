import '../../../domain/entities/restaurant_entity.dart';
import '../../dtos/restaurant/restaurant_dto.dart';

class RestaurantMapper {
  // Lấy DTO (có thể null) và biến thành Entity (chuẩn 100%)
  static RestaurantEntity toEntity(RestaurantDto dto) {
    return RestaurantEntity(
      id: dto.id,
      name: dto.name ?? 'Nhà hàng ẩn danh',
      cuisine: dto.cuisine ?? 'Đang cập nhật',

      // Xử lý ép kiểu ở đây
      rating: dto.rating?.toDouble() ?? 0.0,
      reviewCount: dto.reviewCount?.toInt() ?? 0,
      priceRange: dto.priceRange?.toInt() ?? 1,
      distance: dto.distance?.toDouble() ?? 0.0,

      address: dto.address ?? 'Đang cập nhật địa chỉ',
      hours: dto.hours ?? 'Đang cập nhật',
      isOpen: dto.isOpen ?? true,
      image: dto.image ?? 'https://via.placeholder.com/150',

      // Chuyển List<dynamic> thành List<String> an toàn
      images: dto.images?.map((e) => e.toString()).toList() ?? [],

      description: dto.description ?? 'Chưa có mô tả chi tiết.',
    );
  }
}