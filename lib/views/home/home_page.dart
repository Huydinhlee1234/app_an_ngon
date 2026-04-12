import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../shared_widgets/restaurant_card.dart';
import 'restaurant_detail_page.dart';
import '../../viewmodels/home/restaurant_viewmodel.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Xin chào, Huy!', style: TextStyle(color: Colors.grey[600], fontSize: 14)),
            const Text('Hôm nay bạn muốn ăn gì?', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thanh tìm kiếm (giữ nguyên)
              Container(
                height: 50,
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)]),
                child: const Row(
                  children: [
                    SizedBox(width: 16),
                    Icon(Icons.search, color: Colors.grey),
                    SizedBox(width: 10),
                    Text('Tìm kiếm phở, bún chả, cafe...', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text('Quán ngon 4-5 sao gần bạn', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),

              // SỬ DỤNG CONSUMER ĐỂ LẮNG NGHE DỮ LIỆU THẬT
              Consumer<RestaurantViewModel>(
                builder: (context, viewModel, child) {
                  // 1. Đang tải dữ liệu
                  if (viewModel.isLoading) {
                    return const Center(child: CircularProgressIndicator(color: Colors.lightBlue));
                  }

                  // 2. Có lỗi xảy ra
                  if (viewModel.errorMessage != null) {
                    return Center(child: Text(viewModel.errorMessage!, style: const TextStyle(color: Colors.red)));
                  }

                  // 3. Không có quán nào
                  if (viewModel.restaurants.isEmpty) {
                    return const Center(child: Text('Không tìm thấy quán ăn nào.'));
                  }

                  // 4. Có dữ liệu -> Vẽ UI
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: viewModel.restaurants.length, // Lấy độ dài thật từ Firebase
                    itemBuilder: (context, index) {
                      final restaurant = viewModel.restaurants[index];

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: RestaurantCard(
                          restaurant: restaurant,
                          isSaved: false, // Sẽ làm tính năng này ở Tuần 3
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RestaurantDetailPage(restaurant: restaurant),
                                )
                            );
                          },
                          onBookmarkToggle: () {},
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}