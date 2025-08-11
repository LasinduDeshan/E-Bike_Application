import 'package:flutter/material.dart';

/// Battery card styled to match the provided design: 
/// black rounded card, lime icon tile with bolt, and right-aligned percentage.
class BatteryDetailsWidget extends StatelessWidget {
  final int batteryLevel;
  final double height;
  final double width;

  const BatteryDetailsWidget({
    Key? key,
    required this.batteryLevel,
    this.height = 120,
    this.width = double.infinity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // White pill with lime inner and bolt
            Container(
              width: 52,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Center(
                child: Container(
                  width: 34,
                  height: 64,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD4FF3F),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.flash_on,
                      color: Colors.black,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            // Text block aligned like reference: title, subtitle, value below
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Battery',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Level',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '$batteryLevel%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
