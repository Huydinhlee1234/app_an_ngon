import 'package:flutter/material.dart';
import '../../domain/entities/restaurant_entity.dart';

class RestaurantCard extends StatelessWidget {
  final RestaurantEntity restaurant;
  final VoidCallback onTap;
  final VoidCallback onBookmarkToggle;
  final bool isSaved;

  const RestaurantCard({
    Key? key,
    required this.restaurant,
    required this.onTap,
    required this.onBookmarkToggle,
    required this.isSaved,
  }) : super(key: key);

  // Hàm tạo chuỗi ký tự tiền tệ (giống priceLabel trong React)
  String _priceLabel(int range) => '₫' * range;

  @override
  Widget build(BuildContext context) {
    // GestureDetector tương đương với onClick trong React
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16), // rounded-2xl
          boxShadow: [
            BoxShadow(
              color: Colors.lightBlueAccent.withOpacity(0.1),
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Phần Hình ảnh (tương đương relative h-36)
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.network(
                    restaurant.imageUrl,
                    height: 144, // ~ h-36
                    width: double.infinity,
                    fit: BoxFit.cover,
                    // Trong thực tế nên dùng CachedNetworkImage
                  ),
                ),
                // Nút Bookmark góc phải
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: onBookmarkToggle,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 16,
                      child: Icon(
                        isSaved ? Icons.bookmark : Icons.bookmark_border,
                        color: isSaved ? Colors.lightBlue : Colors.grey,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Phần Thông tin (tương đương div p-3)
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    restaurant.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis, // truncate
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        '${restaurant.rating}',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${restaurant.address} · ${_priceLabel(2)}', // Tạm fix priceRange 2
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}