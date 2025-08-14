import 'package:flutter/material.dart';

/// Centralized color configuration for bike markers/indicators on maps.
///
/// Update the colors below to change marker icon and border colors
/// across the app in one place.
class BikeMarkerColors {
  /// Color for bikes with high battery level
  static const Color highBatteryColor = Color(0xFFD4FF3F); // lime

  /// Color for bikes with medium battery level
  static const Color mediumBatteryColor = Color(0xFFFF9800); // orange

  /// Color for bikes with low battery level
  static const Color lowBatteryColor = Color(0xFFF44336); // red

  /// Returns a color based on battery percentage thresholds.
  static Color colorForBattery(int batteryPercentage) {
    if (batteryPercentage >= 70) return highBatteryColor;
    if (batteryPercentage >= 40) return mediumBatteryColor;
    return lowBatteryColor;
  }
}


