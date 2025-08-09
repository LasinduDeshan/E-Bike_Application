/// RideHistory model for storing trip data in the E-Bike Tracking System.
/// Represents a completed ride with distance, duration, and other metrics.
class RideHistory {
  final String id;
  final String userId;
  final String bikeNumber;
  final DateTime startTime;
  final DateTime endTime;
  final double distance; // in kilometers
  final Duration duration;
  final double avgSpeed; // in km/h
  final double maxSpeed; // in km/h
  final List<MapPoint> route; // GPS points during the ride

  const RideHistory({
    required this.id,
    required this.userId,
    required this.bikeNumber,
    required this.startTime,
    required this.endTime,
    required this.distance,
    required this.duration,
    required this.avgSpeed,
    required this.maxSpeed,
    required this.route,
  });

  /// Create a RideHistory from JSON data (Firestore).
  factory RideHistory.fromJson(Map<String, dynamic> json) {
    return RideHistory(
      id: json['id'] as String,
      userId: json['userId'] as String,
      bikeNumber: json['bikeNumber'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      distance: (json['distance'] as num).toDouble(),
      duration: Duration(milliseconds: json['durationMs'] as int),
      avgSpeed: (json['avgSpeed'] as num).toDouble(),
      maxSpeed: (json['maxSpeed'] as num).toDouble(),
      route: (json['route'] as List<dynamic>)
          .map((point) => MapPoint.fromJson(point as Map<String, dynamic>))
          .toList(),
    );
  }

  /// Convert RideHistory to JSON for Firestore storage.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'bikeNumber': bikeNumber,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'distance': distance,
      'durationMs': duration.inMilliseconds,
      'avgSpeed': avgSpeed,
      'maxSpeed': maxSpeed,
      'route': route.map((point) => point.toJson()).toList(),
    };
  }

  /// Create a copy of this RideHistory with updated fields.
  RideHistory copyWith({
    String? id,
    String? userId,
    String? bikeNumber,
    DateTime? startTime,
    DateTime? endTime,
    double? distance,
    Duration? duration,
    double? avgSpeed,
    double? maxSpeed,
    List<MapPoint>? route,
  }) {
    return RideHistory(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      bikeNumber: bikeNumber ?? this.bikeNumber,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      distance: distance ?? this.distance,
      duration: duration ?? this.duration,
      avgSpeed: avgSpeed ?? this.avgSpeed,
      maxSpeed: maxSpeed ?? this.maxSpeed,
      route: route ?? this.route,
    );
  }

  /// Get the formatted date string for display.
  String get formattedDate {
    return '${startTime.day}/${startTime.month}/${startTime.year}';
  }

  /// Get the formatted duration string for display.
  String get formattedDuration {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  @override
  String toString() {
    return 'RideHistory(id: $id, userId: $userId, bikeNumber: $bikeNumber, distance: $distance, duration: $duration, avgSpeed: $avgSpeed)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RideHistory && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// MapPoint model for storing GPS coordinates during a ride.
class MapPoint {
  final double lat;
  final double lon;
  final DateTime timestamp;
  final double speed;

  const MapPoint({
    required this.lat,
    required this.lon,
    required this.timestamp,
    required this.speed,
  });

  /// Create a MapPoint from JSON data.
  factory MapPoint.fromJson(Map<String, dynamic> json) {
    return MapPoint(
      lat: (json['lat'] as num).toDouble(),
      lon: (json['lon'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp'] as String),
      speed: (json['speed'] as num).toDouble(),
    );
  }

  /// Convert MapPoint to JSON.
  Map<String, dynamic> toJson() {
    return {
      'lat': lat,
      'lon': lon,
      'timestamp': timestamp.toIso8601String(),
      'speed': speed,
    };
  }

  @override
  String toString() {
    return 'MapPoint(lat: $lat, lon: $lon, timestamp: $timestamp, speed: $speed)';
  }
}
