class FilterEntity {
  final List<String> categories;
  final double maxDistance;
  final List<int> priceRange;
  final double minRating;
  final String sortBy;

  FilterEntity({
    this.categories = const [],
    this.maxDistance = 50.0, // Mặc định tìm trong 50km
    this.priceRange = const [1, 4], // Mức giá từ $ đến $$$$
    this.minRating = 0.0,
    this.sortBy = 'rating', // 'rating', 'distance', 'popular'
  });

  bool get hasActiveFilters =>
      categories.isNotEmpty || maxDistance < 10 || minRating > 0 || priceRange[0] > 1 || priceRange[1] < 4;
}