// lib/presentation/screens/nearby_clinics_screen.dart
// Shows nearby health clinics on a Google Map with dummy clinic data.

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';

class NearbyClinicsScreen extends StatefulWidget {
  const NearbyClinicsScreen({super.key});

  @override
  State<NearbyClinicsScreen> createState() => _NearbyClinicsScreenState();
}

class _NearbyClinicsScreenState extends State<NearbyClinicsScreen> {
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  Position? _currentPosition;
  int? _selectedClinicIndex;
  bool _isLoadingLocation = true;

  // Default center: Guwahati, Assam (Northeast India)
  static const LatLng _defaultCenter = LatLng(26.1445, 91.7362);

  @override
  void initState() {
    super.initState();
    _initMap();
  }

  /// Initialize map with clinic markers and user location.
  Future<void> _initMap() async {
    await _loadClinicMarkers();
    await _getUserLocation();
    setState(() => _isLoadingLocation = false);
  }

  /// Add markers for all dummy clinics.
  Future<void> _loadClinicMarkers() async {
    final clinics = AppConstants.dummyClinics;
    final markers = <Marker>{};

    for (int i = 0; i < clinics.length; i++) {
      final clinic = clinics[i];
      markers.add(
        Marker(
          markerId: MarkerId('clinic_$i'),
          position: LatLng(clinic['lat'], clinic['lng']),
          infoWindow: InfoWindow(
            title: clinic['name'],
            snippet: clinic['type'],
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueRed,
          ),
          onTap: () {
            setState(() => _selectedClinicIndex = i);
            _mapController?.animateCamera(
              CameraUpdate.newLatLngZoom(
                LatLng(clinic['lat'], clinic['lng']),
                13,
              ),
            );
          },
        ),
      );
    }

    setState(() => _markers.addAll(markers));
  }

  /// Get current device location (with permission check).
  Future<void> _getUserLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.medium,
          timeLimit: const Duration(seconds: 8),
        );
        setState(() => _currentPosition = position);

        // Animate map to user location
        _mapController?.animateCamera(
          CameraUpdate.newLatLngZoom(
            LatLng(position.latitude, position.longitude),
            10,
          ),
        );
      }
    } catch (_) {
      // Location unavailable — use default center
    }
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby Clinics'),
        backgroundColor: const Color(0xFF6A1B9A),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: _getUserLocation,
            tooltip: 'My Location',
          ),
        ],
      ),
      body: Stack(
        children: [
          // ── Google Map ──────────────────────────────────────
          GoogleMap(
            onMapCreated: (controller) {
              _mapController = controller;
              // Animate to user location once available
              if (_currentPosition != null) {
                controller.animateCamera(
                  CameraUpdate.newLatLngZoom(
                    LatLng(
                      _currentPosition!.latitude,
                      _currentPosition!.longitude,
                    ),
                    10,
                  ),
                );
              }
            },
            initialCameraPosition: const CameraPosition(
              target: _defaultCenter,
              zoom: 7,
            ),
            markers: _markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
          ),

          // ── Loading Indicator ───────────────────────────────
          if (_isLoadingLocation)
            Positioned(
              top: 12,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 6)
                    ],
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.primary,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text('Finding your location...',
                          style: TextStyle(
                              fontSize: 12, fontFamily: 'Poppins')),
                    ],
                  ),
                ),
              ),
            ),

          // ── Clinic count chip ──────────────────────────────
          if (!_isLoadingLocation)
            Positioned(
              top: 12,
              left: 16,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF6A1B9A),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${AppConstants.dummyClinics.length} Clinics nearby',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ),

          // ── Clinics Bottom Sheet ───────────────────────────
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 200,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, -4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle
                  Center(
                    child: Container(
                      margin: const EdgeInsets.only(top: 10),
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.divider,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 10, 16, 8),
                    child: Text(
                      'Health Centers',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding:
                          const EdgeInsets.symmetric(horizontal: 12),
                      itemCount: AppConstants.dummyClinics.length,
                      itemBuilder: (context, index) {
                        final clinic = AppConstants.dummyClinics[index];
                        final isSelected = _selectedClinicIndex == index;
                        return _ClinicCard(
                          clinic: clinic,
                          isSelected: isSelected,
                          onTap: () {
                            setState(() => _selectedClinicIndex = index);
                            _mapController?.animateCamera(
                              CameraUpdate.newLatLngZoom(
                                LatLng(clinic['lat'], clinic['lng']),
                                13,
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Clinic Card Widget ──────────────────────────────────────────────────────

class _ClinicCard extends StatelessWidget {
  final Map<String, dynamic> clinic;
  final bool isSelected;
  final VoidCallback onTap;

  const _ClinicCard({
    required this.clinic,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 200,
        margin: const EdgeInsets.only(right: 10, bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF3E5F5) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF6A1B9A)
                : AppColors.divider,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Icon(Icons.local_hospital,
                    color: Color(0xFF6A1B9A), size: 18),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    clinic['name'],
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      fontFamily: 'Poppins',
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              clinic['type'],
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 4),
            Text(
              clinic['address'],
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textHint,
                fontFamily: 'Poppins',
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.phone_outlined,
                    size: 12, color: AppColors.primary),
                const SizedBox(width: 4),
                Text(
                  clinic['phone'],
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.primary,
                    fontFamily: 'Poppins',
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
