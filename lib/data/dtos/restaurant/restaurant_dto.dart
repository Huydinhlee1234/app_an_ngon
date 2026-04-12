class RestaurantDto {
  final String? name;
  final String? cuisine;
  final num? rating;
  final int? reviewCount;
  final int? priceRange;
  final num? distance;
  final String? address;
  final String? hours;
  final bool? isOpen;
  final String? image;
  final List<dynamic>? images;
  final String? description;

  RestaurantDto({
    this.name,
    this.cuisine,
    this.rating,
    this.reviewCount,
    this.priceRange,
    this.distance,
    this.address,
    this.hours,
    this.isOpen,
    this.image,
    this.images,
    this.description,
  });

  // Hàm chuyển từ JSON của Firebase sang DTO
  factory RestaurantDto.fromJson(Map<String, dynamic> json) {
    return RestaurantDto(
      name: json['name'],
      cuisine: json['cuisine'],
      rating: json['rating'],
      reviewCount: json['reviewCount'],
      priceRange: json['priceRange'],
      distance: json['distance'],
      address: json['address'],
      hours: json['hours'],
      isOpen: json['isOpen'],
      image: json['image'],
      images: json['images'],
      description: json['description'],
    );
  }
}