// lib/data/services/firestore_service.dart
// Service class for all Firestore database operations.

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/symptom_report_model.dart';
import '../models/water_report_model.dart';
import '../models/alert_model.dart';
import '../../core/constants/app_constants.dart';

/// Handles all CRUD operations with Cloud Firestore.
class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ════════════════════════════════════════════════════
  // SYMPTOM REPORTS
  // ════════════════════════════════════════════════════

  /// Save a symptom report to Firestore.
  Future<void> submitSymptomReport(SymptomReportModel report) async {
    try {
      await _db
          .collection(AppConstants.symptomReportsCollection)
          .doc(report.id)
          .set(report.toMap());
    } catch (e) {
      throw Exception('Failed to submit symptom report: $e');
    }
  }

  /// Fetch all symptom reports for a specific village.
  Future<List<SymptomReportModel>> getSymptomReportsByVillage(
      String village) async {
    try {
      final query = await _db
          .collection(AppConstants.symptomReportsCollection)
          .where('village', isEqualTo: village)
          .orderBy('reportedAt', descending: true)
          .limit(50)
          .get();

      return query.docs
          .map((doc) => SymptomReportModel.fromMap(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch symptom reports: $e');
    }
  }

  /// Fetch symptom reports by a specific user.
  Future<List<SymptomReportModel>> getMySymptomReports(
      String reporterId) async {
    try {
      final query = await _db
          .collection(AppConstants.symptomReportsCollection)
          .where('reporterId', isEqualTo: reporterId)
          .orderBy('reportedAt', descending: true)
          .limit(20)
          .get();

      return query.docs
          .map((doc) => SymptomReportModel.fromMap(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch your reports: $e');
    }
  }

  // ════════════════════════════════════════════════════
  // WATER CONTAMINATION REPORTS
  // ════════════════════════════════════════════════════

  /// Save a water contamination report to Firestore.
  Future<void> submitWaterReport(WaterReportModel report) async {
    try {
      await _db
          .collection(AppConstants.waterReportsCollection)
          .doc(report.id)
          .set(report.toMap());
    } catch (e) {
      throw Exception('Failed to submit water report: $e');
    }
  }

  /// Fetch water reports for a given village.
  Future<List<WaterReportModel>> getWaterReportsByVillage(
      String village) async {
    try {
      final query = await _db
          .collection(AppConstants.waterReportsCollection)
          .where('village', isEqualTo: village)
          .orderBy('reportedAt', descending: true)
          .limit(50)
          .get();

      return query.docs
          .map((doc) => WaterReportModel.fromMap(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch water reports: $e');
    }
  }

  // ════════════════════════════════════════════════════
  // ALERTS
  // ════════════════════════════════════════════════════

  /// Real-time stream of active alerts — sorted by issue date.
  Stream<List<AlertModel>> getAlertsStream() {
    return _db
        .collection(AppConstants.alertsCollection)
        .where('isActive', isEqualTo: true)
        .orderBy('issuedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => AlertModel.fromMap(doc.data()))
            .toList());
  }

  /// Fetch all active alerts once (non-stream).
  Future<List<AlertModel>> getAlerts() async {
    try {
      final query = await _db
          .collection(AppConstants.alertsCollection)
          .where('isActive', isEqualTo: true)
          .orderBy('issuedAt', descending: true)
          .get();

      return query.docs
          .map((doc) => AlertModel.fromMap(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch alerts: $e');
    }
  }

  /// Get count of active alerts (used for badge).
  Future<int> getActiveAlertCount() async {
    try {
      final query = await _db
          .collection(AppConstants.alertsCollection)
          .where('isActive', isEqualTo: true)
          .count()
          .get();
      return query.count ?? 0;
    } catch (_) {
      return 0;
    }
  }

  // ════════════════════════════════════════════════════
  // SYNC HELPERS
  // ════════════════════════════════════════════════════

  /// Sync a batch of offline symptom reports to Firestore.
  Future<void> syncOfflineSymptomReports(
      List<SymptomReportModel> reports) async {
    final batch = _db.batch();
    for (final report in reports) {
      final ref = _db
          .collection(AppConstants.symptomReportsCollection)
          .doc(report.id);
      batch.set(ref, report.toMap());
    }
    await batch.commit();
  }

  /// Sync a batch of offline water reports to Firestore.
  Future<void> syncOfflineWaterReports(List<WaterReportModel> reports) async {
    final batch = _db.batch();
    for (final report in reports) {
      final ref = _db
          .collection(AppConstants.waterReportsCollection)
          .doc(report.id);
      batch.set(ref, report.toMap());
    }
    await batch.commit();
  }
}
