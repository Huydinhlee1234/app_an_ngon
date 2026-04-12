import 'package:flutter/material.dart';
import '../../domain/entities/restaurant_entity.dart';

class RestaurantDetailPage extends StatelessWidget {
  // 1. Khai báo biến để nhận dữ liệu truyền vào
  final RestaurantEntity restaurant;

  // 2. Bắt buộc phải truyền restaurant khi gọi màn hình này
  const RestaurantDetailPage({Key? key, required this.restaurant}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Phần Header hình ảnh tự thu phóng
          SliverAppBar(
            expandedHeight: 250.0,
            pinned: true,
            backgroundColor: Colors.white,
            iconTheme: const IconThemeData(color: Colors.black),
            flexibleSpace: FlexibleSpaceBar(
              // 3. Sử dụng ảnh thực tế từ dữ liệu
              background: Image.network(
                restaurant.imageUrl,
                fit: BoxFit.cover,
                // Hiển thị loading nếu ảnh đang tải (tùy chọn thêm để UX tốt hơn)
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(child: CircularProgressIndicator());
                },
                // Hiển thị icon lỗi nếu link ảnh hỏng
                errorBuilder: (context, error, stackTrace) =>
                const Center(child: Icon(Icons.broken_image, size: 50, color: Colors.grey)),
              ),
            ),
          ),

          // Phần Nội dung chi tiết
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(20.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              transform: Matrix4.translationValues(0.0, -20.0, 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start, // Căn trên cùng để tên dài không bị lệch
                    children: [
                      // Dùng Expanded để nếu tên quán quá dài sẽ tự xuống dòng thay vì báo lỗi vàng đen
                      Expanded(
                        child: Text(
                          restaurant.name,
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 16), // Khoảng cách giữa tên và nút sao
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(color: Colors.amber, borderRadius: BorderRadius.circular(20)),
                        child: Row(
                          children: [
                            const Icon(Icons.star, color: Colors.white, size: 16),
                            const SizedBox(width: 4),
                            // Hiển thị số sao thực tế
                            Text('${restaurant.rating}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start, // Căn trên cùng cho icon và text
                    children: [
                      const Icon(Icons.location_on, color: Colors.grey, size: 18),
                      const SizedBox(width: 8),
                      // Dùng Expanded cho địa chỉ để tự xuống dòng
                      Expanded(
                        child: Text(
                          restaurant.address,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text('Giới thiệu', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  // Hiển thị mô tả thực tế
                  Text(
                    restaurant.description,
                    style: const TextStyle(color: Colors.black87, height: 1.5),
                  ),
                  // Thêm khoảng trống ở dưới cùng để khi cuộn xuống hết cỡ,
                  // chữ không bị cái nút "Chỉ đường" (FloatingActionButton) che mất
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),

      // Nút Chỉ đường trôi nổi
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Viết hàm dùng package url_launcher để mở Google Maps với tọa độ của quán
          print('Mở Google Maps chỉ đường đến: ${restaurant.name}');
        },
        backgroundColor: Colors.lightBlue,
        icon: const Icon(Icons.directions, color: Colors.white),
        label: const Text('Chỉ đường', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}