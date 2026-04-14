class RestaurantEntity {
  final String id;
  final String name;
  final String category; // MỚI: Mã danh mục (pho, banhmi...) để dùng cho Filter
  final String cuisine;
  final double rating;
  final int reviewCount;
  final int priceRange;
  final double distance;
  final String address;
  final String hours;
  final bool isOpen;
  final String image;
  final List<String> images;
  final List<String> tags; // MỚI: Mảng từ khóa để công cụ Tìm kiếm quét qua
  final String description;

  RestaurantEntity({
    required this.id,
    required this.name,
    required this.category,
    required this.cuisine,
    required this.rating,
    required this.reviewCount,
    required this.priceRange,
    required this.distance,
    required this.address,
    required this.hours,
    required this.isOpen,
    required this.image,
    required this.images,
    required this.tags,
    required this.description,
  });
}