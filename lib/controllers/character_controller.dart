import 'package:get/get.dart';
import '../models/character.dart';
import '../services/api_service.dart';

/// Controller data karakter dari API menggunakan GetX.
/// Menangani: fetching, loading state, error handling, filter status,
/// dan pencarian berdasarkan nama (bonus).
class CharacterController extends GetxController {
  final RxList<Character> characters = <Character>[].obs;
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;

  // Filter status: null/'' = semua, atau 'alive' / 'dead' / 'unknown'
  final RxString statusFilter = ''.obs;

  // Keyword pencarian (bonus)
  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCharacters();
  }

  /// Mengambil daftar karakter dari API sesuai filter & pencarian aktif.
  Future<void> fetchCharacters() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final List<Character> result = await ApiService.fetchCharacters(
        status: statusFilter.value.isEmpty ? null : statusFilter.value,
        name: searchQuery.value.isEmpty ? null : searchQuery.value,
      );
      characters.assignAll(result);
    } catch (e) {
      // Error handling ketika API gagal diakses (tanpa internet, server down, dll.)
      errorMessage.value =
          'Gagal memuat data dari API.\nPeriksa koneksi internet Anda lalu coba lagi.';
      characters.clear();
    } finally {
      isLoading.value = false;
    }
  }

  /// Mengubah filter status lalu memuat ulang data dari API.
  Future<void> setStatusFilter(String status) async {
    statusFilter.value = status;
    await fetchCharacters();
  }

  /// Pencarian karakter berdasarkan nama (bonus). Didebounce sederhana
  /// agar tidak request terus-menerus saat user sedang mengetik.
  Future<void> search(String query) async {
    searchQuery.value = query;
    await fetchCharacters();
  }

  /// Menyegarkan ulang data (dipakai pada error state).
  Future<void> refresh() => fetchCharacters();
}
