import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/character.dart';

/// Menyimpan daftar favorit menggunakan Shared Preferences
/// agar data tidak hilang ketika aplikasi ditutup.
/// Key dibuat per-user: 'favorites_<username>'.
class FavoriteService {
  static String _key(String username) => 'favorites_$username';

  /// Mengambil semua karakter favorit milik user.
  static Future<List<Character>> getFavorites(String username) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? raw = prefs.getString(_key(username));
    if (raw == null) return [];
    final List decoded = json.decode(raw) as List;
    return decoded
        .map((item) => Character.fromMap(Map<String, dynamic>.from(item)))
        .toList();
  }

  /// Menyimpan seluruh daftar favorit user (dipanggil setiap ada perubahan).
  static Future<void> saveFavorites(
      String username, List<Character> favorites) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String raw = json.encode(
      favorites.map((c) => c.toMap()).toList(),
    );
    await prefs.setString(_key(username), raw);
  }
}
