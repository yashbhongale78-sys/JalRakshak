// lib/data/services/offline_storage_service.dart
// Manages local offline storage using Hive.
// Reports saved here are synced to Firestore when connectivity is restored.

import 'package:hive_flutter/hive_flutter.dart';
import '../models/symptom_report_model.dart';
import '../models/water_report_model.dart';
import '../../core/constants/app_constants.dart';

/// Manages offline data persistence using Hive.
/// Used when the device has no internet connection.
class OfflineStorageService {
  // ─── Symptom Reports Box ────────────────────────────────────

  /// Returns the open Hive box for offline symptom reports.
  Box<SymptomReportModel> get _symptomBox =>
      Hive.box<SymptomReportModel>(AppConstants.hiveBoxSymptomReports);

  /// Returns the open Hive box for offline water reports.
  Box<WaterReportModel> get _waterBox =>
      Hive.box<WaterReportModel>(AppConstants.hiveBoxWaterReports);

  // ─── Save Operations ────────────────────────────────────────

  /// Save a symptom report locally when offline.
  Future<void> saveSymptomReportOffline(SymptomReportModel report) async {
    await _symptomBox.put(report.id, report);
  }

  /// Save a water report locally when offline.
  Future<void> saveWaterReportOffline(WaterReportModel report) async {
    await _waterBox.put(report.id, report);
  }

  // ─── Read Operations ────────────────────────────────────────

  /// Get all unsynced symptom reports stored locally.
  List<SymptomReportModel> getUnsyncedSymptomReports() {
    return _symptomBox.values
        .where((report) => !report.isSynced)
        .toList();
  }

  /// Get all unsynced water reports stored locally.
  List<WaterReportModel> getUnsyncedWaterReports() {
    return _waterBox.values
        .where((report) => !report.isSynced)
        .toList();
  }

  /// Get total number of pending (unsynced) reports.
  int get pendingSyncCount {
    return getUnsyncedSymptomReports().length +
        getUnsyncedWaterReports().length;
  }

  // ─── Mark Synced ────────────────────────────────────────────

  /// Mark a symptom report as synced after successful Firestore upload.
  Future<void> markSymptomReportSynced(String reportId) async {
    final report = _symptomBox.get(reportId);
    if (report != null) {
      // Update the synced flag
      final updated = report.withSynced();
      await _symptomBox.put(reportId, updated);
    }
  }

  /// Mark a water report as synced.
  Future<void> markWaterReportSynced(String reportId) async {
    final report = _waterBox.get(reportId);
    if (report != null) {
      final updated = report.withSynced();
      await _waterBox.put(reportId, updated);
    }
  }

  // ─── Clear Operations ───────────────────────────────────────

  /// Delete all synced reports to free up local storage.
  Future<void> clearSyncedReports() async {
    final syncedSymptomKeys = _symptomBox.values
        .where((r) => r.isSynced)
        .map((r) => r.id)
        .toList();

    final syncedWaterKeys = _waterBox.values
        .where((r) => r.isSynced)
        .map((r) => r.id)
        .toList();

    await _symptomBox.deleteAll(syncedSymptomKeys);
    await _waterBox.deleteAll(syncedWaterKeys);
  }
}
