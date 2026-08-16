import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchHistory {
  static Future<void> addSearch(String term) async {
    final token = await const FlutterSecureStorage().read(key: "token");
    if (token == null) return;
    final String key = 'recent_searches$token';

    final prefs = await SharedPreferences.getInstance();
    List<String> searches = prefs.getStringList(key) ?? [];

    searches.remove(term);
    searches.insert(0, term);

    if (searches.length > 10) {
      searches = searches.sublist(0, 10);
    }

    await prefs.setStringList(key, searches);
  }

  static Future<void> removeItem(String term) async {
    final token = await const FlutterSecureStorage().read(key: "token");
    if (token == null) return;
    final String key = 'recent_searches$token';

    final prefs = await SharedPreferences.getInstance();
    List<String> searches = prefs.getStringList(key) ?? [];

    searches.remove(term);

    await prefs.setStringList(key, searches);
  }

  static Future<List<String>> getSearches() async {
    final token = await const FlutterSecureStorage().read(key: "token");
    if (token == null) return [];
    final String key = 'recent_searches$token';
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(key) ?? [];
  }

  static Future<void> clear() async {
    final token = await const FlutterSecureStorage().read(key: "token");
    if (token == null) return;
    final String key = 'recent_searches$token';
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
}
