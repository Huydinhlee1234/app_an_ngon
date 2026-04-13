import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'di.dart';
import 'viewmodels/auth/auth_viewmodel.dart';
import 'viewmodels/home/restaurant_viewmodel.dart';
import 'views/auth/login_page.dart';
import 'views/home/main_layout.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setupDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => getIt<AuthViewModel>()),
        ChangeNotifierProvider(create: (_) => getIt<RestaurantViewModel>()),
      ],
      child: MaterialApp(
        title: 'Ăn Ngon 4-5',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.lightBlue,
          scaffoldBackgroundColor: Colors.grey[50],
        ),
        // Sử dụng Consumer để lắng nghe trạng thái đăng nhập
        home: Consumer<AuthViewModel>(
          builder: (context, authVM, child) {
            // Nếu đã lấy được user từ Firebase -> vào MainLayout
            if (authVM.currentUser != null) {
              return const MainLayout();
            }
            // Nếu chưa -> vào LoginPage
            return const LoginPage();
          },
        ),
      ),
    );
  }
}