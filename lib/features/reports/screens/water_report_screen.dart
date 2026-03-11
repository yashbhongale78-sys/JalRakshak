// lib/features/reports/screens/water_report_screen.dart
// Screen for villagers to report water contamination issues.

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/network_utils.dart';
import '../../../data/models/water_report_model.dart';
import '../../../data/services/firestore_service.dart';
import '../../../data/services/storage_service.dart';
import '../../../data/services/offline_storage_service.dart';
import '../../../features/auth/providers/auth_provider.dart';

class WaterReportScreen extends ConsumerStatefulWidget {
  const WaterReportScreen({super.key});

  @override
  ConsumerState<WaterReportScreen> createState() => _WaterReportScreenState();
}

class _WaterReportScreenState extends ConsumerState<WaterReportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _villageController = TextEditingController();
  final _waterSourceController = TextEditingController();
  final _descriptionController = TextEditingController();

  final List<String> _selectedIssues = [];
  bool _isUrgent = false;
  File? _pickedImage;
  bool _isLoading = false;
  bool _submitted = false;

  final _firestoreService = FirestoreService();
  final _storageService = StorageService();
  final _offlineService = OfflineStorageService();
  final _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final user = ref.read(currentUserProvider);
    _villageController.text = user?.village ?? '';
  }

  @override
  void dispose() {
    _villageController.dispose();
    _waterSourceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picked = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1024,
        imageQuality: 75,
      );
      if (picked != null) setState(() => _pickedImage = File(picked.path));
    } catch (e) {
      _showSnackBar('Could not open camera', isError: true);
    }
  }

  void _showImageSourceSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Add Photo',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins')),
              const SizedBox(height: 16),
              ListTile(
                leading: const CircleAvatar(
                    backgroundColor: AppColors.primaryContainer,
                    child: Icon(Icons.camera_alt, color: AppColors.primary)),
                title: const Text('Take Photo',
                    style: TextStyle(fontFamily: 'Poppins')),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const CircleAvatar(
                    backgroundColor: AppColors.secondaryContainer,
                    child: Icon(Icons.photo_library,
                        color: AppColors.secondary)),
                title: const Text('Gallery',
                    style: TextStyle(fontFamily: 'Poppins')),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitReport() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedIssues.isEmpty) {
      _showSnackBar('Please select at least one issue', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = ref.read(currentUserProvider)!;
      final reportId = const Uuid().v4();
      final hasInternet = await NetworkUtils.isConnected();

      String? photoUrl;

      final report = WaterReportModel(
        id: reportId,
        reporterId: user.uid,
        reporterName: user.name,
        village: _villageController.text.trim(),
        district: user.district,
        state: user.state,
        waterSourceName: _waterSourceController.text.trim(),
        issues: _selectedIssues,
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        reportedAt: DateTime.now(),
        isSynced: hasInternet,
        isUrgent: _isUrgent,
        photoUrl: photoUrl,
      );

      if (hasInternet) {
        if (_pickedImage != null) {
          photoUrl = await _storageService.uploadWaterPhoto(
            imageFile: _pickedImage!,
            reportId: reportId,
            userId: user.uid,
          );
        }
        await _firestoreService.submitWaterReport(
          photoUrl != null
              ? WaterReportModel(
                  id: report.id,
                  reporterId: report.reporterId,
                  reporterName: report.reporterName,
                  village: report.village,
                  district: report.district,
                  state: report.state,
                  waterSourceName: report.waterSourceName,
                  issues: report.issues,
                  description: report.description,
                  reportedAt: report.reportedAt,
                  isSynced: true,
                  isUrgent: report.isUrgent,
                  photoUrl: photoUrl,
                )
              : report,
        );
        _showSnackBar('✅ Water contamination report submitted!');
      } else {
        await _offlineService.saveWaterReportOffline(report);
        _showSnackBar('📴 Saved offline. Will sync when internet returns.');
      }

      setState(() => _submitted = true);
    } catch (e) {
      _showSnackBar(
          'Failed: ${e.toString().replaceAll("Exception: ", "")}',
          isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg, style: const TextStyle(fontFamily: 'Poppins')),
      backgroundColor: isError ? AppColors.alert : AppColors.secondary,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    if (_submitted) return _buildSuccessView();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Water Issue'),
        backgroundColor: AppColors.primary,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Urgent Toggle
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: _isUrgent
                        ? AppColors.alertContainer
                        : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _isUrgent
                          ? AppColors.alert.withOpacity(0.4)
                          : AppColors.divider,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        color:
                            _isUrgent ? AppColors.alert : AppColors.textHint,
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Mark as Urgent',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Poppins')),
                            Text('Needs immediate attention',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                    fontFamily: 'Poppins')),
                          ],
                        ),
                      ),
                      Switch(
                        value: _isUrgent,
                        onChanged: (val) => setState(() => _isUrgent = val),
                        activeColor: AppColors.alert,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Water Source Name
                Text('Water Source Name *',
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _waterSourceController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.water_outlined),
                    hintText: 'e.g. Village well, River, Tap water',
                  ),
                  validator: (val) => (val == null || val.isEmpty)
                      ? 'Water source name is required'
                      : null,
                ),
                const SizedBox(height: 20),

                // Village Name
                Text('Village Name *',
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _villageController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.home_outlined),
                  ),
                  validator: (val) =>
                      (val == null || val.isEmpty) ? 'Required' : null,
                ),
                const SizedBox(height: 20),

                // Issue Selection
                Text('Type of Issue *',
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 4),
                const Text('Select all that apply',
                    style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        fontFamily: 'Poppins')),
                const SizedBox(height: 12),

                ...AppConstants.waterIssueTypes.map((issue) {
                  final isSelected = _selectedIssues.contains(issue);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: CheckboxListTile(
                      value: isSelected,
                      onChanged: (val) {
                        setState(() {
                          if (val == true) {
                            _selectedIssues.add(issue);
                          } else {
                            _selectedIssues.remove(issue);
                          }
                        });
                      },
                      title: Text(issue,
                          style: const TextStyle(
                              fontSize: 14, fontFamily: 'Poppins')),
                      activeColor: AppColors.primary,
                      tileColor: isSelected
                          ? AppColors.primaryContainer
                          : Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 2),
                    ),
                  );
                }),
                const SizedBox(height: 20),

                // Photo
                Text('Photo of Water Issue (Optional)',
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 10),
                if (_pickedImage != null) ...[
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(_pickedImage!,
                            height: 160,
                            width: double.infinity,
                            fit: BoxFit.cover),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: () => setState(() => _pickedImage = null),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                                color: Colors.black54,
                                shape: BoxShape.circle),
                            child: const Icon(Icons.close,
                                color: Colors.white, size: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                ] else
                  GestureDetector(
                    onTap: _showImageSourceSheet,
                    child: Container(
                      height: 90,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.divider),
                      ),
                      child: const Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_a_photo_outlined,
                                color: AppColors.textHint),
                            SizedBox(width: 8),
                            Text('Add photo',
                                style: TextStyle(
                                    color: AppColors.textHint,
                                    fontFamily: 'Poppins')),
                          ],
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 20),

                // Description
                Text('Description',
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText: 'Describe the water problem in detail...',
                  ),
                ),
                const SizedBox(height: 32),

                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _submitReport,
                  icon: _isLoading
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2))
                      : const Icon(Icons.water_damage),
                  label: Text(_isLoading ? 'Submitting...' : 'Submit Report'),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessView() {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: const BoxDecoration(
                      color: AppColors.primaryContainer,
                      shape: BoxShape.circle),
                  child: const Icon(Icons.water_drop,
                      size: 72, color: AppColors.primary),
                ),
                const SizedBox(height: 24),
                Text('Report Submitted!',
                    style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 12),
                const Text(
                  'Your water contamination report has been received. '
                  'Authorities will inspect the water source.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      fontFamily: 'Poppins'),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Back to Dashboard'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
