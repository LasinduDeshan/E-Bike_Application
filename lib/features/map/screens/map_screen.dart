import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
// import '../../../data/models/bike.dart';

// Mock Bike model for demonstration
enum BikeStatus { available, busy, maintenance }

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

  Bike({
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
}

/// Google Maps Style Map Screen
class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
  final MapController _mapController = MapController();
  Bike? _selectedBike;
  late AnimationController _slideController;
  late AnimationController _pulseController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _pulseAnimation;
  String _selectedFilter = 'All';
  String _mapStyle = 'default';
  bool _showTraffic = false;

  // Mock data - replace with your actual data source
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
    Bike(
      id: 'bike_004',
      bikeNumber: '#EB123459',
      lat: 6.9320,
      lon: 79.8590,
      battery: 35,
      temperature: 48,
      speed: 0,
      status: BikeStatus.available,
      lastUpdated: DateTime.now(),
    ),
    Bike(
      id: 'bike_005',
      bikeNumber: '#EB123460',
      lat: 6.9280,
      lon: 79.8640,
      battery: 90,
      temperature: 46,
      speed: 0,
      status: BikeStatus.available,
      lastUpdated: DateTime.now(),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: const Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _slideController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildMap(),
          _buildGoogleStyleSearchBar(),
          _buildMapControls(),
          _buildFloatingActionButton(),
          if (_selectedBike != null) _buildGoogleStyleBottomSheet(),
        ],
      ),
    );
  }

  Widget _buildMap() {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        center: LatLng(6.9271, 79.8612),
        zoom: 15.0,
        minZoom: 3.0,
        maxZoom: 18.0,
        onTap: (_, __) => _hideBikeDetails(),
      ),
      children: [
        TileLayer(
          urlTemplate: _getMapTileUrl(),
          subdomains: const ['a', 'b', 'c'],
          userAgentPackageName: 'com.example.bike_app',
        ),
        MarkerLayer(
          markers: _buildGoogleStyleMarkers(),
        ),
      ],
    );
  }

  String _getMapTileUrl() {
    switch (_mapStyle) {
      case 'satellite':
        return "https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}";
      case 'terrain':
        return "https://{s}.tile.opentopomap.org/{z}/{x}/{y}.png";
      default:
        return "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png";
    }
  }

  Widget _buildGoogleStyleSearchBar() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 10,
      left: 16,
      right: 16,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(Icons.menu, color: Colors.black54),
            ),
            const Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search for e-bikes',
                  hintStyle: TextStyle(color: Colors.black54),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            _buildFilterMenu(),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterMenu() {
    return PopupMenuButton<String>(
      onSelected: (value) => setState(() => _selectedFilter = value),
      child: Container(
        padding: const EdgeInsets.all(12),
        child: const Icon(Icons.filter_list, color: Colors.black54),
      ),
      itemBuilder: (context) => [
        const PopupMenuItem(value: 'All', child: Text('All Bikes')),
        const PopupMenuItem(value: 'High', child: Text('High Battery (>70%)')),
        const PopupMenuItem(value: 'Medium', child: Text('Medium Battery (40-70%)')),
        const PopupMenuItem(value: 'Low', child: Text('Low Battery (<40%)')),
      ],
    );
  }

  Widget _buildMapControls() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 70,
      right: 16,
      child: Column(
        children: [
          _buildMapStyleButton(),
          const SizedBox(height: 8),
          _buildLayersButton(),
          const SizedBox(height: 16),
          _buildZoomControls(),
        ],
      ),
    );
  }

  Widget _buildMapStyleButton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: PopupMenuButton<String>(
        onSelected: (value) => setState(() => _mapStyle = value),
        child: Container(
          padding: const EdgeInsets.all(12),
          child: const Icon(Icons.layers, color: Colors.black54, size: 20),
        ),
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 'default',
            child: Row(
              children: [
                Icon(Icons.map, color: _mapStyle == 'default' ? Colors.black : Colors.grey),
                const SizedBox(width: 8),
                const Text('Default'),
              ],
            ),
          ),
          PopupMenuItem(
            value: 'satellite',
            child: Row(
              children: [
                Icon(Icons.satellite, color: _mapStyle == 'satellite' ? Colors.black : Colors.grey),
                const SizedBox(width: 8),
                const Text('Satellite'),
              ],
            ),
          ),
          PopupMenuItem(
            value: 'terrain',
            child: Row(
              children: [
                Icon(Icons.terrain, color: _mapStyle == 'terrain' ? Colors.black : Colors.grey),
                const SizedBox(width: 8),
                const Text('Terrain'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLayersButton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: PopupMenuButton<String>(
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Icon(
            Icons.more_horiz,
            color: Colors.black54,
            size: 20,
          ),
        ),
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 'traffic',
            child: Row(
              children: [
                Icon(
                  _showTraffic ? Icons.check_box : Icons.check_box_outline_blank,
                  color: _showTraffic ? Colors.black : Colors.grey,
                ),
                const SizedBox(width: 8),
                const Text('Show Traffic'),
              ],
            ),
          ),
        ],
        onSelected: (value) {
          if (value == 'traffic') {
            setState(() => _showTraffic = !_showTraffic);
          }
        },
      ),
    );
  }

  Widget _buildZoomControls() {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(6),
              topRight: Radius.circular(6),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: InkWell(
            onTap: () => _mapController.move(_mapController.center, _mapController.zoom + 1),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(6),
              topRight: Radius.circular(6),
            ),
            child: Container(
              padding: const EdgeInsets.all(12),
              child: const Icon(Icons.add, color: Colors.black54, size: 20),
            ),
          ),
        ),
        Container(
          width: 44,
          height: 1,
          color: Colors.grey[300],
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(6),
              bottomRight: Radius.circular(6),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: InkWell(
            onTap: () => _mapController.move(_mapController.center, _mapController.zoom - 1),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(6),
              bottomRight: Radius.circular(6),
            ),
            child: Container(
              padding: const EdgeInsets.all(12),
              child: const Icon(Icons.remove, color: Colors.black54, size: 20),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFloatingActionButton() {
    return Positioned(
      bottom: _selectedBike != null ? 320 : 100,
      right: 16,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: _centerOnUserLocation,
          backgroundColor: Colors.white,
          elevation: 0,
          child: const Icon(Icons.my_location, color: Colors.black),
        ),
      ),
    );
  }

  List<Marker> _buildGoogleStyleMarkers() {
    return _getFilteredBikes().map((bike) {
      return Marker(
        width: 40.0,
        height: 40.0,
        point: LatLng(bike.lat, bike.lon),
        child: AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _selectedBike?.id == bike.id ? _pulseAnimation.value : 1.0,
              child: GestureDetector(
                onTap: () => _showBikeDetails(bike),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                    border: Border.all(
                      color: _getBatteryColor(bike.battery),
                      width: 3,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Icon(
                      Icons.pedal_bike,
                      color: _getBatteryColor(bike.battery),
                      size: 20,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      );
    }).toList();
  }

  List<Bike> _getFilteredBikes() {
    switch (_selectedFilter) {
      case 'High':
        return _availableBikes.where((bike) => bike.battery >= 70).toList();
      case 'Medium':
        return _availableBikes.where((bike) => bike.battery >= 40 && bike.battery < 70).toList();
      case 'Low':
        return _availableBikes.where((bike) => bike.battery < 40).toList();
      default:
        return _availableBikes;
    }
  }

  void _showBikeDetails(Bike bike) {
    setState(() {
      _selectedBike = bike;
    });
    _slideController.forward();
  }

  void _hideBikeDetails() {
    _slideController.reverse();
    setState(() {
      _selectedBike = null;
    });
  }

  Widget _buildGoogleStyleBottomSheet() {
    if (_selectedBike == null) return const SizedBox.shrink();

    return SlideTransition(
      position: _slideAnimation,
      child: Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
              bottomLeft: Radius.circular(32),
              bottomRight: Radius.circular(32),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 16,
                offset: Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 8),
                width: 32,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[600],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 56, 16, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: _getBatteryColor(_selectedBike!.battery).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.pedal_bike,
                            color: _getBatteryColor(_selectedBike!.battery),
                            size: 24,
                          ),
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
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'Available • ${_selectedBike!.battery}% battery',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[300],
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: _hideBikeDetails,
                          icon: const Icon(Icons.close, color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Stats
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatItem(
                            icon: Icons.battery_full,
                            label: 'Battery',
                            value: '${_selectedBike!.battery}%',
                            color: _getBatteryColor(_selectedBike!.battery),
                          ),
                        ),
                        Expanded(
                          child: _buildStatItem(
                            icon: Icons.thermostat,
                            label: 'Temperature',
                            value: '${_selectedBike!.temperature}°C',
                            color: Colors.orange,
                          ),
                        ),
                        Expanded(
                          child: _buildStatItem(
                            icon: Icons.speed,
                            label: 'Speed',
                            value: '${_selectedBike!.speed}km/h',
                            color: const Color.fromARGB(255, 32, 106, 226),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    
                    // Actions
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _getDirections(_selectedBike!),
                            icon: const Icon(Icons.directions),
                            label: const Text('Directions'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              side: const BorderSide(color: Color.fromARGB(255, 255, 255, 255)),
                              foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _allocateBike(_selectedBike!),
                            icon: const Icon(Icons.lock_open),
                            label: const Text('Unlock'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[300],
          ),
        ),
      ],
    );
  }

  Color _getBatteryColor(int battery) {
    if (battery >= 70) return const Color(0xFFD4FF3F);
    if (battery >= 40) return const Color(0xFFFF9800);
    return const Color(0xFFF44336);
  }

  void _centerOnUserLocation() {
    _mapController.move(LatLng(6.9271, 79.8612), 16.0);
  }

  void _getDirections(Bike bike) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('🗺️ Opening directions...'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _allocateBike(Bike bike) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.lock_open,
                color: Colors.black,
                size: 32,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Unlock E-Bike',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Ready to unlock ${bike.bikeNumber}?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _hideBikeDetails();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('🚲 ${bike.bikeNumber} unlocked! Enjoy your ride!'),
                          backgroundColor: const Color(0xFFD4FF3F),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Unlock'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}