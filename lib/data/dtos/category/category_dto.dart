import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryDto {
  final String id;
  final String? name;
  final String? icon;
  final String? color;

  CategoryDto({
    required this.id,
    this.name,
    this.icon,
    this.color,
  });

  // Nhận dữ liệu thô (raw data) từ Firebase và bóc tách
  factory CategoryDto.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};

    return CategoryDto(
      id: doc.id,
      name: data['name']?.toString(),
      icon: data['icon']?.toString(),
      color: data['color']?.toString(),
    );
  }
}