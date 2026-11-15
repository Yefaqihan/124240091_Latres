import 'package:get/get.dart';
import '../models/episode.dart';
import '../services/api_service.dart';

/// Controller data episode menggunakan GetX.
class EpisodeController extends GetxController {
  final RxList<Episode> episodes = <Episode>[].obs;
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchEpisodes();
  }

  /// Mengambil daftar episode (nama, air_date) dari API.
  Future<void> fetchEpisodes() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final List<Episode> result = await ApiService.fetchEpisodes();
      episodes.assignAll(result);
    } catch (e) {
      errorMessage.value =
          'Gagal memuat data episode.\nPeriksa koneksi internet Anda lalu coba lagi.';
      episodes.clear();
    } finally {
      isLoading.value = false;
    }
  }
}
