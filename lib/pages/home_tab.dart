import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/character_controller.dart';
import '../controllers/favorite_controller.dart';
import '../models/character.dart';
import 'detail_page.dart';

/// Home Screen: daftar karakter dari API (foto, nama, status),
/// tombol favorit, filter berdasarkan status, pencarian nama (bonus),
/// loading state & error handling.
class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final CharacterController _characterController = Get.put(CharacterController());
  final FavoriteController _favoriteController = Get.find<FavoriteController>();

  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF2D2D44),
      child: Column(
        children: [
          // --- Pencarian karakter berdasarkan nama ---
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
            child: TextField(
              controller: _searchCtrl,
              style: const TextStyle(color: Colors.white),
              textInputAction: TextInputAction.search,
              onSubmitted: (value) => _characterController.search(value),
              decoration: InputDecoration(
                hintText: 'Cari karakter berdasarkan nama...',
                hintStyle: const TextStyle(color: Colors.white38),
                prefixIcon: const Icon(Icons.search, color: Colors.white54),
                suffixIcon: _searchCtrl.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.white54),
                        onPressed: () {
                          _searchCtrl.clear();
                          _characterController.search('');
                        },
                      )
                    : null,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.white24),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF97CE4C)),
                ),
                filled: true,
                fillColor: Colors.white10,
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
          // --- Filter status: All / Alive / Dead / Unknown ---
          Container(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
            child: Obx(
              () => Wrap(
                spacing: 8,
                children: [
                  _buildFilterChip('All', ''),
                  _buildFilterChip('Alive', 'alive'),
                  _buildFilterChip('Dead', 'dead'),
                  _buildFilterChip('Unknown', 'unknown'),
                ],
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              final controller = _characterController;

              // --- Loading state ---
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xFF97CE4C)),
                );
              }

              // --- Error handling ketika API gagal diakses ---
              if (controller.errorMessage.value.isNotEmpty) {
                return _buildErrorView(controller);
              }

              if (controller.characters.isEmpty) {
                return const Center(
                  child: Text(
                    'Karakter tidak ditemukan',
                    style: TextStyle(color: Colors.white70),
                  ),
                );
              }

              // --- Daftar karakter ---
              return RefreshIndicator(
                color: const Color(0xFF97CE4C),
                onRefresh: controller.refresh,
                child: ListView.separated(
                  padding: const EdgeInsets.only(bottom: 16),
                  itemCount: controller.characters.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final character = controller.characters[index];
                    return _buildCharacterCard(character);
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final bool selected = _characterController.statusFilter.value == value;
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => _characterController.setStatusFilter(value),
      selectedColor: const Color(0xFF97CE4C),
      checkmarkColor: Colors.black,
      labelStyle: TextStyle(
        color: selected ? Colors.black : Colors.white70,
        fontWeight: selected ? FontWeight.bold : FontWeight.normal,
      ),
      backgroundColor: Colors.white12,
    );
  }

  Widget _buildErrorView(CharacterController controller) {
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
              onPressed: controller.refresh,
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

  Widget _buildCharacterCard(Character character) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Card(
        color: const Color(0xFF1E1E2C),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          // Ketika karakter dipilih, arahkan ke Detail Screen.
          onTap: () => Get.to(() => DetailPage(character: character)),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              character.image,
              width: 56,
              height: 56,
              fit: BoxFit.cover,
              // Error handling jika gambar gagal dimuat.
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
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Row(
            children: [
              // Indikator warna titik sesuai status karakter.
              Icon(
                Icons.circle,
                size: 10,
                color: _statusColor(character.status),
              ),
              const SizedBox(width: 6),
              Text(
                character.status,
                style: TextStyle(
                  color: _statusColor(character.status),
                  fontSize: 13,
                ),
              ),
            ],
          ),
          // Tombol favorit. Icon berubah sesuai status favorit.
          trailing: Obx(
            () => IconButton(
              icon: Icon(
                _favoriteController.isFavorite(character.id)
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: _favoriteController.isFavorite(character.id)
                    ? Colors.red
                    : Colors.white54,
              ),
              onPressed: () async {
                final bool added =
                    await _favoriteController.toggleFavorite(character);
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
