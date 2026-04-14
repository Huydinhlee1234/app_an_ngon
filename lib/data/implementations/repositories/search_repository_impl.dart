import 'package:shared_preferences/shared_preferences.dart';
import '../../../interfaces/repositories/isearch_repository.dart';

class SearchRepositoryImpl implements ISearchRepository {
  static const String _key = 'RECENT_SEARCHES';

  @override
  Future<List<String>> getRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key) ?? [];
  }

  @override
  Future<void> addRecentSearch(String query) async {
    if (query.trim().isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    List<String> searches = prefs.getStringList(_key) ?? [];
    searches.remove(query);
    searches.insert(0, query);
    if (searches.length > 10) searches = searches.sublist(0, 10);
    await prefs.setStringList(_key, searches);
  }

  @override
  Future<void> clearRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}