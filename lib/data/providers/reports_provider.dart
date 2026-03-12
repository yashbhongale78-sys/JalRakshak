// lib/data/providers/reports_provider.dart
// Riverpod providers for real-time Firebase reports data

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/symptom_report_model.dart';
import '../models/water_report_model.dart';
import '../services/firestore_service.dart';

// Firestore service provider
final firestoreServiceProvider = Provider<FirestoreService>((ref) {
  return FirestoreService();
});

// Real-time stream of all reports from the main reports collection
final allReportsStreamProvider =
    StreamProvider<List<Map<String, dynamic>>>((ref) {
  final firestore = FirebaseFirestore.instance;

  return firestore
      .collection('reports')
      .orderBy('timestamp', descending: true)
      .limit(50)
      .snapshots()
      .map((snapshot) {
    return snapshot.docs.map((doc) {
      final data = doc.data();
      return {
        'id': doc.id,
        'intent': data['intent'] ?? 'UNKNOWN',
        'phone': data['phone'] ?? 'Unknown',
        'message': data['message'] ?? '',
        'timestamp':
            (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
        'language': data['language'] ?? 'EN',
        'alerted': data['alerted'] ?? false,
        'status': data['alerted'] == true ? 'Active' : 'Pending',
      };
    }).toList();
  }).handleError((error) {
    print('Error loading reports: $error');
    return <Map<String, dynamic>>[];
  });
});

// Stream of symptom reports only
final symptomReportsStreamProvider =
    StreamProvider<List<SymptomReportModel>>((ref) {
  final firestore = FirebaseFirestore.instance;

  return firestore
      .collection('symptom_reports')
      .orderBy('reportedAt', descending: true)
      .limit(30)
      .snapshots()
      .map((snapshot) {
    return snapshot.docs
        .map((doc) => SymptomReportModel.fromMap(doc.data()))
        .toList();
  }).handleError((error) {
    print('Error loading symptom reports: $error');
    return <SymptomReportModel>[];
  });
});

// Stream of water reports only
final waterReportsStreamProvider =
    StreamProvider<List<WaterReportModel>>((ref) {
  final firestore = FirebaseFirestore.instance;

  return firestore
      .collection('water_reports')
      .orderBy('reportedAt', descending: true)
      .limit(30)
      .snapshots()
      .map((snapshot) {
    return snapshot.docs
        .map((doc) => WaterReportModel.fromMap(doc.data()))
        .toList();
  }).handleError((error) {
    print('Error loading water reports: $error');
    return <WaterReportModel>[];
  });
});

// Reports count provider
final reportsCountProvider = StreamProvider<int>((ref) {
  final firestore = FirebaseFirestore.instance;

  return firestore
      .collection('reports')
      .snapshots()
      .map((snapshot) => snapshot.docs.length)
      .handleError((error) {
    print('Error loading reports count: $error');
    return 0;
  });
});

// Today's reports count
final todayReportsCountProvider = StreamProvider<int>((ref) {
  final firestore = FirebaseFirestore.instance;
  final today = DateTime.now();
  final startOfDay = DateTime(today.year, today.month, today.day);

  return firestore
      .collection('reports')
      .where('timestamp',
          isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
      .snapshots()
      .map((snapshot) => snapshot.docs.length)
      .handleError((error) {
    print('Error loading today reports count: $error');
    return 0;
  });
});

// Reports by intent type
final reportsByIntentProvider = StreamProvider<Map<String, int>>((ref) {
  final firestore = FirebaseFirestore.instance;

  return firestore.collection('reports').snapshots().map((snapshot) {
    final Map<String, int> intentCounts = {};

    for (final doc in snapshot.docs) {
      final intent = doc.data()['intent'] as String? ?? 'UNKNOWN';
      intentCounts[intent] = (intentCounts[intent] ?? 0) + 1;
    }

    return intentCounts;
  }).handleError((error) {
    print('Error loading reports by intent: $error');
    return <String, int>{};
  });
});
