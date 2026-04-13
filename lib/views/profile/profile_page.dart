import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../viewmodels/auth/auth_viewmodel.dart';
import '../auth/login_page.dart';
import '../auth/register_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Lắng nghe trạng thái đăng nhập
    return Consumer<AuthViewModel>(
      builder: (context, authVM, child) {
        final user = authVM.currentUser;

        // --- TRẠNG THÁI 1: CHƯA ĐĂNG NHẬP ---
        if (user == null) {
          return Scaffold(
            backgroundColor: AppColors.background,
            body: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('👤', style: TextStyle(fontSize: 64)),
                    const SizedBox(height: 16),
                    const Text(
                      'Chưa đăng nhập',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Đăng nhập để lưu quán yêu thích và viết đánh giá',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          elevation: 0,
                        ),
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginPage())),
                        child: const Text('Đăng nhập', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: AppColors.gradientStart.withValues(alpha: 0.3), width: 2),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterPage())),
                        child: const Text('Tạo tài khoản', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.primary)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        // --- TRẠNG THÁI 2: ĐÃ ĐĂNG NHẬP ---
        // Giả lập số liệu thống kê
        final stats = [
          {'label': 'Đánh giá', 'value': '12', 'icon': Icons.star_rounded, 'color': AppColors.primary},
          {'label': 'Đã lưu', 'value': '45', 'icon': Icons.favorite_rounded, 'color': Colors.red.shade500},
          {'label': 'Đã xem', 'value': '128', 'icon': Icons.history_rounded, 'color': Colors.purple.shade500},
        ];

        // Danh sách Menu
        final menuItems = [
          {'icon': Icons.edit, 'label': 'Chỉnh sửa hồ sơ', 'color': AppColors.primary},
          {'icon': Icons.bookmark_added, 'label': 'Địa điểm đã lưu', 'color': Colors.red.shade500},
          {'icon': Icons.history, 'label': 'Lịch sử xem', 'color': Colors.purple.shade500},
          {'icon': Icons.star_rounded, 'label': 'Đánh giá của tôi', 'color': Colors.amber.shade600},
          {'icon': Icons.notifications_none, 'label': 'Thông báo', 'color': Colors.lightBlue.shade600},
          {'icon': Icons.settings_outlined, 'label': 'Cài đặt', 'color': Colors.grey.shade600},
          {'icon': Icons.help_outline, 'label': 'Trợ giúp', 'color': Colors.cyan.shade500},
          {'icon': Icons.security, 'label': 'Quyền riêng tư', 'color': Colors.blueGrey.shade500},
        ];

        // Sử dụng UI Avatars API để tạo ảnh PNG an toàn cho Flutter
        final avatarUrl = 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(user.displayName)}&background=0EA5E9&color=fff&size=200';

        return Scaffold(
          backgroundColor: AppColors.background, // Màu nền xám nhạt (như app thực tế)
          body: SingleChildScrollView(
            child: Column(
              children: [
                // 1. Header Gradient & Info
                Container(
                  padding: const EdgeInsets.only(top: 64, bottom: 32, left: 20, right: 20),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.gradientStart, AppColors.gradientEnd],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          // Avatar với nút Edit
                          Stack(
                            children: [
                              Container(
                                width: 80, height: 80,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Colors.white, width: 3),
                                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10)],
                                  image: DecorationImage(image: NetworkImage(avatarUrl), fit: BoxFit.cover),
                                ),
                              ),
                              Positioned(
                                bottom: -2, right: -2,
                                child: Container(
                                  width: 28, height: 28,
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade700,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 2),
                                  ),
                                  child: const Icon(Icons.edit, size: 14, color: Colors.white),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(width: 16),

                          // Thông tin User
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(user.displayName, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                                Text(user.email, style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 13)),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)),
                                  child: const Text('🥇 Thực khách tích cực', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
                                )
                              ],
                            ),
                          )
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Hàng Thống kê (Stats)
                      Row(
                        children: stats.map((stat) => Expanded(
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              children: [
                                Text(stat['value'].toString(), style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 2),
                                Text(stat['label'].toString(), style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 11)),
                              ],
                            ),
                          ),
                        )).toList(),
                      ),
                    ],
                  ),
                ),

                // 2. Menu Items
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10)],
                    ),
                    child: Column(
                      children: menuItems.asMap().entries.map((entry) {
                        final index = entry.key;
                        final item = entry.value;
                        final iconColor = item['color'] as Color;

                        return Column(
                          children: [
                            ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                              leading: Container(
                                width: 36, height: 36,
                                decoration: BoxDecoration(
                                  color: iconColor.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(item['icon'] as IconData, size: 20, color: iconColor),
                              ),
                              title: Text(item['label'].toString(), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                              trailing: const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
                              onTap: () {
                                // Xử lý điều hướng sau này
                              },
                            ),
                            if (index < menuItems.length - 1)
                              Padding(
                                padding: const EdgeInsets.only(left: 60),
                                child: Divider(height: 1, color: Colors.grey.shade100),
                              )
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),

                // 3. Logout Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade50,
                        foregroundColor: Colors.red.shade500,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(color: Colors.red.shade200),
                        ),
                      ),
                      icon: const Icon(Icons.logout, size: 20),
                      label: const Text('Đăng xuất', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                      onPressed: () async {
                        // 1. Thực hiện đăng xuất khỏi Firebase
                        //await authVM.logout();

                        // 2. Kiểm tra widget còn tồn tại không (chuẩn Flutter sau khi dùng await)
                        if (context.mounted) {
                          // 3. Đẩy thẳng ra màn hình Login và xóa sạch lịch sử màn hình trước đó
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const LoginPage()),
                                (
                                route) => false, // false nghĩa là xóa hết các trang cũ đi
                          );
                        }
                      }
                    ),
                  ),
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24.0),
                  child: Text('FoodieVN v2.1.0', style: TextStyle(color: Colors.grey, fontSize: 12)),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}