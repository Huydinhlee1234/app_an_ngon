import 'package:firebase_auth/firebase_auth.dart';

class UserDto {
  final String? uid;
  final String? email;
  final String? displayName;

  UserDto({this.uid, this.email, this.displayName});

  // Chuyển đổi trực tiếp từ đối tượng User của Firebase
  factory UserDto.fromFirebaseUser(User? user) {
    if (user == null) return UserDto();
    return UserDto(
      uid: user.uid,
      email: user.email,
      displayName: user.displayName,
    );
  }
}