import '../../../domain/entities/category_entity.dart';
import '../../dtos/category/category_dto.dart';

class CategoryMapper {
  // Chuyển đổi DTO sang Entity và xử lý các trường hợp Null
  static CategoryEntity toEntity(CategoryDto dto) {
    return CategoryEntity(
      id: dto.id,
      name: dto.name ?? 'Chưa có tên', // Giá trị mặc định nếu Firebase thiếu name
      icon: dto.icon ?? '🍽️',           // Giá trị mặc định nếu Firebase thiếu icon
      color: dto.color ?? '#E0E0E0',    // Mặc định màu xám nếu Firebase thiếu color
    );
  }
}