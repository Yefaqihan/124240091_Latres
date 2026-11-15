import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/favorite_controller.dart';
import 'detail_page.dart';

/// Favorite Screen (soal 4): daftar karakter yang difavoritkan.
/// - Data disimpan di Shared Preferences 
/// - Hapus favorit dengan swipe
/// - Snackbar setelah berhasil dihapus 
/// - Pesan jika daftar kosong
class FavoritesTab extends StatelessWidget {
  const FavoritesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final FavoriteController controller = Get.find<FavoriteController>();

    return Container(
      color: const Color(0xFF2D2D44),
      child: Obx(() {
        // Pesan apabila daftar favorite masih kosong.
        if (controller.favorites.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.favorite_border, size: 72, color: Colors.white24),
                SizedBox(height: 12),
                Text(
                  'Belum ada karakter favorit',
                  style: TextStyle(color: Colors.white54, fontSize: 16),
                ),
                SizedBox(height: 4),
                Text(
                  'Tambahkan favorit dari tab Characters',
                  style: TextStyle(color: Colors.white38, fontSize: 13),
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(12),
          itemCount: controller.favorites.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final character = controller.favorites[index];

            // Swipe (horizontal) untuk menghapus favorit.
            return Dismissible(
              key: ValueKey(character.id),
              direction: DismissDirection.endToStart,
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20),
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.delete, color: Colors.white, size: 28),
              ),
              onDismissed: (_) async {
                await controller.removeFavorite(character.id);
                // Snackbar setelah karakter berhasil dihapus.
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content:
                        Text('${character.name} dihapus dari favorit'),
                    backgroundColor: Colors.redAccent,
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
              child: Card(
                color: const Color(0xFF1E1E2C),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  onTap: () => Get.to(
                    () => DetailPage(character: character),
                  ),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      character.image,
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 56,
                        height: 56,
                        color: Colors.grey,
                        child: const Icon(Icons.person),
                      ),
                    ),
                  ),
                  title: Text(
                    character.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    '${character.status} • ${character.species}',
                    style: const TextStyle(color: Colors.white54),
                  ),
                  trailing: const Icon(Icons.favorite, color: Colors.red),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
