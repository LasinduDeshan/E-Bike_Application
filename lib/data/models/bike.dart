/// Bike model for the E-Bike Tracking System.
/// Represents a single e-bike with its location, status, and sensor data.
class Bike {
  final String id;
  final String bikeNumber;
  final double lat;
  final double lon;
  final int battery;
  final int temperature;
  final int speed;
  final BikeStatus status;
  final DateTime lastUpdated;

  const Bike({
    required this.id,
    required this.bikeNumber,
    required this.lat,
    required this.lon,
    required this.battery,
    required this.temperature,
    required this.speed,
    required this.status,
    required this.lastUpdated,
  });

  /// Create a Bike from JSON data (Firebase).
  factory Bike.fromJson(Map<String, dynamic> json) {
    return Bike(
      id: json['id'] as String,
      bikeNumber: json['bikeNumber'] as String,
      lat: (json['lat'] as num).toDouble(),
      lon: (json['lon'] as num).toDouble(),
      battery: json['battery'] as int,
      temperature: json['temperature'] as int,
      speed: json['speed'] as int,
      status: BikeStatus.values.firstWhere(
        (e) => e.toString() == 'BikeStatus.${json['status']}',
        orElse: () => BikeStatus.available,
      ),
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );
  }

  /// Convert Bike to JSON for Firebase storage.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bikeNumber': bikeNumber,
      'lat': lat,
      'lon': lon,
      'battery': battery,
      'temperature': temperature,
      'speed': speed,
      'status': status.toString().split('.').last,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  /// Create a copy of this Bike with updated fields.
  Bike copyWith({
    String? id,
    String? bikeNumber,
    double? lat,
    double? lon,
    int? battery,
    int? temperature,
    int? speed,
    BikeStatus? status,
    DateTime? lastUpdated,
  }) {
    return Bike(
      id: id ?? this.id,
      bikeNumber: bikeNumber ?? this.bikeNumber,
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
      battery: battery ?? this.battery,
      temperature: temperature ?? this.temperature,
      speed: speed ?? this.speed,
      status: status ?? this.status,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  String toString() {
    return 'Bike(id: $id, bikeNumber: $bikeNumber, lat: $lat, lon: $lon, battery: $battery, temperature: $temperature, speed: $speed, status: $status, lastUpdated: $lastUpdated)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Bike && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Status of a bike in the system.
enum BikeStatus {
  available,
  allocated,
  maintenance,
  offline,
}
