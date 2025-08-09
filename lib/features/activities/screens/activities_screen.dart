import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../../features/common/widgets/stat_card.dart';
import '../../../data/models/ride_history.dart';

/// Activities Screen for displaying ride history, charts, and trip insights.
/// Shows statistics, ride history list, and distance chart over time.
class ActivitiesScreen extends StatefulWidget {
  const ActivitiesScreen({Key? key}) : super(key: key);

  @override
  State<ActivitiesScreen> createState() => _ActivitiesScreenState();
}

class _ActivitiesScreenState extends State<ActivitiesScreen> {
  int _currentIndex = 2; // Activities tab is active

  // Mock data - replace with Firebase data
  final List<RideHistory> _rideHistory = [
    RideHistory(
      id: '1',
      userId: 'user_001',
      bikeNumber: '#EB123456',
      startTime: DateTime.now().subtract(const Duration(days: 1)),
      endTime: DateTime.now().subtract(const Duration(days: 1)).add(const Duration(minutes: 45)),
      distance: 12.5,
      duration: const Duration(minutes: 45),
      avgSpeed: 16.7,
      maxSpeed: 25.0,
      route: [],
    ),
    RideHistory(
      id: '2',
      userId: 'user_001',
      bikeNumber: '#EB123457',
      startTime: DateTime.now().subtract(const Duration(days: 2)),
      endTime: DateTime.now().subtract(const Duration(days: 2)).add(const Duration(minutes: 32)),
      distance: 8.3,
      duration: const Duration(minutes: 32),
      avgSpeed: 15.6,
      maxSpeed: 22.0,
      route: [],
    ),
    RideHistory(
      id: '3',
      userId: 'user_001',
      bikeNumber: '#EB123456',
      startTime: DateTime.now().subtract(const Duration(days: 3)),
      endTime: DateTime.now().subtract(const Duration(days: 3)).add(const Duration(minutes: 58)),
      distance: 15.2,
      duration: const Duration(minutes: 58),
      avgSpeed: 15.7,
      maxSpeed: 28.0,
      route: [],
    ),
    RideHistory(
      id: '4',
      userId: 'user_001',
      bikeNumber: '#EB123458',
      startTime: DateTime.now().subtract(const Duration(days: 4)),
      endTime: DateTime.now().subtract(const Duration(days: 4)).add(const Duration(minutes: 25)),
      distance: 6.8,
      duration: const Duration(minutes: 25),
      avgSpeed: 16.3,
      maxSpeed: 20.0,
      route: [],
    ),
    RideHistory(
      id: '5',
      userId: 'user_001',
      bikeNumber: '#EB123456',
      startTime: DateTime.now().subtract(const Duration(days: 5)),
      endTime: DateTime.now().subtract(const Duration(days: 5)).add(const Duration(minutes: 42)),
      distance: 11.4,
      duration: const Duration(minutes: 42),
      avgSpeed: 16.3,
      maxSpeed: 24.0,
      route: [],
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
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStatsSection(),
                    const SizedBox(height: 24),
                    _buildChartSection(),
                    const SizedBox(height: 24),
                    _buildRideHistorySection(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // Bottom navigation is now handled by MainNavigationScreen
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: const Row(
        children: [
          Expanded(
            child: Text(
              'Activities',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    final totalRides = _rideHistory.length;
    final totalDistance = _rideHistory.fold<double>(
      0, (sum, ride) => sum + ride.distance);
    final avgSpeed = _rideHistory.fold<double>(
      0, (sum, ride) => sum + ride.avgSpeed) / totalRides;

    return Row(
      children: [
        Expanded(
          child: StatCard(
            icon: Icons.pedal_bike,
            value: '$totalRides',
            label: 'Total Rides',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: StatCard(
            icon: Icons.straighten,
            value: '${totalDistance.toStringAsFixed(1)}Km',
            label: 'Total Distance',
            accentColor: const Color(0xFFD4FF3F),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: StatCard(
            icon: Icons.speed,
            value: '${avgSpeed.toStringAsFixed(1)} km/h',
            label: 'Avg Speed',
          ),
        ),
      ],
    );
  }

  Widget _buildChartSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Distance Last 7 Days',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          height: 200,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: LineChart(
            LineChartData(
              gridData: FlGridData(show: false),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        '${value.toInt()}km',
                        style: const TextStyle(fontSize: 10),
                      );
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    getTitlesWidget: (value, meta) {
                      final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                      if (value.toInt() >= 0 && value.toInt() < days.length) {
                        return Text(
                          days[value.toInt()],
                          style: const TextStyle(fontSize: 10),
                        );
                      }
                      return const Text('');
                    },
                  ),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  spots: _getChartData(),
                  isCurved: true,
                  color: const Color(0xFFD4FF3F),
                  barWidth: 3,
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, barData, index) {
                      return FlDotCirclePainter(
                        radius: 4,
                        color: const Color(0xFFD4FF3F),
                        strokeWidth: 2,
                        strokeColor: Colors.white,
                      );
                    },
                  ),
                  belowBarData: BarAreaData(
                    show: true,
                    color: const Color(0xFFD4FF3F).withOpacity(0.1),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<FlSpot> _getChartData() {
    // Mock data for last 7 days
    return [
      const FlSpot(0, 12.5),
      const FlSpot(1, 8.3),
      const FlSpot(2, 15.2),
      const FlSpot(3, 6.8),
      const FlSpot(4, 11.4),
      const FlSpot(5, 9.7),
      const FlSpot(6, 13.1),
    ];
  }

  Widget _buildRideHistorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent Rides',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                // TODO: Navigate to full ride history
              },
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ..._rideHistory.map((ride) => _buildRideHistoryItem(ride)),
      ],
    );
  }

  Widget _buildRideHistoryItem(RideHistory ride) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFD4FF3F),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.pedal_bike,
                color: Colors.black,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ride.bikeNumber,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                                     Text(
                     DateFormat('MMM dd, yyyy').format(ride.startTime),
                     style: TextStyle(
                       fontSize: 14,
                       color: Colors.grey[600],
                     ),
                   ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${ride.distance.toStringAsFixed(1)} km',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${ride.duration.inMinutes} min',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
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

// RideHistory model is now imported from data/models/ride_history.dart
