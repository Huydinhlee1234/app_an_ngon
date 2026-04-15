import 'package:flutter/material.dart';
import '../../domain/entities/filter_entity.dart';
import '../../domain/entities/restaurant_entity.dart';
import '../../domain/entities/category_entity.dart'; // MỚI: Thêm Category Entity
import '../../interfaces/repositories/irestaurant_repository.dart';
import '../../interfaces/repositories/isearch_repository.dart';

class SearchViewModel extends ChangeNotifier {
  final IRestaurantRepository _restaurantRepo;
  final ISearchRepository _searchRepo;

  SearchViewModel(this._restaurantRepo, this._searchRepo) {
    _loadInitialData();
  }

  List<RestaurantEntity> _allRestaurants = [];
  List<RestaurantEntity> searchResults = [];
  List<String> recentSearches = [];

  // MỚI: Danh sách danh mục tải từ Firebase
  List<CategoryEntity> categories = [];

  final List<String> trendingSuggestions = [
    'Phở bò', 'Bún chả', 'Cơm tấm', 'Lẩu hải sản', 'Bánh xèo', 'Gỏi cuốn'
  ];

  String _query = '';
  String get query => _query;

  FilterEntity activeFilter = FilterEntity();

  Future<void> _loadInitialData() async {
    recentSearches = await _searchRepo.getRecentSearches();
    try {
      // MỚI: Tải cả danh mục và quán ăn từ Firebase
      categories = await _restaurantRepo.getCategories();
      _allRestaurants = await _restaurantRepo.getHighRatingRestaurants();
      searchResults = List.from(_allRestaurants);
    } catch (e) {
      debugPrint('Lỗi tải dữ liệu tìm kiếm: $e');
    }
    notifyListeners();
  }

  void setQuery(String q) {
    _query = q;
    _applyFiltersAndSearch();
  }

  Future<void> submitSearch(String q) async {
    if (q.trim().isEmpty) return;
    setQuery(q);
    await _searchRepo.addRecentSearch(q.trim());
    recentSearches = await _searchRepo.getRecentSearches();
    notifyListeners();
  }

  Future<void> clearRecentSearches() async {
    await _searchRepo.clearRecentSearches();
    recentSearches = [];
    notifyListeners();
  }

  void updateFilter(FilterEntity newFilter) {
    activeFilter = newFilter;
    _applyFiltersAndSearch();
  }

  void _applyFiltersAndSearch() {
    if (_query.trim().isEmpty && !activeFilter.hasActiveFilters) {
      searchResults = List.from(_allRestaurants);
      notifyListeners();
      return;
    }

    final q = _query.toLowerCase();

    searchResults = _allRestaurants.where((r) {
      final matchQuery = r.name.toLowerCase().contains(q) ||
          r.cuisine.toLowerCase().contains(q) ||
          r.address.toLowerCase().contains(q) ||
          r.tags.any((tag) => tag.toLowerCase().contains(q));
      if (!matchQuery) return false;

      // Logic lọc theo danh mục, khoảng cách, giá trị vẫn dùng 1-4 như cũ
      if (activeFilter.categories.isNotEmpty && !activeFilter.categories.contains(r.category)) return false;
      if (r.distance > activeFilter.maxDistance) return false;
      if (r.priceRange < activeFilter.priceRange[0] || r.priceRange > activeFilter.priceRange[1]) return false;
      if (r.rating < activeFilter.minRating) return false;

      return true;
    }).toList();

    searchResults.sort((a, b) {
      if (activeFilter.sortBy == 'rating') return b.rating.compareTo(a.rating);
      if (activeFilter.sortBy == 'distance') return a.distance.compareTo(b.distance);
      if (activeFilter.sortBy == 'popular') return b.reviewCount.compareTo(a.reviewCount);
      return 0;
    });

    notifyListeners();
  }
}