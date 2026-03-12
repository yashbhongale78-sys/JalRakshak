// lib/data/models/community_report_model.dart
// Model for community disease reports aggregated by location

import 'package:cloud_firestore/cloud_firestore.dart';

class CommunityReportModel {
  final String id;
  final String location; // village or district
  final String district;
  final String state;
  final Map<String, int> diseaseCounts; // disease type -> count
  final DateTime lastUpdated;
  final int totalCases;
  final String riskLevel; // LOW, MEDIUM, HIGH

  CommunityReportModel({
    required this.id,
    required this.location,
    required this.district,
    required this.state,
    required this.diseaseCounts,
    required this.lastUpdated,
    required this.totalCases,
    required this.riskLevel,
  });

  factory CommunityReportModel.fromMap(Map<String, dynamic> map, String id) {
    return CommunityReportModel(
      id: id,
      location: map['location'] ?? '',
      district: map['district'] ?? '',
      state: map['state'] ?? '',
      diseaseCounts: Map<String, int>.from(map['diseaseCounts'] ?? {}),
      lastUpdated: (map['lastUpdated'] as Timestamp).toDate(),
      totalCases: map['totalCases'] ?? 0,
      riskLevel: map['riskLevel'] ?? 'LOW',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'location': location,
      'district': district,
      'state': state,
      'diseaseCounts': diseaseCounts,
      'lastUpdated': Timestamp.fromDate(lastUpdated),
      'totalCases': totalCases,
      'riskLevel': riskLevel,
    };
  }

  String getRiskLevel() {
    if (totalCases >= 10) return 'HIGH';
    if (totalCases >= 5) return 'MEDIUM';
    return 'LOW';
  }
}

class DiseaseReport {
  final String symptomType;
  final String severity;
  final String description;
  final double lat;
  final double lng;
  final String submittedBy;
  final DateTime timestamp;
  final String status;
  final String district;
  final String village;
  final String state;

  DiseaseReport({
    required this.symptomType,
    required this.severity,
    required this.description,
    required this.lat,
    required this.lng,
    required this.submittedBy,
    required this.timestamp,
    required this.status,
    required this.district,
    required this.village,
    required this.state,
  });

  factory DiseaseReport.fromMap(Map<String, dynamic> map) {
    return DiseaseReport(
      symptomType: map['symptom_type'] ?? '',
      severity: map['severity'] ?? 'Low',
      description: map['description'] ?? '',
      lat: (map['lat'] ?? 0.0).toDouble(),
      lng: (map['lng'] ?? 0.0).toDouble(),
      submittedBy: map['submitted_by'] ?? '',
      timestamp: (map['timestamp'] as Timestamp).toDate(),
      status: map['status'] ?? 'Pending',
      district: map['district'] ?? '',
      village: map['village'] ?? '',
      state: map['state'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'symptom_type': symptomType,
      'severity': severity,
      'description': description,
      'lat': lat,
      'lng': lng,
      'submitted_by': submittedBy,
      'timestamp': Timestamp.fromDate(timestamp),
      'status': status,
      'district': district,
      'village': village,
      'state': state,
    };
  }
}
