// lib/data/providers/alerts_provider.dart
// Riverpod providers for real-time Firebase alerts data

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Real-time stream of active alerts
final activeAlertsStreamProvider =
    StreamProvider<List<Map<String, dynamic>>>((ref) {
  final firestore = FirebaseFirestore.instance;

  return firestore
      .collection('alerts')
      .where('resolved', isEqualTo: false)
      .snapshots()
      .map((snapshot) {
    return snapshot.docs.map((doc) {
      final data = doc.data();
      return {
        'id': doc.id,
        'title':
            '${data['intent']?.toString().toUpperCase() ?? 'ALERT'} Outbreak Detected',
        'type': data['intent'] ?? 'UNKNOWN',
        'reportCount': data['report_count'] ?? 0,
        'zone': 'Zone ${data['phone']?.toString().substring(0, 6) ?? 'XXXX'}',
        'timestamp':
            (data['triggered_at'] as Timestamp?)?.toDate() ?? DateTime.now(),
        'severity': (data['report_count'] ?? 0) >= 10 ? 'critical' : 'warning',
        'progress': ((data['report_count'] ?? 0) / 15.0).clamp(0.0, 1.0),
        'resolved': data['resolved'] ?? false,
        'phone': data['phone'] ?? '',
      };
    }).toList();
  }).handleError((error) {
    print('Error loading alerts: $error');
    return <Map<String, dynamic>>[];
  });
});

// Count of active alerts
final activeAlertsCountProvider = StreamProvider<int>((ref) {
  final firestore = FirebaseFirestore.instance;

  return firestore
      .collection('alerts')
      .where('resolved', isEqualTo: false)
      .snapshots()
      .map((snapshot) => snapshot.docs.length)
      .handleError((error) {
    print('Error loading alerts count: $error');
    return 0;
  });
});

// Critical alerts count
final criticalAlertsCountProvider = StreamProvider<int>((ref) {
  final firestore = FirebaseFirestore.instance;

  return firestore
      .collection('alerts')
      .where('resolved', isEqualTo: false)
      .snapshots()
      .map((snapshot) {
    return snapshot.docs.where((doc) {
      final reportCount = doc.data()['report_count'] ?? 0;
      return reportCount >= 10;
    }).length;
  }).handleError((error) {
    print('Error loading critical alerts count: $error');
    return 0;
  });
});

// Warning alerts count
final warningAlertsCountProvider = StreamProvider<int>((ref) {
  final firestore = FirebaseFirestore.instance;

  return firestore
      .collection('alerts')
      .where('resolved', isEqualTo: false)
      .snapshots()
      .map((snapshot) {
    return snapshot.docs.where((doc) {
      final reportCount = doc.data()['report_count'] ?? 0;
      return reportCount < 10;
    }).length;
  }).handleError((error) {
    print('Error loading warning alerts count: $error');
    return 0;
  });
});

// Resolved alerts today count
final resolvedTodayCountProvider = StreamProvider<int>((ref) {
  final firestore = FirebaseFirestore.instance;
  final today = DateTime.now();
  final startOfDay = DateTime(today.year, today.month, today.day);

  return firestore
      .collection('alerts')
      .where('resolved', isEqualTo: true)
      .where('triggered_at',
          isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
      .snapshots()
      .map((snapshot) => snapshot.docs.length)
      .handleError((error) {
    print('Error loading resolved alerts count: $error');
    return 0;
  });
});
