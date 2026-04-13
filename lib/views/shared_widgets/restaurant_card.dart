// import 'package:flutter/material.dart';
// import '../../core/theme/app_colors.dart';
// import '../../domain/entities/restaurant_entity.dart';
//
// class RestaurantCard extends StatelessWidget {
//   final RestaurantEntity restaurant;
//   final bool isSaved;
//   final VoidCallback onTap;
//   final VoidCallback onBookmarkToggle;
//
//   const RestaurantCard({
//     Key? key,
//     required this.restaurant,
//     required this.isSaved,
//     required this.onTap,
//     required this.onBookmarkToggle,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(20),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withValues(alpha: 0.05),
//               blurRadius: 10,
//               offset: const Offset(0, 4),
//             )
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Thumbnail & Bookmark
//             Expanded(
//               child: Stack(
//                 children: [
//                   Container(
//                     decoration: BoxDecoration(
//                       borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
//                       image: DecorationImage(
//                         image: NetworkImage(restaurant.image),
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   ),
//                   Positioned(
//                     top: 8, right: 8,
//                     child: GestureDetector(
//                       onTap: onBookmarkToggle,
//                       child: Container(
//                         padding: const EdgeInsets.all(6),
//                         decoration: BoxDecoration(
//                           color: Colors.white.withValues(alpha: 0.9),
//                           shape: BoxShape.circle,
//                         ),
//                         child: Icon(
//                           isSaved ? Icons.favorite : Icons.favorite_border,
//                           color: isSaved ? Colors.red : Colors.grey,
//                           size: 18,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             // Thông tin Quán
//             Padding(
//               padding: const EdgeInsets.all(12.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     restaurant.name,
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                     style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textPrimary),
//                   ),
//                   const SizedBox(height: 6),
//                   Row(
//                     children: [
//                       const Icon(Icons.star_rounded, color: Colors.amber, size: 16),
//                       const SizedBox(width: 4),
//                       Text(
//                         '${restaurant.rating}',
//                         style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
//                       ),
//                       Text(
//                         ' (${restaurant.reviewCount})',
//                         style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 4),
//                   Row(
//                     children: [
//                       const Icon(Icons.location_on, color: AppColors.primary, size: 14),
//                       const SizedBox(width: 4),
//                       Expanded(
//                         child: Text(
//                           '${restaurant.distance} km • ${restaurant.address}',
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                           style: const TextStyle(color: AppColors.textSecondary, fontSize: 11),
//                         ),
//                       ),
//                     ],
//                   )
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../domain/entities/restaurant_entity.dart';

class RestaurantCard extends StatelessWidget {
  final RestaurantEntity restaurant;
  final bool isSaved;
  final VoidCallback onTap;
  final VoidCallback onBookmarkToggle;

  const RestaurantCard({
    Key? key,
    required this.restaurant,
    required this.isSaved,
    required this.onTap,
    required this.onBookmarkToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ Thay Expanded → AspectRatio để height luôn được xác định
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Stack(
                children: [
                  // ✅ Thêm ClipRRect để bo góc ảnh đúng cách
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    child: restaurant.image.isNotEmpty
                        ? Image.network(
                      restaurant.image,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      // ✅ Xử lý lỗi load ảnh
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.restaurant, color: Colors.grey, size: 40),
                      ),
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          color: Colors.grey.shade100,
                          child: const Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        );
                      },
                    )
                    // ✅ Fallback khi image rỗng
                        : Container(
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.restaurant, color: Colors.grey, size: 40),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: onBookmarkToggle,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isSaved ? Icons.favorite : Icons.favorite_border,
                          color: isSaved ? Colors.red : Colors.grey,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Thông tin Quán
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    restaurant.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '${restaurant.rating}',
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                      ),
                      Text(
                        ' (${restaurant.reviewCount})',
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: AppColors.primary, size: 14),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '${restaurant.distance} km • ${restaurant.address}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: AppColors.textSecondary, fontSize: 11),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}