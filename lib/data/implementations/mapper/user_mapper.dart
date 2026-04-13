import '../../dtos/auth/user_dto.dart';
import '../../../domain/entities/user_entity.dart';

class UserMapper {
  static UserEntity? toEntity(UserDto dto) {
    if (dto.uid == null) return null; // Nếu không có UID tức là chưa đăng nhập
    return UserEntity(
      uid: dto.uid!,
      email: dto.email ?? 'no-email@foodie.vn',
      displayName: dto.displayName ?? 'Người dùng',
    );
  }
}