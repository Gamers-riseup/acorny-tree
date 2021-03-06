import 'dart:convert';

class Soil {
  Soil({
    required this.id,
    required this.soilName,
    required this.soilImage,
  });

  factory Soil.fromMap(Map<String, dynamic> map) {
    return Soil(
      id: map['id'],
      soilName: map['soilName'],
      soilImage: map['soilImage'],
    );
  }

  factory Soil.fromJson(String source) => Soil.fromMap(json.decode(source));

  final String id;
  final String soilName;
  final String soilImage;

  Soil copyWith({
    String? id,
    String? soilName,
    String? soilImage,
  }) {
    return Soil(
      id: id ?? this.id,
      soilName: soilName ?? this.soilName,
      soilImage: soilImage ?? this.soilImage,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'soilName': soilName,
      'soilImage': soilImage,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() =>
      'Soil(id: $id, soilName: $soilName, soilImage: $soilImage)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Soil &&
        other.id == id &&
        other.soilName == soilName &&
        other.soilImage == soilImage;
  }

  @override
  int get hashCode => id.hashCode ^ soilName.hashCode ^ soilImage.hashCode;
}
