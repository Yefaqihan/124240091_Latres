import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/episode_controller.dart';

/// Halaman Episode: list episode berisi nama dan air_date.
class EpisodesTab extends StatelessWidget {
  const EpisodesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final EpisodeController controller = Get.put(EpisodeController());

    return Container(
      color: const Color(0xFF2D2D44),
      child: Obx(() {
        // Loading state.
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF97CE4C)),
          );
        }

        // Error handling ketika API gagal diakses.
        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.cloud_off, size: 64, color: Colors.redAccent),
                  const SizedBox(height: 16),
                  Text(
                    controller.errorMessage.value,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: controller.fetchEpisodes,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Coba Lagi'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF97CE4C),
                      foregroundColor: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // List episode (nama, air_date).
        return ListView.separated(
          padding: const EdgeInsets.all(12),
          itemCount: controller.episodes.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final episode = controller.episodes[index];
            return Card(
              color: const Color(0xFF1E1E2C),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: const Color(0xFF97CE4C),
                  child: Text(
                    'EP${episode.id}',
                    style: const TextStyle(
                        fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
                title: Text(
                  episode.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  episode.airDate,
                  style: const TextStyle(color: Colors.white54),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
