// lib/features/reports/screens/symptom_report_screen.dart
// Screen for villagers to report disease symptoms.
// Supports offline reporting with Hive + Firestore sync.

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/network_utils.dart';
import '../../../data/models/symptom_report_model.dart';
import '../../../data/services/firestore_service.dart';
import '../../../data/services/storage_service.dart';
import '../../../data/services/offline_storage_service.dart';
import '../../../features/auth/providers/auth_provider.dart';

class SymptomReportScreen extends ConsumerStatefulWidget {
  const SymptomReportScreen({super.key});

  @override
  ConsumerState<SymptomReportScreen> createState() =>
      _SymptomReportScreenState();
}

class _SymptomReportScreenState extends ConsumerState<SymptomReportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _affectedCountController = TextEditingController(text: '1');
  final _notesController = TextEditingController();
  final _villageController = TextEditingController();

  final List<String> _selectedSymptoms = [];
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
    // Pre-fill village from user profile
    final user = ref.read(currentUserProvider);
    _villageController.text = user?.village ?? '';
  }

  @override
  void dispose() {
    _affectedCountController.dispose();
    _notesController.dispose();
    _villageController.dispose();
    super.dispose();
  }

  /// Opens camera or gallery for photo selection.
  Future<void> _pickImage(ImageSource source) async {
    try {
      final picked = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 75,
      );
      if (picked != null) {
        setState(() => _pickedImage = File(picked.path));
      }
    } catch (e) {
      _showSnackBar('Could not open camera: $e', isError: true);
    }
  }

  /// Show image source selection sheet.
  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
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
                    child:
                        Icon(Icons.camera_alt, color: AppColors.primary)),
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
                title: const Text('Choose from Gallery',
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

  /// Submit the symptom report — online or offline.
  Future<void> _submitReport() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedSymptoms.isEmpty) {
      _showSnackBar('Please select at least one symptom', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = ref.read(currentUserProvider)!;
      final reportId = const Uuid().v4();

      // Check internet connectivity
      final hasInternet = await NetworkUtils.isConnected();

      String? photoUrl;

      // Build the report model
      final report = SymptomReportModel(
        id: reportId,
        reporterId: user.uid,
        reporterName: user.name,
        village: _villageController.text.trim(),
        district: user.district,
        state: user.state,
        symptoms: _selectedSymptoms,
        affectedCount: int.tryParse(_affectedCountController.text) ?? 1,
        additionalNotes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
        reportedAt: DateTime.now(),
        isSynced: hasInternet,
        photoUrl: photoUrl,
      );

      if (hasInternet) {
        // Upload photo if selected
        if (_pickedImage != null) {
          photoUrl = await _storageService.uploadSymptomPhoto(
            imageFile: _pickedImage!,
            reportId: reportId,
            userId: user.uid,
          );
        }
        // Save directly to Firestore
        await _firestoreService.submitSymptomReport(
          photoUrl != null
              ? SymptomReportModel(
                  id: report.id,
                  reporterId: report.reporterId,
                  reporterName: report.reporterName,
                  village: report.village,
                  district: report.district,
                  state: report.state,
                  symptoms: report.symptoms,
                  affectedCount: report.affectedCount,
                  photoUrl: photoUrl,
                  additionalNotes: report.additionalNotes,
                  reportedAt: report.reportedAt,
                  isSynced: true,
                )
              : report,
        );
        _showSnackBar('✅ Report submitted successfully!');
      } else {
        // Save locally using Hive
        await _offlineService.saveSymptomReportOffline(report);
        _showSnackBar(
            '📴 Saved offline. Will sync when internet is available.');
      }

      setState(() => _submitted = true);
    } catch (e) {
      _showSnackBar('Failed to submit: ${e.toString().replaceAll('Exception: ', '')}',
          isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontFamily: 'Poppins')),
        backgroundColor: isError ? AppColors.alert : AppColors.secondary,
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Show success view after submission
    if (_submitted) return _buildSuccessView();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Symptoms'),
        backgroundColor: AppColors.alert,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Info Banner ───────────────────────────────
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.alertContainer,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: AppColors.alert.withOpacity(0.3)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.info_outline,
                          color: AppColors.alert, size: 20),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Report any disease symptoms in your village. '
                          'Your report helps health workers respond faster.',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.alert,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // ── Symptom Selection ─────────────────────────
                Text('Select Symptoms *',
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 4),
                const Text('Tap all that apply',
                    style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        fontFamily: 'Poppins')),
                const SizedBox(height: 12),

                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: AppConstants.symptomTypes.map((symptom) {
                    final isSelected = _selectedSymptoms.contains(symptom);
                    return FilterChip(
                      label: Text(symptom,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: isSelected
                                ? Colors.white
                                : AppColors.textPrimary,
                          )),
                      selected: isSelected,
                      selectedColor: AppColors.alert,
                      checkmarkColor: Colors.white,
                      backgroundColor: Colors.white,
                      side: BorderSide(
                        color: isSelected
                            ? AppColors.alert
                            : AppColors.divider,
                      ),
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _selectedSymptoms.add(symptom);
                          } else {
                            _selectedSymptoms.remove(symptom);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),

                // ── Number of Affected ────────────────────────
                Text('Number of Affected People *',
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _affectedCountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.people_outline),
                    hintText: 'e.g. 5',
                    suffixText: 'people',
                  ),
                  validator: (val) {
                    if (val == null || val.isEmpty) return 'Required';
                    final n = int.tryParse(val);
                    if (n == null || n < 1) return 'Enter a valid number';
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // ── Village ───────────────────────────────────
                Text('Village Name *',
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _villageController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.home_outlined),
                    hintText: 'Enter village name',
                  ),
                  validator: (val) =>
                      (val == null || val.isEmpty) ? 'Required' : null,
                ),
                const SizedBox(height: 20),

                // ── Photo Upload ──────────────────────────────
                Text('Add Photo (Optional)',
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 4),
                const Text('Photo of affected person / situation',
                    style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        fontFamily: 'Poppins')),
                const SizedBox(height: 10),

                if (_pickedImage != null) ...[
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          _pickedImage!,
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
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
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.close,
                                color: Colors.white, size: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextButton.icon(
                    onPressed: _showImageSourceDialog,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Change Photo'),
                  ),
                ] else
                  GestureDetector(
                    onTap: _showImageSourceDialog,
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.divider,
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.camera_alt_outlined,
                              size: 32, color: AppColors.textHint),
                          SizedBox(height: 8),
                          Text('Tap to add photo',
                              style: TextStyle(
                                  color: AppColors.textHint,
                                  fontFamily: 'Poppins')),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 20),

                // ── Additional Notes ──────────────────────────
                Text('Additional Notes',
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _notesController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText:
                        'Any other details about the illness or situation...',
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(bottom: 40),
                      child: Icon(Icons.notes_outlined),
                    ),
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: 32),

                // ── Submit Button ─────────────────────────────
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _submitReport,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.alert,
                  ),
                  icon: _isLoading
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2))
                      : const Icon(Icons.send_outlined),
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

  /// Success screen shown after report submission.
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
                    color: AppColors.secondaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    size: 72,
                    color: AppColors.secondary,
                  ),
                ),
                const SizedBox(height: 24),
                Text('Report Submitted!',
                    style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 12),
                const Text(
                  'Thank you for reporting. Health workers will review your report and take necessary action.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    fontFamily: 'Poppins',
                  ),
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
