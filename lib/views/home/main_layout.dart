import 'package:flutter/material.dart';
import 'home_page.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({Key? key}) : super(key: key);

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;

  // Danh sách các màn hình tương ứng với từng tab
  final List<Widget> _screens = [
    const HomePage(),
    const Center(child: Text('Màn hình Tìm kiếm')), // Sẽ làm sau
    const Center(child: Text('Màn hình Bản đồ')), // Sẽ làm sau
    const Center(child: Text('Màn hình Đã lưu')), // Sẽ làm sau
    const Center(child: Text('Màn hình Cá nhân')), // Sẽ làm sau
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex], // Chỉ đổi body, giữ nguyên thanh nav
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed, // Cố định các icon không bị nhảy
        selectedItemColor: Colors.lightBlue,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Khám phá'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Tìm kiếm'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Bản đồ'),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: 'Đã lưu'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Cá nhân'),
        ],
      ),
    );
  }
}