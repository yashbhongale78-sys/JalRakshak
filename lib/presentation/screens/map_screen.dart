// lib/presentation/screens/map_screen.dart
// JALARAKSHA Map Screen - Modern Healthcare Design with Flutter Map

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../core/theme/app_theme.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen>
    with TickerProviderStateMixin {
  final MapController _mapController = MapController();
  late AnimationController _bottomSheetController;
  late Animation<double> _bottomSheetAnimation;

  String? _selectedVillage;
  bool _isBottomSheetExpanded = false;

  // Northeast India center coordinates
  static const LatLng _centerNortheast = LatLng(26.2006, 92.9376);

  @override
  void initState() {
    super.initState();
    _bottomSheetController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _bottomSheetAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _bottomSheetController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _bottomSheetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundDark,
        title: const Text(
          'Live Risk Map',
          style: TextStyle(
            color: AppColors.textLight,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
        ),
        elevation: 0,
      ),
      body: Stack(
        children: [
          _buildMap(),
          _buildBottomSheet(),
        ],
      ),
    );
  }

  Widget _buildMap() {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: _centerNortheast,
        initialZoom: 7.0,
        onTap: (tapPosition, point) {
          if (_selectedVillage != null) {
            setState(() {
              _selectedVillage = null;
            });
            _bottomSheetController.reverse();
          }
        },
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.waterborne_detection',
        ),
        MarkerLayer(
          markers: _buildMarkers(),
        ),
      ],
    );
  }

  List<Marker> _buildMarkers() {
    final villages = _getMockVillages();

    return villages.map((village) {
      final riskColor = _getRiskColor(village['riskLevel']);
      final isSelected = _selectedVillage == village['name'];

      return Marker(
        point: LatLng(village['lat'], village['lng']),
        width: isSelected ? 60 : 40,
        height: isSelected ? 60 : 40,
        child: GestureDetector(
          onTap: () => _onMarkerTapped(village),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: riskColor,
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: isSelected ? 3 : 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: riskColor.withValues(alpha: 0.5),
                  blurRadius: isSelected ? 15 : 8,
                  spreadRadius: isSelected ? 3 : 1,
                ),
              ],
            ),
            child: Center(
              child: Text(
                village['reportCount'].toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isSelected ? 14 : 10,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ),
        ),
      );
    }).toList();
  }

  void _onMarkerTapped(Map<String, dynamic> village) {
    if (mounted) {
      setState(() {
        _selectedVillage = village['name'];
      });
      _bottomSheetController.forward();
    }
  }

  Widget _buildBottomSheet() {
    return AnimatedBuilder(
      animation: _bottomSheetAnimation,
      builder: (context, child) {
        return Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Transform.translate(
            offset: Offset(0, (1 - _bottomSheetAnimation.value) * 300),
            child: Container(
              height: 300,
              decoration: BoxDecoration(
                color: AppColors.cardDark.withValues(alpha: 0.95),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: _selectedVillage != null
                  ? _buildVillageDetails()
                  : _buildMapLegend(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildVillageDetails() {
    final village =
        _getMockVillages().firstWhere((v) => v['name'] == _selectedVillage);
    final riskColor = _getRiskColor(village['riskLevel']);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textMuted,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Village name and risk
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      village['name'],
                      style: const TextStyle(
                        color: AppColors.textLight,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      village['district'],
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 14,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: riskColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: riskColor),
                ),
                child: Text(
                  '${village['riskLevel']} RISK',
                  style: TextStyle(
                    color: riskColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Stats
          Row(
            children: [
              _buildStatItem(
                'Total Reports',
                village['reportCount'].toString(),
                Icons.description,
              ),
              _buildStatItem(
                'Last Report',
                village['lastReport'],
                Icons.schedule,
              ),
              _buildStatItem(
                'Population',
                village['population'],
                Icons.people,
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Action button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                // Navigate to village reports
              },
              icon: const Icon(Icons.visibility, size: 18),
              label: const Text(
                'View Reports',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.textLight,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 12,
              fontFamily: 'Poppins',
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMapLegend() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textMuted,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Live Risk Map',
            style: TextStyle(
              color: AppColors.textLight,
              fontSize: 20,
              fontWeight: FontWeight.w700,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 16),
          // Legend
          const Text(
            'Risk Levels',
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 12),
          _buildLegendItem('Low Risk', AppColors.safe, '244 villages'),
          _buildLegendItem('Medium Risk', AppColors.warning, '2 villages'),
          _buildLegendItem('High Risk', AppColors.danger, '1 village'),
          const SizedBox(height: 20),
          // Summary
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.backgroundDark,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline,
                  color: AppColors.primary,
                  size: 20,
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Tap on markers to view village details',
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 12,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color, String count) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textLight,
              fontSize: 14,
              fontFamily: 'Poppins',
            ),
          ),
          const Spacer(),
          Text(
            count,
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 12,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }

  Color _getRiskColor(String riskLevel) {
    switch (riskLevel.toUpperCase()) {
      case 'HIGH':
        return AppColors.danger;
      case 'MEDIUM':
        return AppColors.warning;
      case 'LOW':
      default:
        return AppColors.safe;
    }
  }

  List<Map<String, dynamic>> _getMockVillages() {
    return [
      {
        'name': 'Majuli',
        'district': 'Majuli District',
        'lat': 26.9509,
        'lng': 94.2037,
        'riskLevel': 'HIGH',
        'reportCount': 12,
        'lastReport': '2 hours ago',
        'population': '1.2K',
      },
      {
        'name': 'Jorhat',
        'district': 'Jorhat District',
        'lat': 26.7509,
        'lng': 94.2037,
        'riskLevel': 'MEDIUM',
        'reportCount': 3,
        'lastReport': '1 day ago',
        'population': '2.1K',
      },
      {
        'name': 'Dibrugarh',
        'district': 'Dibrugarh District',
        'lat': 27.4728,
        'lng': 94.9120,
        'riskLevel': 'LOW',
        'reportCount': 0,
        'lastReport': '1 week ago',
        'population': '1.8K',
      },
      {
        'name': 'Tezpur',
        'district': 'Sonitpur District',
        'lat': 26.6335,
        'lng': 92.7983,
        'riskLevel': 'LOW',
        'reportCount': 1,
        'lastReport': '3 days ago',
        'population': '1.5K',
      },
      {
        'name': 'Silchar',
        'district': 'Cachar District',
        'lat': 24.8333,
        'lng': 92.7789,
        'riskLevel': 'MEDIUM',
        'reportCount': 2,
        'lastReport': '6 hours ago',
        'population': '2.3K',
      },
    ];
  }
}
