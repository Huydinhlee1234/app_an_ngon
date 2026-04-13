import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import 'home_page.dart';
import '../profile/profile_page.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({Key? key}) : super(key: key);

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  // Biến lưu trữ tab hiện tại đang được chọn (Mặc định là 0 - Trang chủ)
  int _currentIndex = 0;

  // Danh sách 5 màn hình tương ứng với 5 tab
  final List<Widget> _pages = [
    const HomePage(),                                                 // Tab 0
    const Center(child: Text('Màn hình Tìm kiếm (Đang phát triển)')), // Tab 1
    const Center(child: Text('Màn hình Bản đồ (Đang phát triển)')),   // Tab 2
    const Center(child: Text('Màn hình Đã lưu (Đang phát triển)')),   // Tab 3
    const ProfilePage(),                                              // Tab 4
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      // Sử dụng IndexedStack giúp giữ nguyên trạng thái (không load lại) khi chuyển tab
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),

      // Thanh điều hướng dưới cùng
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, -5),
            )
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed, // Cố định các tab (không bị hiệu ứng trồi sụt)
          backgroundColor: Colors.white,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textSecondary,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          elevation: 0,
          items: const [
            // Tab 0: Trang chủ
            BottomNavigationBarItem(
              icon: Padding(padding: EdgeInsets.only(bottom: 4), child: Icon(Icons.home_outlined)),
              activeIcon: Padding(padding: EdgeInsets.only(bottom: 4), child: Icon(Icons.home)),
              label: 'Trang chủ',
            ),
            // Tab 1: Tìm kiếm / Khám phá
            BottomNavigationBarItem(
              icon: Padding(padding: EdgeInsets.only(bottom: 4), child: Icon(Icons.search)),
              activeIcon: Padding(padding: EdgeInsets.only(bottom: 4), child: Icon(Icons.search_rounded)),
              label: 'Tìm kiếm',
            ),
            // Tab 2: Bản đồ (MỚI THÊM)
            BottomNavigationBarItem(
              icon: Padding(padding: EdgeInsets.only(bottom: 4), child: Icon(Icons.map_outlined)),
              activeIcon: Padding(padding: EdgeInsets.only(bottom: 4), child: Icon(Icons.map)),
              label: 'Bản đồ',
            ),
            // Tab 3: Đã lưu
            BottomNavigationBarItem(
              icon: Padding(padding: EdgeInsets.only(bottom: 4), child: Icon(Icons.bookmark_border)),
              activeIcon: Padding(padding: EdgeInsets.only(bottom: 4), child: Icon(Icons.bookmark)),
              label: 'Đã lưu',
            ),
            // Tab 4: Hồ sơ
            BottomNavigationBarItem(
              icon: Padding(padding: EdgeInsets.only(bottom: 4), child: Icon(Icons.person_outline)),
              activeIcon: Padding(padding: EdgeInsets.only(bottom: 4), child: Icon(Icons.person)),
              label: 'Hồ sơ',
            ),
          ],
        ),
      ),
    );
  }
}