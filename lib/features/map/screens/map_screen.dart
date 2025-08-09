import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../data/models/bike.dart';

/// Map Screen for displaying all available bikes on OpenStreetMap.
/// Shows bike markers, allows allocation, and provides real-time updates.
class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  int _currentIndex = 1; // Map tab is active
  final MapController _mapController = MapController();
  Bike? _selectedBike;

  // Mock data - replace with Firebase data
  final List<Bike> _availableBikes = [
    Bike(
      id: 'bike_001',
      bikeNumber: '#EB123456',
      lat: 6.9271,
      lon: 79.8612,
      battery: 72,
      temperature: 49,
      speed: 20,
      status: BikeStatus.available,
      lastUpdated: DateTime.now(),
    ),
    Bike(
      id: 'bike_002',
      bikeNumber: '#EB123457',
      lat: 6.9300,
      lon: 79.8650,
      battery: 85,
      temperature: 45,
      speed: 0,
      status: BikeStatus.available,
      lastUpdated: DateTime.now(),
    ),
    Bike(
      id: 'bike_003',
      bikeNumber: '#EB123458',
      lat: 6.9250,
      lon: 79.8580,
      battery: 60,
      temperature: 52,
      speed: 0,
      status: BikeStatus.available,
      lastUpdated: DateTime.now(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  center: LatLng(6.9271, 79.8612),
                  zoom: 15.0,
                  onTap: (_, __) => _hideBikeDetails(),
                ),
                children: [
                  TileLayer(
                    urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                    subdomains: const ['a', 'b', 'c'],
                  ),
                  MarkerLayer(
                    markers: _buildBikeMarkers(),
                  ),
                ],
              ),
            ),
            if (_selectedBike != null) _buildBikeDetailsSheet(),
          ],
        ),
      ),
      // Bottom navigation is now handled by MainNavigationScreen
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              // TODO: Navigate back or show menu
            },
            icon: const Icon(Icons.arrow_back),
          ),
          const Expanded(
            child: Text(
              'Nearby E-Bikes',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          IconButton(
            onPressed: () {
              // TODO: Show filters or search
            },
            icon: const Icon(Icons.filter_list),
          ),
        ],
      ),
    );
  }

  List<Marker> _buildBikeMarkers() {
    return _availableBikes.map((bike) {
      return Marker(
        width: 50.0,
        height: 50.0,
        point: LatLng(bike.lat, bike.lon),
        child: GestureDetector(
          onTap: () => _showBikeDetails(bike),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFFD4FF3F),
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.pedal_bike,
              color: Color(0xFFD4FF3F),
              size: 30,
            ),
          ),
        ),
      );
    }).toList();
  }

  void _showBikeDetails(Bike bike) {
    setState(() {
      _selectedBike = bike;
    });
  }

  void _hideBikeDetails() {
    setState(() {
      _selectedBike = null;
    });
  }

  Widget _buildBikeDetailsSheet() {
    if (_selectedBike == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD4FF3F),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.pedal_bike, color: Colors.black),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _selectedBike!.bikeNumber,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Available',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: _hideBikeDetails,
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildBikeStat(
                    icon: Icons.battery_full,
                    label: 'Battery',
                    value: '${_selectedBike!.battery}%',
                    color: _getBatteryColor(_selectedBike!.battery),
                  ),
                ),
                Expanded(
                  child: _buildBikeStat(
                    icon: Icons.thermostat,
                    label: 'Temperature',
                    value: '${_selectedBike!.temperature}°C',
                    color: Colors.orange,
                  ),
                ),
                Expanded(
                  child: _buildBikeStat(
                    icon: Icons.speed,
                    label: 'Speed',
                    value: '${_selectedBike!.speed} km/h',
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _allocateBike(_selectedBike!),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD4FF3F),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Allocate Bike',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBikeStat({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Color _getBatteryColor(int battery) {
    if (battery >= 70) return Colors.green;
    if (battery >= 40) return Colors.orange;
    return Colors.red;
  }

  void _allocateBike(Bike bike) {
    // TODO: Implement bike allocation logic
    // This should call Firebase service to update bike status
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Allocate Bike'),
        content: Text('Are you sure you want to allocate ${bike.bikeNumber}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _hideBikeDetails();
              // TODO: Call allocation service
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${bike.bikeNumber} allocated successfully!'),
                  backgroundColor: const Color(0xFFD4FF3F),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD4FF3F),
              foregroundColor: Colors.black,
            ),
            child: const Text('Allocate'),
          ),
        ],
      ),
    );
  }
}

// Bike model is now imported from data/models/bike.dart
