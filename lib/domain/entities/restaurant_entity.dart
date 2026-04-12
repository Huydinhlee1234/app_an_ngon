class RestaurantEntity {
  final String id;
  final String name;
  final String cuisine; // Thể loại (ví dụ: Phở, Cà phê)
  final double rating;
  final int reviewCount;
  final int priceRange; // Mức giá (1-4, tương ứng số lượng ký hiệu ₫)
  final double distance; // Khoảng cách (km)
  final String address;
  final String hours;
  final bool isOpen;
  final String imageUrl;
  final List<String> images; // Danh sách ảnh cho màn hình chi tiết
  final String description;

  RestaurantEntity({
    required this.id,
    required this.name,
    required this.cuisine,
    required this.rating,
    required this.reviewCount,
    required this.priceRange,
    required this.distance,
    required this.address,
    required this.hours,
    required this.isOpen,
    required this.imageUrl,
    required this.images,
    required this.description,
  });
}