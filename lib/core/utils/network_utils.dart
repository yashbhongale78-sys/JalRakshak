// lib/core/utils/network_utils.dart
// Utility for checking internet connectivity status

import 'package:connectivity_plus/connectivity_plus.dart';

/// Checks whether the device has an active internet connection.
class NetworkUtils {
  NetworkUtils._();

  /// Returns true if device is connected to internet (WiFi or Mobile Data).
  static Future<bool> isConnected() async {
    final result = await Connectivity().checkConnectivity();
    return result == ConnectivityResult.wifi ||
        result == ConnectivityResult.mobile ||
        result == ConnectivityResult.ethernet;
  }

  /// Stream of connectivity changes — useful for auto-sync triggers.
  static Stream<ConnectivityResult> get connectivityStream =>
      Connectivity().onConnectivityChanged;
}
