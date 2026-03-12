// lib/add_sample_data.dart
// Script to add sample data to Firestore for testing

import 'package:cloud_firestore/cloud_firestore.dart';

class SampleDataService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> addSampleData() async {
    try {
      // Add sample reports
      await _addSampleReports();

      // Add sample alerts
      await _addSampleAlerts();

      // Add sample villages
      await _addSampleVillages();

      // Add sample officials
      await _addSampleOfficials();

      print('✅ Sample data added successfully!');
    } catch (e) {
      print('❌ Error adding sample data: $e');
    }
  }

  static Future<void> _addSampleReports() async {
    final reports = [
      {
        'intent': 'SYMPTOM',
        'phone': '919876543210',
        'message':
            'Multiple people in our village are experiencing fever, diarrhea, and vomiting. Started 2 days ago after drinking from the community well.',
        'timestamp': Timestamp.now(),
        'language': 'AS',
        'alerted': true,
      },
      {
        'intent': 'WATER',
        'phone': '919876543211',
        'message':
            'The water from our tube well has turned brown and smells bad. Many families are affected.',
        'timestamp': Timestamp.fromDate(
            DateTime.now().subtract(const Duration(hours: 2))),
        'language': 'HI',
        'alerted': false,
      },
      {
        'intent': 'ANIMAL',
        'phone': '919876543212',
        'message':
            'Dead fish found floating in the village pond. Water looks contaminated.',
        'timestamp': Timestamp.fromDate(
            DateTime.now().subtract(const Duration(hours: 5))),
        'language': 'EN',
        'alerted': false,
      },
    ];

    for (final report in reports) {
      await _firestore.collection('reports').add(report);
    }
  }

  static Future<void> _addSampleAlerts() async {
    final alerts = [
      {
        'intent': 'SYMPTOM',
        'phone': '919876543210',
        'report_count': 12,
        'triggered_at': Timestamp.fromDate(
            DateTime.now().subtract(const Duration(hours: 2))),
        'resolved': false,
      },
      {
        'intent': 'WATER',
        'phone': '919876543211',
        'report_count': 5,
        'triggered_at': Timestamp.fromDate(
            DateTime.now().subtract(const Duration(hours: 4))),
        'resolved': false,
      },
    ];

    for (final alert in alerts) {
      await _firestore.collection('alerts').add(alert);
    }
  }

  static Future<void> _addSampleVillages() async {
    final villages = [
      {
        'name': 'Majuli',
        'district': 'Majuli District',
        'latitude': 26.9509,
        'longitude': 94.2037,
        'risk_level': 'HIGH',
        'risk_score': 12,
      },
      {
        'name': 'Jorhat',
        'district': 'Jorhat District',
        'latitude': 26.7509,
        'longitude': 94.2037,
        'risk_level': 'MEDIUM',
        'risk_score': 3,
      },
      {
        'name': 'Dibrugarh',
        'district': 'Dibrugarh District',
        'latitude': 27.4728,
        'longitude': 94.9120,
        'risk_level': 'LOW',
        'risk_score': 0,
      },
    ];

    for (final village in villages) {
      await _firestore.collection('villages').add(village);
    }
  }

  static Future<void> _addSampleOfficials() async {
    final officials = [
      {
        'name': 'Dr. Priya Sharma',
        'role': 'BMO',
        'phone': '+91 98765 43210',
        'email': 'priya.sharma@health.gov.in',
        'district': 'Jorhat District',
      },
      {
        'name': 'Ritu Devi',
        'role': 'ASHA Worker',
        'phone': '+91 98765 43211',
        'email': 'ritu.devi@asha.gov.in',
        'district': 'Majuli District',
      },
    ];

    for (final official in officials) {
      await _firestore.collection('officials').add(official);
    }
  }
}
