// lib/data/providers/villages_provider.dart
// Riverpod providers for real-time Firebase villages data

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Real-time stream of villages with risk data
final villagesStreamProvider =
    StreamProvider<List<Map<String, dynamic>>>((ref) {
  final firestore = FirebaseFirestore.instance;

  return firestore.collection('villages').snapshots().map((snapshot) {
    return snapshot.docs.map((doc) {
      final data = doc.data();
      return {
        'id': doc.id,
        'name': data['name'] ?? 'Unknown Village',
        'district': data['district'] ?? 'Unknown District',
        'lat': (data['latitude'] as num?)?.toDouble() ?? 26.2006,
        'lng': (data['longitude'] as num?)?.toDouble() ?? 92.9376,
        'riskLevel': data['risk_level'] ?? 'LOW',
        'reportCount': data['risk_score'] ?? 0,
        'lastReport': _formatLastReport(data['risk_score'] ?? 0),
        'population': _formatPopulation(data['risk_score'] ?? 0),
      };
    }).toList();
  }).handleError((error) {
    print('Error loading villages: $error');
    return <Map<String, dynamic>>[];
  });
});

// Villages count by risk level
final villagesByRiskProvider = StreamProvider<Map<String, int>>((ref) {
  final firestore = FirebaseFirestore.instance;

  return firestore.collection('villages').snapshots().map((snapshot) {
    final Map<String, int> riskCounts = {
      'LOW': 0,
      'MEDIUM': 0,
      'HIGH': 0,
    };

    for (final doc in snapshot.docs) {
      final riskLevel = doc.data()['risk_level'] as String? ?? 'LOW';
      riskCounts[riskLevel] = (riskCounts[riskLevel] ?? 0) + 1;
    }

    return riskCounts;
  }).handleError((error) {
    print('Error loading villages by risk: $error');
    return {'LOW': 0, 'MEDIUM': 0, 'HIGH': 0};
  });
});

// High risk villages
final highRiskVillagesProvider =
    StreamProvider<List<Map<String, dynamic>>>((ref) {
  final firestore = FirebaseFirestore.instance;

  return firestore
      .collection('villages')
      .where('risk_level', isEqualTo: 'HIGH')
      .snapshots()
      .map((snapshot) {
    return snapshot.docs.map((doc) {
      final data = doc.data();
      return {
        'name': data['name'] ?? 'Unknown Village',
        'district': data['district'] ?? 'Unknown District',
        'riskLevel': data['risk_level'] ?? 'HIGH',
        'riskScore': data['risk_score'] ?? 0,
      };
    }).toList();
  }).handleError((error) {
    print('Error loading high risk villages: $error');
    return <Map<String, dynamic>>[];
  });
});

String _formatLastReport(int riskScore) {
  if (riskScore == 0) return '1 week ago';
  if (riskScore < 5) return '3 days ago';
  if (riskScore < 10) return '1 day ago';
  return '2 hours ago';
}

String _formatPopulation(int riskScore) {
  // Mock population based on risk score
  final base = 1000 + (riskScore * 100);
  if (base < 1000) return '${(base / 100).toStringAsFixed(1)}K';
  return '${(base / 1000).toStringAsFixed(1)}K';
}
