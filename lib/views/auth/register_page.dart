import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../viewmodels/auth/auth_viewmodel.dart';
import '../home/main_layout.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _showPass = false;
  bool _agreed = false;
  String _error = '';

  void _handleRegister() async {
    if (_nameController.text.isEmpty || _emailController.text.isEmpty || _passwordController.text.isEmpty) return;
    if (_passwordController.text != _confirmController.text) {
      setState(() => _error = 'Mật khẩu xác nhận không khớp');
      return;
    }

    final authVM = Provider.of<AuthViewModel>(context, listen: false);
    final success = await authVM.register(_nameController.text, _emailController.text, _passwordController.text);

    if (success && mounted) {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const MainLayout()), (route) => false);
    } else {
      setState(() => _error = authVM.errorMessage ?? 'Có lỗi xảy ra');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authVM = Provider.of<AuthViewModel>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 60, bottom: 40, left: 24, right: 24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.gradientStart, AppColors.gradientEnd],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), shape: BoxShape.circle),
                      child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Container(
                        width: 50, height: 50,
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
                        child: const Icon(Icons.restaurant, color: AppColors.primary, size: 24),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Tạo tài khoản', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                          Text('Đăng ký để trải nghiệm ${AppConstants.appName}', style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 12)),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_error.isNotEmpty) ...[
                    Text(_error, style: const TextStyle(color: Colors.red)),
                    const SizedBox(height: 16),
                  ],

                  _buildInputLabel('HỌ VÀ TÊN'),
                  _buildTextField(controller: _nameController, hint: 'Nguyễn Văn An', icon: Icons.person_outline),
                  const SizedBox(height: 16),

                  _buildInputLabel('EMAIL'),
                  _buildTextField(controller: _emailController, hint: 'email@example.com', icon: Icons.mail_outline),
                  const SizedBox(height: 16),

                  _buildInputLabel('MẬT KHẨU'),
                  _buildTextField(controller: _passwordController, hint: 'Tối thiểu 6 ký tự', icon: Icons.lock_outline, isPassword: true),
                  const SizedBox(height: 16),

                  _buildInputLabel('XÁC NHẬN MẬT KHẨU'),
                  _buildTextField(controller: _confirmController, hint: '••••••••', icon: Icons.lock_outline, isPassword: true),
                  const SizedBox(height: 20),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 24, height: 24,
                        child: Checkbox(
                          value: _agreed,
                          activeColor: AppColors.primary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                          onChanged: (val) => setState(() => _agreed = val ?? false),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: RichText(
                          text: const TextSpan(
                              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                              children: [
                                TextSpan(text: 'Tôi đồng ý với '),
                                TextSpan(text: 'Điều khoản dịch vụ', style: TextStyle(color: AppColors.primary)),
                                TextSpan(text: ' và '),
                                TextSpan(text: 'Chính sách bảo mật', style: TextStyle(color: AppColors.primary)),
                              ]
                          ),
                        ),
                      )
                    ],
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
                      onPressed: authVM.isLoading ? null : _handleRegister,
                      child: authVM.isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Tạo tài khoản', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ),

                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Đã có tài khoản? ', style: TextStyle(color: AppColors.textSecondary)),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Text('Đăng nhập', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
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

  Widget _buildInputLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(text, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
    );
  }

  Widget _buildTextField({required TextEditingController controller, required String hint, required IconData icon, bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword && !_showPass,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: AppColors.textSecondary, size: 20),
        suffixIcon: isPassword ? IconButton(
          icon: Icon(_showPass ? Icons.visibility_off : Icons.visibility, color: AppColors.textSecondary, size: 20),
          onPressed: () => setState(() => _showPass = !_showPass),
        ) : null,
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
        filled: true,
        fillColor: AppColors.inputBackground,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.primary)),
      ),
    );
  }
}