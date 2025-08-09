import 'package:flutter/material.dart';

/// A card displaying bike image, number, battery, temperature, and speed.
/// [imageUrl], [bikeNumber], [battery], [temperature], [speed] are required.
class BikeInfoCard extends StatelessWidget {
  final String imageUrl;
  final String bikeNumber;
  final int battery;
  final int temperature;
  final int speed;

  const BikeInfoCard({
    Key? key,
    required this.imageUrl,
    required this.bikeNumber,
    required this.battery,
    required this.temperature,
    required this.speed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                imageUrl,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 120,
                  color: Colors.grey[200],
                  child: const Icon(Icons.pedal_bike, size: 60, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              bikeNumber,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _InfoChip(icon: Icons.battery_full, label: '$battery%'),
                _InfoChip(icon: Icons.thermostat, label: '$temperature°C'),
                _InfoChip(icon: Icons.speed, label: '$speed Km/h'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoChip({Key? key, required this.icon, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, size: 18, color: Colors.black),
      label: Text(label, style: const TextStyle(fontSize: 14, color: Colors.black)),
      backgroundColor: Colors.grey[100],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}
