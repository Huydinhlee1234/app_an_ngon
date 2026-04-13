import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../domain/entities/restaurant_entity.dart';

class RestaurantDetailPage extends StatelessWidget {
  final RestaurantEntity restaurant;

  const RestaurantDetailPage({Key? key, required this.restaurant}) : super(key: key);

  String getPriceSymbol(int range) {
    return List.generate(range, (index) => '\$').join('');
  }

  @override
  Widget build(BuildContext context) {
    final displayImages = restaurant.images.isNotEmpty ? restaurant.images : [restaurant.image];

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300.0,
            pinned: true,
            backgroundColor: Colors.white,
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              background: PageView.builder(
                itemCount: displayImages.length,
                itemBuilder: (context, index) {
                  return Image.network(
                    displayImages[index],
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.3), shape: BoxShape.circle),
                  child: const Icon(Icons.favorite_border, size: 20),
                ),
                onPressed: () {},
              ),
              const SizedBox(width: 8),
            ],
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.3), shape: BoxShape.circle),
                child: const Icon(Icons.arrow_back_ios_new, size: 18),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(24.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              transform: Matrix4.translationValues(0.0, -32.0, 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          restaurant.name,
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(12)),
                        child: Row(
                          children: [
                            const Icon(Icons.star, color: Colors.white, size: 16),
                            const SizedBox(width: 4),
                            Text('${restaurant.rating}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 8),

                  Row(
                    children: [
                      Text(restaurant.cuisine, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600)),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text('•', style: TextStyle(color: Colors.grey)),
                      ),
                      Text(getPriceSymbol(restaurant.priceRange), style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text('•', style: TextStyle(color: Colors.grey)),
                      ),
                      Text('${restaurant.reviewCount} đánh giá', style: const TextStyle(color: AppColors.textSecondary)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Divider(color: Color(0xFFEEEEEE)),
                  const SizedBox(height: 16),

                  _buildInfoRow(Icons.location_on, AppColors.primary, '${restaurant.distance} km • ${restaurant.address}'),
                  const SizedBox(height: 16),
                  _buildInfoRow(Icons.access_time_filled, Colors.orange, restaurant.hours, subtitle: restaurant.isOpen ? 'Đang mở cửa' : 'Đóng cửa'),

                  const SizedBox(height: 24),
                  const Text('Giới thiệu', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                  const SizedBox(height: 12),
                  Text(
                    restaurant.description,
                    style: const TextStyle(height: 1.5, color: AppColors.textSecondary, fontSize: 14),
                  ),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -5))],
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          onPressed: () {},
          child: const Text('Xem Đường Đi', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, Color iconColor, String title, {String? subtitle}) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: iconColor.withValues(alpha: 0.1), shape: BoxShape.circle),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 14, color: AppColors.textPrimary, fontWeight: FontWeight.w500)),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(subtitle, style: TextStyle(fontSize: 12, color: subtitle == 'Đang mở cửa' ? Colors.green : Colors.red, fontWeight: FontWeight.bold)),
              ]
            ],
          ),
        )
      ],
    );
  }
}