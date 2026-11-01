import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/pantry_item.dart';
import '../models/recipe.dart';
import '../data/default_pantry_data.dart';

class StorageService {
  static const String _keyPantryItems = 'minuscal_pantry_items_v1';
  static const String _keyApiKey = 'minuscal_gemini_api_key';
  static const String _keyFavorites = 'minuscal_favorite_recipes_v1';

  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // --- Pantry Items ---
  List<PantryItem> loadPantryItems() {
    final raw = _prefs.getString(_keyPantryItems);
    if (raw == null || raw.isEmpty) {
      return DefaultPantryData.initialPantryItems;
    }
    try {
      final List<dynamic> list = jsonDecode(raw);
      return list.map((item) => PantryItem.fromJson(item as Map<String, dynamic>)).toList();
    } catch (_) {
      return DefaultPantryData.initialPantryItems;
    }
  }

  Future<void> savePantryItems(List<PantryItem> items) async {
    final jsonList = items.map((i) => i.toJson()).toList();
    await _prefs.setString(_keyPantryItems, jsonEncode(jsonList));
  }

  Future<void> resetPantryToDefaults() async {
    await _prefs.remove(_keyPantryItems);
  }

  // --- API Key ---
  String? getApiKey() {
    final key = _prefs.getString(_keyApiKey);
    if (key != null && key.trim().isNotEmpty) {
      return key.trim();
    }
    return null;
  }

  Future<void> saveApiKey(String key) async {
    await _prefs.setString(_keyApiKey, key.trim());
  }

  Future<void> clearApiKey() async {
    await _prefs.remove(_keyApiKey);
  }

  // --- Favorite Recipes ---
  List<Recipe> loadFavorites() {
    final raw = _prefs.getString(_keyFavorites);
    if (raw == null || raw.isEmpty) return [];
    try {
      final List<dynamic> list = jsonDecode(raw);
      return list.map((r) => Recipe.fromJson(r as Map<String, dynamic>)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> toggleFavorite(Recipe recipe) async {
    final favs = loadFavorites();
    final idx = favs.indexWhere((r) => r.id == recipe.id || r.title == recipe.title);
    if (idx >= 0) {
      favs.removeAt(idx);
      recipe.isFavorite = false;
    } else {
      recipe.isFavorite = true;
      favs.insert(0, recipe);
    }
    await _prefs.setString(
      _keyFavorites,
      jsonEncode(favs.map((r) => r.toJson()).toList()),
    );
  }

  bool isFavorite(Recipe recipe) {
    final favs = loadFavorites();
    return favs.any((r) => r.id == recipe.id || r.title == recipe.title);
  }
}
