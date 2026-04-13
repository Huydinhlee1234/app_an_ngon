import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../interfaces/repositories/iauth_repository.dart';
import '../../dtos/auth/user_dto.dart';
import '../mapper/user_mapper.dart';

class AuthRepositoryImpl implements IAuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Hàm tiện ích để chuyển User Firebase -> DTO -> Entity
  UserEntity? _processFirebaseUser(User? user) {
    final dto = UserDto.fromFirebaseUser(user);
    return UserMapper.toEntity(dto);
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    return _processFirebaseUser(_firebaseAuth.currentUser);
  }

  @override
  Future<UserEntity?> loginWithEmail(String email, String password) async {
    final credential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return _processFirebaseUser(credential.user);
  }

  @override
  Future<UserEntity?> registerWithEmail(String name, String email, String password) async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    // Cập nhật tên hiển thị trên Firebase
    await credential.user?.updateDisplayName(name);
    return _processFirebaseUser(credential.user);
  }

  @override
  Future<UserEntity?> loginWithGoogle() async {
    try {
      // 1. Kích hoạt luồng đăng nhập Google trên điện thoại
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null; // Người dùng hủy bỏ

      // 2. Lấy chi tiết xác thực từ yêu cầu
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // 3. Tạo một thông tin xác thực (Credential) mới cho Firebase
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // 4. Đăng nhập vào Firebase bằng Credential vừa tạo
      final userCredential = await _firebaseAuth.signInWithCredential(credential);

      // 5. Cập nhật Profile lên Firestore nếu cần (Tùy chọn)
      // Bạn có thể dùng db.collection('users').doc(...).set(...) ở đây

      return _processFirebaseUser(userCredential.user);
    } catch (e) {
      throw Exception('Lỗi đăng nhập Google: $e');
    }
  }

  @override
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }
}