import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../common/widgets/avatar_widget.dart';
import '../../common/widgets/stat_card.dart';
import '../../common/widgets/bike_info_card.dart';
import '../../common/widgets/map_preview_widget.dart';
import '../../common/widgets/bike_slider_widget.dart';
import '../../common/widgets/battery_details_widget.dart';
import '../../common/widgets/bike_number_card.dart';
import '../../common/widgets/temperature_card.dart';
import '../../common/widgets/speed_card.dart';
import '../../../features/common/widgets/custom_bottom_nav_bar.dart';
import '../../common/widgets/map_preview_widget.dart';

/// Home Screen for the E-Bike Tracking App.
/// Displays user info, assigned bike, stats, and map preview.
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final DateTime _currentTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBikeHeader(),
                    const SizedBox(height: 16),
                    _buildMainBikeCard(),
                    const SizedBox(height: 16),
                    _buildDashboardCards(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Private widget placed inside the State class to avoid top-level declaration errors
  Widget _SpeedAndMapRow({required double height}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // If the available width for this row is small (e.g., in a 2-column layout),
        // stack the two cards vertically to avoid RenderFlex overflow.
        final bool shouldStack = constraints.maxWidth < 300;

        final Widget miniMapCard = SizedBox(
          height: height,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFEDEDED),
              borderRadius: BorderRadius.circular(22),
            ),
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: MapPreviewWidget(
                      lat: 6.9271,
                      lon: 79.8612,
                      height: height,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.double_arrow,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        );

        if (shouldStack) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SpeedCard(
                speedText: '20 Km/h',
                height: height,
              ),
              const SizedBox(height: 12),
              miniMapCard,
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SpeedCard(
                speedText: '20 Km/h',
                height: height,
              ),
            ),
            const SizedBox(width: 12),
            Flexible(child: miniMapCard),
          ],
        );
      },
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // User info section with rounded background
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  AvatarWidget(
                    imageUrl: null, // Use placeholder instead of non-existent URL
                    radius: 20,
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello,',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      const Text(
                        'Andrew Garfield',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Notifications and time
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.notifications,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Color(0xFFD4FF3F),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                DateFormat('EEE dd MMM').format(_currentTime),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                DateFormat('hh:mm a').format(_currentTime),
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBikeHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'E-Bike1',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          '#EB123456',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildDashboardCards() {
    // Layout: two columns. Left column = tall bike card then speed.
    // Right column = battery then temperature.
    const double batteryHeight = 150;
    const double speedHeight = 114;
    const double gap = 12;

    const double bikeTallHeight = batteryHeight + speedHeight + gap;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left column
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const BikeNumberCard(
                bikeNumber: '#EB123456',
                imageAsset: 'assets/images/bike4.png',
                height: bikeTallHeight,
              ),
              const SizedBox(height: gap),
              // Speed card only
              const SpeedCard(
                speedText: '20 Km/h',
                height: speedHeight,
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        // Right column
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const BatteryDetailsWidget(
                batteryLevel: 72,
                height: batteryHeight,
              ),
              const SizedBox(height: gap),
              const TemperatureCard(
                temperatureC: 49,
                height: speedHeight,
              ),
              const SizedBox(height: gap),
              // Move mini map card to the right column, below temperature
              _MiniMapCard(
                height: speedHeight,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMainBikeCard() {
    final bikeSlides = const [
      BikeSlide(
        imageUrl: 'assets/images/bike1.jpg',
        title: 'Conquer Every Trail',
        description:
            'Full-suspension electric mountain bike built for adventure without limits.',
      ),
      BikeSlide(
        imageUrl: 'assets/images/bike2.jpg',
        title: 'Power Meets Freedom',
        description:
            'Effortless riding with a powerful motor and sleek integrated design.',
      ),
      BikeSlide(
        imageUrl: 'assets/images/bike3.jpg',
        title: 'Your Next Ride Awaits',
        description:
            'From city streets to mountain peaks — ride anywhere, anytime.',
      ),
    ];



    return BikeSliderWidget(
      slides: bikeSlides,
      height: 200,
      onSlideChanged: (index) {},
    );
  }

  // Mini map card to be used on the right column below the temperature card
  static const double _miniMapArrowSize = 36;
  static const double _miniMapBorderRadius = 22;
  static const double _miniMapInnerRadius = 14;

  Widget _MiniMapCard({required double height}) {
    return SizedBox(
      height: height,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(_miniMapBorderRadius),
        ),
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(_miniMapInnerRadius),
                child: MapPreviewWidget(
                  lat: 6.9271,
                  lon: 79.8612,
                  height: height,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: _miniMapArrowSize,
              height: _miniMapArrowSize,
              decoration: const BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.double_arrow,
                color: Colors.white,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color backgroundColor,
    required Color textColor,
    Color? accentColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: textColor.withOpacity(0.7),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: accentColor ?? (backgroundColor == Colors.black ? Colors.white : Colors.black),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 16,
                  color: accentColor != null ? Colors.black : 
                         (backgroundColor == Colors.black ? Colors.black : Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: MapPreviewWidget(
                  lat: 6.9271,
                  lon: 79.8612,
                  height: 80,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_forward,
              color: Colors.white,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}