abstract class ISearchRepository {
  Future<List<String>> getRecentSearches();
  Future<void> addRecentSearch(String query);
  Future<void> clearRecentSearches();
}