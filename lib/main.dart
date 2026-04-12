import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'di.dart'; // File Dependency Injection của bạn
import 'viewmodels/home/restaurant_viewmodel.dart';
import 'views/home/main_layout.dart';

void main() async {
  // 1. Đảm bảo Flutter đã khởi tạo trước khi gọi Firebase
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Khởi tạo Firebase
  await Firebase.initializeApp();

  // 3. Khởi tạo các Repositories và ViewModels (DI)
  setupDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Cung cấp ViewModel cho toàn bộ app và gọi hàm fetch dữ liệu ngay lập tức
        ChangeNotifierProvider(
          create: (_) => getIt<RestaurantViewModel>()..fetchRestaurants(),
        ),
      ],
      child: MaterialApp(
        title: 'Ăn Ngon 4-5',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.lightBlue,
          scaffoldBackgroundColor: Colors.grey[50],
        ),
        home: const MainLayout(),
      ),
    );
  }
}