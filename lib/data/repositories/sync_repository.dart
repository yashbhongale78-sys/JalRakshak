// lib/data/repositories/sync_repository.dart
// Orchestrates syncing offline Hive data to Firestore when internet returns.

import 'package:connectivity_plus/connectivity_plus.dart';
import '../services/offline_storage_service.dart';
import '../services/firestore_service.dart';
import '../../core/utils/network_utils.dart';

/// Manages the sync between local Hive storage and Firestore.
/// Listens to connectivity changes and triggers sync automatically.
class SyncRepository {
  final OfflineStorageService _offlineService;
  final FirestoreService _firestoreService;

  SyncRepository({
    required OfflineStorageService offlineService,
    required FirestoreService firestoreService,
  })  : _offlineService = offlineService,
        _firestoreService = firestoreService;

  /// Start listening for connectivity changes.
  /// When internet returns, automatically sync pending reports.
  void startAutoSync() {
    NetworkUtils.connectivityStream.listen((result) async {
      final isOnline = result == ConnectivityResult.wifi ||
          result == ConnectivityResult.mobile ||
          result == ConnectivityResult.ethernet;

      if (isOnline) {
        await syncPendingReports();
      }
    });
  }

  /// Manually trigger sync of all pending offline reports.
  /// Returns the number of reports synced.
  Future<int> syncPendingReports() async {
    int syncedCount = 0;

    // Check connectivity before attempting
    final hasInternet = await NetworkUtils.isConnected();
    if (!hasInternet) return 0;

    try {
      // ── Sync Symptom Reports ──────────────────────────────
      final unsyncedSymptoms = _offlineService.getUnsyncedSymptomReports();
      if (unsyncedSymptoms.isNotEmpty) {
        await _firestoreService.syncOfflineSymptomReports(unsyncedSymptoms);

        // Mark each as synced in local storage
        for (final report in unsyncedSymptoms) {
          await _offlineService.markSymptomReportSynced(report.id);
          syncedCount++;
        }
      }

      // ── Sync Water Reports ────────────────────────────────
      final unsyncedWater = _offlineService.getUnsyncedWaterReports();
      if (unsyncedWater.isNotEmpty) {
        await _firestoreService.syncOfflineWaterReports(unsyncedWater);

        for (final report in unsyncedWater) {
          await _offlineService.markWaterReportSynced(report.id);
          syncedCount++;
        }
      }

      // Clean up synced records periodically
      if (syncedCount > 0) {
        await _offlineService.clearSyncedReports();
      }

      return syncedCount;
    } catch (e) {
      // Log error — sync will retry next time internet is available
      print('Sync failed: $e');
      return 0;
    }
  }

  /// Check how many reports are pending sync.
  int get pendingCount => _offlineService.pendingSyncCount;
}
