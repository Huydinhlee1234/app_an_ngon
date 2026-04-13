import 'package:flutter/material.dart';
import '../../domain/entities/user_entity.dart';
import '../../interfaces/repositories/iauth_repository.dart';

class AuthViewModel extends ChangeNotifier {
  final IAuthRepository _authRepository;

  UserEntity? currentUser;
  bool isLoading = false;
  String? errorMessage;

  AuthViewModel(this._authRepository) {
    checkCurrentUser();
  }

  Future<void> checkCurrentUser() async {
    currentUser = await _authRepository.getCurrentUser();
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      currentUser = await _authRepository.loginWithEmail(email, password);
      return true;
    } catch (e) {
      errorMessage = 'Email hoặc mật khẩu không đúng!';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> register(String name, String email, String password) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      currentUser = await _authRepository.registerWithEmail(name, email, password);
      return true;
    } catch (e) {
      errorMessage = 'Đăng ký thất bại. Email có thể đã tồn tại!';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> loginGoogle() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      currentUser = await _authRepository.loginWithGoogle();
      return currentUser != null;
    } catch (e) {
      errorMessage = 'Không thể kết nối với tài khoản Google.';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _authRepository.logout();
    currentUser = null;
    notifyListeners();
  }
}