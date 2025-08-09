import 'package:flutter/material.dart';

class BatteryDetailsWidget extends StatelessWidget {
  final int batteryLevel;
  final double height;
  final double width;

  const BatteryDetailsWidget({
    Key? key,
    required this.batteryLevel,
    this.height = 120,
    this.width = 80,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Battery icon
            _buildBatteryIcon(),
            const SizedBox(width: 12),
            // Battery text
            Expanded(
              child: _buildBatteryText(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBatteryIcon() {
    return Container(
      width: 32,
      height: 64,
      child: Stack(
        children: [
          // Battery outline
          Container(
            width: 32,
            height: 64,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 2),
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          // Battery fill
          Positioned(
            bottom: 3,
            left: 3,
            right: 3,
            child: Container(
              height: _getBatteryFillHeight(),
              decoration: BoxDecoration(
                color: _getBatteryColor(),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
          // Battery terminal
          Positioned(
            top: 0,
            left: 8,
            child: Container(
              width: 16,
              height: 6,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ),
          // Lightning bolt icon
          if (batteryLevel > 0)
            Center(
              child: Icon(
                Icons.flash_on,
                color: Colors.black,
                size: 18,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBatteryText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Battery',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        const Text(
          'Level',
          style: TextStyle(
            color: Colors.white,
            fontSize: 10,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          '$batteryLevel%',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  double _getBatteryFillHeight() {
    // Calculate fill height based on battery level (0-100%)
    final maxHeight = 58.0; // 64 - 6 (padding)
    return (batteryLevel / 100) * maxHeight;
  }

  Color _getBatteryColor() {
    if (batteryLevel >= 70) return const Color(0xFFD4FF3F); // Lime green
    if (batteryLevel >= 40) return Colors.orange;
    return Colors.red;
  }
}
