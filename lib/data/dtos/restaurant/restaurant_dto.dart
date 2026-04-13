import 'package:cloud_firestore/cloud_firestore.dart';

class RestaurantDto {
  final String id;
  final String? name;
  final String? cuisine;
  // Dùng `num` vì Firebase có thể trả về 5 (int) hoặc 4.5 (double)
  final num? rating;
  final num? reviewCount;
  final num? priceRange;
  final num? distance;
  final String? address;
  final String? hours;
  final bool? isOpen;
  final String? image;
  // Dùng List<dynamic> vì Firebase mảng thô không rõ kiểu
  final List<dynamic>? images;
  final String? description;

  RestaurantDto({
    required this.id,
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

  // Hứng dữ liệu thô từ Firebase, KHÔNG XỬ LÝ LOGIC Ở ĐÂY
  factory RestaurantDto.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return RestaurantDto(
      id: doc.id,
      name: data['name']?.toString(),
      cuisine: data['cuisine']?.toString(),
      rating: data['rating'] as num?,
      reviewCount: data['reviewCount'] as num?,
      priceRange: data['priceRange'] as num?,
      distance: data['distance'] as num?,
      address: data['address']?.toString(),
      hours: data['hours']?.toString(),
      isOpen: data['isOpen'] as bool?,
      image: data['image']?.toString(),
      images: data['images'] as List<dynamic>?,
      description: data['description']?.toString(),
    );
  }
}