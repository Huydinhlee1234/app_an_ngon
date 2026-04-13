import '../../domain/entities/user_entity.dart';

abstract class IAuthRepository {
  Future<UserEntity?> getCurrentUser();
  Future<UserEntity?> loginWithEmail(String email, String password);
  Future<UserEntity?> registerWithEmail(String name, String email, String password);
  Future<void> logout();
}