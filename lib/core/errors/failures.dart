// Định nghĩa một cấu trúc lỗi chung
abstract class Failure {
  final String message;
  Failure(this.message);
}

// Lỗi liên quan đến Máy chủ / Firebase
class ServerFailure extends Failure {
  ServerFailure(String message) : super(message);
}

// Lỗi do người dùng nhập sai (Auth)
class AuthFailure extends Failure {
  AuthFailure(String message) : super(message);
}