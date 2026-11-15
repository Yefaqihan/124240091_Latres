import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Local database untuk menyimpan data user (register & login).
/// Menggunakan Hive sebagai local database NoSQL.
/// Box 'users' menyimpan key = username, value = Map berisi password.
class AuthService {
  static const String usersBoxName = 'users';

  /// Membuka box Hive. Dipanggil sekali di main() sebelum runApp.
  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(usersBoxName);
  }

  /// Register user baru. Return false jika username sudah dipakai.
  static Future<bool> register(String username, String password) async {
    final Box box = Hive.box(usersBoxName);
    if (box.get(username) != null) {
      return false; // username sudah terdaftar
    }
    await box.put(username, {'username': username, 'password': password});
    return true;
  }

  /// Login: cek apakah username ada dan password cocok.
  static Future<bool> login(String username, String password) async {
    final Box box = Hive.box(usersBoxName);
    final dynamic user = box.get(username);
    if (user == null) return false;
    return user['password'] == password;
  }
}
