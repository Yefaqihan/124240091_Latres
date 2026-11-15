import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/favorite_controller.dart';
import '../models/character.dart';

/// Detail Screen: foto, nama, status, spesies, gender, origin,
/// location + tombol favorite dengan Snackbar dan icon yang berubah.
class DetailPage extends StatefulWidget {
  final Character character;

  const DetailPage({super.key, required this.character});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final FavoriteController _favoriteController = Get.find<FavoriteController>();

  @override
  Widget build(BuildContext context) {
    final character = widget.character;

    return Scaffold(
      backgroundColor: const Color(0xFF2D2D44),
      appBar: AppBar(
        title: Text(character.name,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E1E2C),
        foregroundColor: Colors.white,
        actions: [
          // Icon favorite berubah sesuai status favorit karakter.
          Obx(
            () => IconButton(
              icon: Icon(
                _favoriteController.isFavorite(character.id)
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: _favoriteController.isFavorite(character.id)
                    ? Colors.red
                    : Colors.white,
              ),
              onPressed: () async {
                final bool added =
                    await _favoriteController.toggleFavorite(character);
                // Snackbar ketika karakter ditambahkan/dihapus dari favorit.
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(added
                        ? '${character.name} ditambahkan ke favorit'
                        : '${character.name} dihapus dari favorit'),
                    backgroundColor: added ? Colors.green : Colors.redAccent,
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Foto karakter.
            Center(
              child: Hero(
                tag: 'character-${character.id}',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    character.image,
                    height: 220,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 220,
                      width: 220,
                      color: Colors.grey,
                      child: const Icon(Icons.person, size: 80),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                character.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: _statusColor(character.status).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  character.status.toUpperCase(),
                  style: TextStyle(
                    color: _statusColor(character.status),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Info detail karakter: status, spesies, gender, origin, location.
            _buildInfoCard('Status', character.status, Icons.favorite_outline),
            _buildInfoCard('Species', character.species, Icons.pets),
            _buildInfoCard('Gender', character.gender, Icons.transgender),
            _buildInfoCard('Origin', character.origin, Icons.public),
            _buildInfoCard('Location', character.location, Icons.location_on),
            const SizedBox(height: 16),
            // Tombol favorite.
            Obx(
              () => ElevatedButton.icon(
                onPressed: () async {
                  final bool added =
                      await _favoriteController.toggleFavorite(character);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(added
                          ? '${character.name} ditambahkan ke favorit'
                          : '${character.name} dihapus dari favorit'),
                      backgroundColor:
                          added ? Colors.green : Colors.redAccent,
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
                icon: Icon(
                  _favoriteController.isFavorite(character.id)
                      ? Icons.favorite
                      : Icons.favorite_border,
                ),
                label: Text(
                  _favoriteController.isFavorite(character.id)
                      ? 'Hapus dari Favorit'
                      : 'Tambahkan ke Favorit',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _favoriteController.isFavorite(character.id)
                      ? Colors.redAccent
                      : const Color(0xFF97CE4C),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String label, String value, IconData icon) {
    return Card(
      color: const Color(0xFF1E1E2C),
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF97CE4C), size: 22),
            const SizedBox(width: 12),
            SizedBox(
              width: 90,
              child: Text(
                label,
                style: const TextStyle(color: Colors.white54, fontSize: 14),
              ),
            ),
            Expanded(
              child: Text(
                value,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'alive':
        return Colors.green;
      case 'dead':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
