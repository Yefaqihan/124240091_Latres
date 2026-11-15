import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'controllers/auth_controller.dart';
import 'controllers/favorite_controller.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/main_shell.dart';
import 'services/auth_service.dart';

void main() async {
  // Memastikan binding Flutter siap sebelum menggunakan plugin
  // (Shared Preferences & Hive butuh ini).
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Hive sebagai local database.
  await AuthService.init();

  // Baca session login dari Shared Preferences.
  // Halaman utama hanya bisa diakses setelah user berhasil login:
  // jika ada session, langsung ke MainShell, jika tidak ke halaman Login.
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? session = prefs.getString('session');

  // Registrasi controller GetX.
  Get.put(AuthController());
  Get.put(FavoriteController());

  runApp(MyApp(loggedIn: session != null && session.isNotEmpty));
}

class MyApp extends StatelessWidget {
  final bool loggedIn;

  const MyApp({super.key, required this.loggedIn});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Rick & Morty Character Explorer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF97CE4C),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      // Route management dengan GetX (Modul VIII).
      initialRoute: loggedIn ? '/main' : '/login',
      getPages: [
        GetPage(name: '/login', page: () => const LoginPage()),
        GetPage(name: '/register', page: () => const RegisterPage()),
        GetPage(name: '/main', page: () => const MainShell()),
      ],
    );
  }
}
