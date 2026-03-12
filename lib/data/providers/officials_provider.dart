// lib/data/providers/officials_provider.dart
// Riverpod providers for real-time Firebase officials data

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Real-time stream of health officials
final officialsStreamProvider =
    StreamProvider<List<Map<String, dynamic>>>((ref) {
  final firestore = FirebaseFirestore.instance;

  return firestore
      .collection('officials')
      .orderBy('name')
      .snapshots()
      .map((snapshot) {
    return snapshot.docs.map((doc) {
      final data = doc.data();
      return {
        'id': doc.id,
        'name': data['name'] ?? 'Unknown Official',
        'role': data['role'] ?? 'Health Worker',
        'phone': data['phone'] ?? '+91 XXXXX XXXXX',
        'email': data['email'] ?? 'official@health.gov.in',
        'district': data['district'] ?? 'Unknown District',
      };
    }).toList();
  });
});

// Officials count by role
final officialsByRoleProvider = StreamProvider<Map<String, int>>((ref) {
  final firestore = FirebaseFirestore.instance;

  return firestore.collection('officials').snapshots().map((snapshot) {
    final Map<String, int> roleCounts = {};

    for (final doc in snapshot.docs) {
      final role = doc.data()['role'] as String? ?? 'Health Worker';
      roleCounts[role] = (roleCounts[role] ?? 0) + 1;
    }

    return roleCounts;
  });
});
