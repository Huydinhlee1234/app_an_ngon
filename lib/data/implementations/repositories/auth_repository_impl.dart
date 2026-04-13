import 'package:firebase_auth/firebase_auth.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../interfaces/repositories/iauth_repository.dart';
import '../../dtos/auth/user_dto.dart';
import '../mapper/user_mapper.dart';

class AuthRepositoryImpl implements IAuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

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
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }
}