import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/character.dart';
import '../models/episode.dart';

/// Service untuk komunikasi dengan Rick and Morty API (HTTP Request).
/// Semua request menggunakan method GET.
class ApiService {
  static const String baseUrl = 'https://rickandmortyapi.com/api';

  /// Mengambil list karakter. Bisa diberi filter status (alive/dead/unknown)
  /// dan pencarian berdasarkan nama (bonus).
  /// Endpoint: /character  |  /character?status=alive  |  /character?name=morty
  static Future<List<Character>> fetchCharacters({
    String? status,
    String? name,
  }) async {
    // Menyusun query parameter untuk filter & search.
    final Map<String, String> query = {};
    if (status != null && status.toLowerCase() != 'all') {
      query['status'] = status.toLowerCase();
    }
    if (name != null && name.trim().isNotEmpty) {
      query['name'] = name.trim();
    }

    final Uri uri = Uri.parse('$baseUrl/character').replace(queryParameters: query);
    final http.Response response = await http.get(uri).timeout(
          const Duration(seconds: 15),
          onTimeout: () => throw Exception('Koneksi timeout, coba lagi.'),
        );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List results = data['results'];
      // Jika hasil pencarian tidak ada, API tetap 200 dengan results kosong.
      return results.map((json) => Character.fromJson(json)).toList();
    } else if (response.statusCode == 404) {
      // 404 dari API berarti karakter tidak ditemukan (filter/search tanpa hasil).
      return [];
    } else {
      throw Exception('Gagal memuat karakter (kode: ${response.statusCode})');
    }
  }

  /// Mengambil detail satu karakter berdasarkan id.
  /// Endpoint: /character/{id}
  static Future<Character> fetchCharacterDetail(int id) async {
    final http.Response response = await http
        .get(Uri.parse('$baseUrl/character/$id'))
        .timeout(const Duration(seconds: 15));

    if (response.statusCode == 200) {
      return Character.fromJson(json.decode(response.body));
    } else {
      throw Exception('Gagal memuat detail karakter (kode: ${response.statusCode})');
    }
  }

  /// Mengambil list episode.
  /// Endpoint: /episode
  static Future<List<Episode>> fetchEpisodes() async {
    final http.Response response = await http
        .get(Uri.parse('$baseUrl/episode'))
        .timeout(const Duration(seconds: 15));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List results = data['results'];
      return results.map((json) => Episode.fromJson(json)).toList();
    } else {
      throw Exception('Gagal memuat episode (kode: ${response.statusCode})');
    }
  }
}
