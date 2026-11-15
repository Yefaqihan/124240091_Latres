/// Model data karakter Rick & Morty.
/// Menerapkan konsep OOP: class sebagai blueprint object dengan
/// constructor, property, dan factory constructor untuk parsing JSON.
class Character {
  final int id;
  final String name;
  final String status;
  final String species;
  final String gender;
  final String origin;
  final String location;
  final String image;

  Character({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.gender,
    required this.origin,
    required this.location,
    required this.image,
  });

  /// Factory constructor: mengubah JSON dari API menjadi object Character.
  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['id'],
      name: json['name'] ?? '',
      status: json['status'] ?? 'Unknown',
      species: json['species'] ?? '',
      gender: json['gender'] ?? '',
      origin: json['origin']?['name'] ?? 'Unknown',
      location: json['location']?['name'] ?? 'Unknown',
      image: json['image'] ?? '',
    );
  }

  /// Untuk menyimpan ke Shared Preferences (favorit) dalam bentuk Map.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'status': status,
      'species': species,
      'gender': gender,
      'origin': origin,
      'location': location,
      'image': image,
    };
  }

  /// Membuat kembali object Character dari Map yang disimpan di Shared Preferences.
  factory Character.fromMap(Map<String, dynamic> map) {
    return Character(
      id: map['id'],
      name: map['name'] ?? '',
      status: map['status'] ?? 'Unknown',
      species: map['species'] ?? '',
      gender: map['gender'] ?? '',
      origin: map['origin'] ?? 'Unknown',
      location: map['location'] ?? 'Unknown',
      image: map['image'] ?? '',
    );
  }
}
