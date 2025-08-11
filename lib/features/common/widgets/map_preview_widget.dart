import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

/// A small rounded map preview widget using OpenStreetMap.
/// [lat] and [lon] are required. If null, shows a placeholder.
class MapPreviewWidget extends StatelessWidget {
  final double? lat;
  final double? lon;
  final double height;
  final double borderRadius;

  const MapPreviewWidget({
    Key? key,
    this.lat,
    this.lon,
    this.height = 80,
    this.borderRadius = 16,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (lat == null || lon == null) {
      return Container(
        height: height,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 111, 111, 111),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: const Center(child: Icon(Icons.map, size: 32, color: Colors.grey)),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: SizedBox(
        height: height,
        child: FlutterMap(
          options: MapOptions(
            center: LatLng(lat!, lon!),
            zoom: 15.0,
            interactiveFlags: InteractiveFlag.none,
          ),
          children: [
            TileLayer(
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: const ['a', 'b', 'c'],
            ),
            MarkerLayer(
              markers: [
                Marker(
                  width: 40.0,
                  height: 40.0,
                  point: LatLng(lat!, lon!),
                  child: const Icon(Icons.pedal_bike, color: Colors.green, size: 32),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
