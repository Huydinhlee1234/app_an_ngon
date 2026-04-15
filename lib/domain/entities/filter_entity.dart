class FilterEntity {
  final List<String> categories;
  final double maxDistance;
  final List<int> priceRange;
  final double minRating;
  final String sortBy;

  FilterEntity({
    this.categories = const [],

    // 🔴 LỖI Ở ĐÂY: Đổi 50.0 thành 10.0 (hoặc 20.0) để không vượt quá giới hạn của Slider
    this.maxDistance = 10.0,

    this.priceRange = const [1, 4],
    this.minRating = 0.0,
    this.sortBy = 'rating',
  });

  bool get hasActiveFilters =>
      categories.isNotEmpty || maxDistance < 10 || minRating > 0 || priceRange[0] > 1 || priceRange[1] < 4;
}