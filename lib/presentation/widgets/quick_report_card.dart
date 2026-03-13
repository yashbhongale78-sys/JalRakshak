// lib/presentation/widgets/quick_report_card.dart
// Quick report form widget for home screen

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import '../../core/theme/app_theme.dart';
import '../../core/localization/app_localizations.dart';
import '../../features/auth/providers/auth_provider.dart';
import '../../data/services/notification_service.dart';

class QuickReportCard extends ConsumerStatefulWidget {
  const QuickReportCard({super.key});

  @override
  ConsumerState<QuickReportCard> createState() => _QuickReportCardState();
}

class _QuickReportCardState extends ConsumerState<QuickReportCard> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _otherDiseaseController = TextEditingController();
  final _notificationService = NotificationService();

  String _selectedDisease = 'Fever';
  String _selectedCause = 'Contaminated Water';
  bool _isSubmitting = false;

  final List<String> _diseases = [
    'Fever',
    'Diarrhea',
    'Vomiting',
    'Skin Rash',
    'Cholera',
    'Typhoid',
    'Jaundice',
    'Other',
  ];

  final List<String> _causes = [
    'Contaminated Water',
    'Poor Sanitation',
    'Food Poisoning',
    'Unknown',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _loadUserLocation();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    _otherDiseaseController.dispose();
    super.dispose();
  }

  Future<void> _loadUserLocation() async {
    final user = ref.read(currentUserProvider);
    if (user != null) {
      _nameController.text = user.name;
      _locationController.text = '${user.village}, ${user.district}';
    }
  }

  Future<Position?> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return null;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return null;
      }

      return await Geolocator.getCurrentPosition();
    } catch (e) {
      print('Error getting location: $e');
      return null;
    }
  }

  Future<void> _submitReport() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final user = ref.read(currentUserProvider);
      if (user == null) {
        throw Exception('User not logged in');
      }

      // Get current location
      final position = await _getCurrentLocation();
      final lat = position?.latitude ?? 0.0;
      final lng = position?.longitude ?? 0.0;

      // Create report data
      final diseaseToReport = _selectedDisease == 'Other'
          ? _otherDiseaseController.text.trim()
          : _selectedDisease;

      final reportData = {
        'name': _nameController.text.trim(),
        'location': _locationController.text.trim(),
        'symptom_type': diseaseToReport,
        'caused_by': _selectedCause,
        'description': _descriptionController.text.trim(),
        'severity': _calculateSeverity(_selectedDisease),
        'lat': lat,
        'lng': lng,
        'submitted_by': user.uid,
        'timestamp': Timestamp.now(),
        'status': 'Pending',
        'district': user.district,
        'village': user.village,
        'state': user.state,
      };

      // Add to reports collection
      await FirebaseFirestore.instance.collection('reports').add(reportData);

      // Update community aggregation
      await _updateCommunityAggregation(user, diseaseToReport);

      // Check if alert should be created
      await _checkAndCreateAlert(user, diseaseToReport);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).t('report_submitted')),
            backgroundColor: AppColors.safe,
            behavior: SnackBarBehavior.floating,
          ),
        );

        // Clear form
        _descriptionController.clear();
        _otherDiseaseController.clear();
        setState(() {
          _selectedDisease = 'Fever';
          _selectedCause = 'Contaminated Water';
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: AppColors.danger,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  String _calculateSeverity(String disease) {
    // High severity diseases
    if (['Cholera', 'Typhoid', 'Jaundice'].contains(disease)) {
      return 'High';
    }
    // Medium severity
    if (['Diarrhea', 'Vomiting'].contains(disease)) {
      return 'Medium';
    }
    // Low severity
    return 'Low';
  }

  Future<void> _updateCommunityAggregation(user, String disease) async {
    try {
      final locationKey = '${user.village}_${user.district}_${user.state}';
      final docRef = FirebaseFirestore.instance
          .collection('community_reports')
          .doc(locationKey);

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final snapshot = await transaction.get(docRef);

        if (snapshot.exists) {
          final data = snapshot.data()!;
          final diseaseCounts =
              Map<String, int>.from(data['diseaseCounts'] ?? {});
          diseaseCounts[disease] = (diseaseCounts[disease] ?? 0) + 1;

          final totalCases =
              diseaseCounts.values.fold(0, (sum, count) => sum + count);
          final riskLevel =
              totalCases >= 10 ? 'HIGH' : (totalCases >= 5 ? 'MEDIUM' : 'LOW');

          transaction.update(docRef, {
            'diseaseCounts': diseaseCounts,
            'totalCases': totalCases,
            'riskLevel': riskLevel,
            'lastUpdated': Timestamp.now(),
          });
        } else {
          transaction.set(docRef, {
            'location': user.village,
            'district': user.district,
            'state': user.state,
            'diseaseCounts': {disease: 1},
            'totalCases': 1,
            'riskLevel': 'LOW',
            'lastUpdated': Timestamp.now(),
          });
        }
      });
    } catch (e) {
      print('Error updating community aggregation: $e');
    }
  }

  Future<void> _checkAndCreateAlert(user, String disease) async {
    try {
      print('🔍 Checking for alerts...');
      print('Disease: $disease');
      print('Village: ${user.village}');
      print('District: ${user.district}');

      // Count recent reports in the same location
      final recentReports = await FirebaseFirestore.instance
          .collection('reports')
          .where('village', isEqualTo: user.village)
          .where('district', isEqualTo: user.district)
          .where('symptom_type', isEqualTo: disease)
          .where('timestamp',
              isGreaterThan: Timestamp.fromDate(
                  DateTime.now().subtract(const Duration(hours: 24))))
          .get();

      final reportCount = recentReports.docs.length;

      print('📊 Found $reportCount reports in last 24 hours');

      // Create alert if threshold is reached
      if (reportCount >= 3) {
        print('⚠️ THRESHOLD REACHED! Creating alert...');
        final severity = reportCount >= 5 ? 'critical' : 'warning';

        await FirebaseFirestore.instance.collection('alerts').add({
          'title': '$disease Outbreak Alert',
          'message':
              '$reportCount cases of $disease reported in ${user.village} in the last 24 hours.',
          'severity': severity,
          'district': user.district,
          'zone': user.village,
          'timestamp': Timestamp.now(),
          'reportCount': reportCount,
          'progress': reportCount >= 5 ? 0.8 : 0.5,
          'status': 'Active',
          'resolved': false, // Add this field for the alerts provider
          'intent': disease, // Add disease name for display
          'report_count': reportCount, // Add for compatibility
          'triggered_at': Timestamp.now(), // Add for compatibility
        });

        print('✅ Alert created in Firestore');

        // Send push notification
        await _notificationService.sendAlertNotification(
          disease: disease,
          location: user.village,
          caseCount: reportCount,
          isCritical: severity == 'critical',
        );

        print('✅ Notification sent');
      } else {
        print('ℹ️ Not enough reports yet. Need 3, have $reportCount');
      }
    } catch (e) {
      print('❌ Error checking/creating alert: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.add_circle_outline,
                    color: AppColors.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    l10n.t('quick_report'),
                    style: const TextStyle(
                      color: AppColors.textLight,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Name Field
            TextFormField(
              controller: _nameController,
              style: const TextStyle(color: AppColors.textLight),
              decoration: InputDecoration(
                labelText: l10n.t('name'),
                labelStyle: const TextStyle(color: AppColors.textMuted),
                prefixIcon:
                    const Icon(Icons.person_outline, color: AppColors.primary),
                filled: true,
                fillColor: AppColors.backgroundDark,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              validator: (val) => val?.isEmpty ?? true
                  ? '${l10n.t('name')} ${l10n.t('is_required')}'
                  : null,
            ),
            const SizedBox(height: 12),

            // Location Field
            TextFormField(
              controller: _locationController,
              style: const TextStyle(color: AppColors.textLight),
              decoration: InputDecoration(
                labelText: l10n.t('location'),
                labelStyle: const TextStyle(color: AppColors.textMuted),
                prefixIcon:
                    const Icon(Icons.location_on, color: AppColors.primary),
                filled: true,
                fillColor: AppColors.backgroundDark,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              validator: (val) => val?.isEmpty ?? true
                  ? '${l10n.t('location')} ${l10n.t('is_required')}'
                  : null,
            ),
            const SizedBox(height: 12),

            // Disease Dropdown
            DropdownButtonFormField<String>(
              value: _selectedDisease,
              style: const TextStyle(color: AppColors.textLight),
              dropdownColor: AppColors.backgroundDark,
              decoration: InputDecoration(
                labelText: l10n.t('disease'),
                labelStyle: const TextStyle(color: AppColors.textMuted),
                prefixIcon: const Icon(Icons.medical_services_outlined,
                    color: AppColors.primary),
                filled: true,
                fillColor: AppColors.backgroundDark,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              items: _diseases.map((disease) {
                return DropdownMenuItem(
                  value: disease,
                  child: Text(l10n.t(disease.toLowerCase())),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedDisease = value);
                }
              },
            ),

            // Show text field when "Other" is selected
            if (_selectedDisease == 'Other') ...[
              const SizedBox(height: 12),
              TextFormField(
                controller: _otherDiseaseController,
                style: const TextStyle(color: AppColors.textLight),
                decoration: InputDecoration(
                  labelText: '${l10n.t('disease')} (${l10n.t('other')})',
                  labelStyle: const TextStyle(color: AppColors.textMuted),
                  hintText: l10n.t('disease'),
                  hintStyle: const TextStyle(color: AppColors.textMuted),
                  prefixIcon:
                      const Icon(Icons.edit_outlined, color: AppColors.primary),
                  filled: true,
                  fillColor: AppColors.backgroundDark,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (val) {
                  if (_selectedDisease == 'Other' && (val?.isEmpty ?? true)) {
                    return l10n.t('please_specify_disease');
                  }
                  return null;
                },
              ),
            ],
            const SizedBox(height: 12),

            // Caused By Dropdown
            DropdownButtonFormField<String>(
              value: _selectedCause,
              style: const TextStyle(color: AppColors.textLight),
              dropdownColor: AppColors.backgroundDark,
              decoration: InputDecoration(
                labelText: l10n.t('caused_by'),
                labelStyle: const TextStyle(color: AppColors.textMuted),
                prefixIcon: const Icon(Icons.warning_amber_outlined,
                    color: AppColors.primary),
                filled: true,
                fillColor: AppColors.backgroundDark,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              items: _causes.map((cause) {
                return DropdownMenuItem(
                  value: cause,
                  child: Text(cause),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedCause = value);
                }
              },
            ),
            const SizedBox(height: 12),

            // Description Field
            TextFormField(
              controller: _descriptionController,
              style: const TextStyle(color: AppColors.textLight),
              maxLines: 3,
              decoration: InputDecoration(
                labelText: l10n.t('description'),
                labelStyle: const TextStyle(color: AppColors.textMuted),
                prefixIcon: const Icon(Icons.description_outlined,
                    color: AppColors.primary),
                filled: true,
                fillColor: AppColors.backgroundDark,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitReport,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        l10n.t('submit_report'),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
